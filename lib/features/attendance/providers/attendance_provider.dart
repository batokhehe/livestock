import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:livestock/features/attendance/data/model/attendance_detail.dart';
import 'package:livestock/features/attendance/data/model/attendance_request.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';

import '../../../core/network/dio_client.dart';
import '../../attendance/data/api/attendance_api.dart';
import '../../attendance/data/model/employee_model.dart';
import '../../attendance/data/repository/employee_repository.dart';
import '../../attendance/domain/usecase/get_employee_list_usecase.dart';

/// =====================================================
/// TAB
/// =====================================================

enum AttendanceTab { attendance, overnight }

final attendanceTabProvider = StateProvider<AttendanceTab>((ref) {
  return AttendanceTab.attendance;
});

/// =====================================================
/// EMPLOYEE
/// =====================================================

final employeeRepositoryProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return EmployeeRepository(AttendanceApi(dio));
});

final getEmployeeListUseCaseProvider = Provider((ref) {
  return GetEmployeeListUseCase(ref.read(employeeRepositoryProvider));
});

final employeeListProvider = FutureProvider.autoDispose<List<Employee>>((
  ref,
) async {
  return ref.read(getEmployeeListUseCaseProvider).call();
});

final selectedEmployeeIdProvider = StateProvider<int?>((ref) => null);

final employeeSearchProvider = StateProvider.autoDispose<String>((ref) => '');

/// =====================================================
/// ATTENDANCE DATE & STATUS
/// =====================================================

String get todayDate => DateFormat('yyyy-MM-dd').format(DateTime.now());

final attendanceDateProvider = StateProvider.autoDispose<DateTime?>(
  (ref) => null,
);

class AttendanceStatusNotifier extends StateNotifier<Map<int, bool>> {
  AttendanceStatusNotifier() : super({});

  bool _initialized = false;

  void initFromEmployees(List<Employee> employees) {
    if (_initialized) return; // ⛔ STOP overwrite

    final newState = <int, bool>{};

    for (final e in employees) {
      newState[e.id] = false; // default tidak hadir
    }

    state = newState;
    _initialized = true;
  }

  void mergeFromHistory(List<AttendanceDetail> histories) {
    final newState = {...state};

    for (final h in histories) {
      newState[h.employeeId] = h.status == 'present';
    }

    state = newState;
  }

  void setStatus(int employeeId, bool isPresent) {
    state = {...state, employeeId: isPresent};
  }

  void reset() {
    state = {};
    _initialized = false;
  }
}

final attendanceStatusProvider =
    StateNotifierProvider<AttendanceStatusNotifier, Map<int, bool>>(
      (ref) => AttendanceStatusNotifier(),
    );

/// =====================================================
/// API
/// =====================================================

final attendanceApiProvider = Provider(
  (ref) => AttendanceApi(ref.read(dioProvider)),
);

/// =====================================================
/// FILTER & PAGINATION (STATE KECIL)
/// =====================================================

final attendanceFilterTypeProvider = StateProvider<String>(
  (ref) => 'Bulan Ini',
);

final attendanceDateRangeProvider = StateProvider<DateTimeRange?>(
  (ref) => null,
);

final attendancePageProvider = StateProvider<int>((ref) => 1);

final attendanceSearchProvider = StateProvider<String?>((ref) => null);

final attendanceLocationProvider = StateProvider<FarmLocation?>((ref) => null);

/// =====================================================
/// QUERY (DERIVED STATE - 🔥 PALING PENTING)
/// =====================================================

final attendanceQueryProvider = Provider<AttendanceRequest>((ref) {
  final tab = ref.watch(attendanceTabProvider);
  final filterType = ref.watch(attendanceFilterTypeProvider);
  final dateRange = ref.watch(attendanceDateRangeProvider);
  final page = ref.watch(attendancePageProvider);
  final search = ref.watch(attendanceSearchProvider);
  final location = ref.watch(attendanceLocationProvider);

  String? dateStr;
  String? startDate;
  String? endDate;
  String monthStr = '';

  final now = DateTime.now();

  if (filterType == 'Hari ini') {
    dateStr = DateFormat('yyyy-MM-dd').format(now);
  } else if (filterType == 'Minggu Ini') {
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    startDate = DateFormat('yyyy-MM-dd').format(startOfWeek);
    endDate = DateFormat('yyyy-MM-dd').format(endOfWeek);
  } else if (filterType == 'Rentang tanggal manual' && dateRange != null) {
    startDate = DateFormat('yyyy-MM-dd').format(dateRange.start);
    endDate = DateFormat('yyyy-MM-dd').format(dateRange.end);
  } else {
    monthStr = DateFormat('yyyy-MM').format(now);
  }

  return AttendanceRequest(
    type: tab == AttendanceTab.attendance ? 'regular' : 'overnight',
    month: monthStr,
    date: dateStr,
    page: page,
    perPage: 10,
    sortBy: 'transdate',
    sortDir: 'desc',
    search: search,
    farmLocationId: location?.id,
    startDate: startDate,
    endDate: endDate,
  );
});

class AttendanceHistoryNotifier
    extends AutoDisposeAsyncNotifier<Map<String, dynamic>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<Map<String, dynamic>> build() async {
    _page = 1;
    final query = ref.watch(attendanceQueryProvider);
    final api = ref.read(attendanceApiProvider);

    return await api.getAttendance(
      type: query.type,
      month: query.month,
      date: query.date,
      employeeName: query.employeeName,
      page: _page,
      perPage: 10,
      search: query.search,
      sortBy: query.sortBy,
      sortDir: query.sortDir,
      farmLocationId: query.farmLocationId,
      startDate: query.startDate,
      endDate: query.endDate,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final data = current['data'] as List;
    final total = current['total'] ?? 0;

    if (data.length >= total) return;

    _loadingMore = true;
    _page++;

    final query = ref.read(attendanceQueryProvider);
    final api = ref.read(attendanceApiProvider);

    final result = await api.getAttendance(
      type: query.type,
      month: query.month,
      date: query.date,
      employeeName: query.employeeName,
      page: _page,
      perPage: 10,
      search: query.search,
      sortBy: query.sortBy,
      sortDir: query.sortDir,
      farmLocationId: query.farmLocationId,
      startDate: query.startDate,
      endDate: query.endDate,
    );

    final merged = [...data, ...result['data']];

    state = AsyncData({...result, 'data': merged});

    _loadingMore = false;
  }
}

final attendanceHistoryNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      AttendanceHistoryNotifier,
      Map<String, dynamic>
    >(() => AttendanceHistoryNotifier());

/// =====================================================
/// HISTORY LIST
/// =====================================================

final attendanceHistoryProvider =
    FutureProvider.family<List, AttendanceRequest>((ref, query) async {
      final api = ref.read(attendanceApiProvider);

      final response = await api.getAttendance(
        type: query.type,
        month: query.month,
        date: query.date,
        employeeName: query.employeeName,
        page: query.page,
        perPage: query.perPage,
        search: query.search,
        sortBy: query.sortBy,
        sortDir: query.sortDir,
        farmLocationId: query.farmLocationId,
        startDate: query.startDate,
        endDate: query.endDate,
      );

      return response['data'];
    });

/// =====================================================
/// DETAIL
/// =====================================================

final attendanceDetailProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String type, String transDate, String id})
    >((ref, param) async {
      final api = ref.read(attendanceApiProvider);

      final response = await api.getAttendanceDetail(
        type: param.type,
        transDate: param.transDate,
        attendanceLogId: param.id,
      );

      final List data = response['data'];

      return {
        'id': param.id,
        'transdate': param.transDate,
        'details': data,
      };
    });

final attendanceInitProvider = FutureProvider.autoDispose<void>((ref) async {
  debugPrint('🔥 INIT START');

  // 1️⃣ fetch employee
  final employees = await ref.watch(employeeListProvider.future);
  debugPrint('🔥 EMPLOYEE FETCHED');

  final statusNotifier = ref.read(attendanceStatusProvider.notifier);
  statusNotifier.reset();
  statusNotifier.initFromEmployees(employees);

  // 2️⃣ fetch attendance detail MANUAL (TANPA provider)
  final api = ref.read(attendanceApiProvider);
  debugPrint('🔥 FETCH ATTENDANCE DETAIL');

  final histories = await api.getAttendanceEmployeeDetail(transDate: todayDate);

  debugPrint('🔥 DETAIL FETCHED: ${histories.length}');

  // 3️⃣ merge
  statusNotifier.mergeFromHistory(histories);
});

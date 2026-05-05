import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:livestock/features/attendance/data/model/attendance_detail.dart';
import 'package:livestock/features/attendance/data/model/attendance_request.dart';

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
      newState[e.id] = true; // default hadir
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

final attendanceMonthProvider = StateProvider<String>((ref) {
  return '2026-01';
});

final attendancePageProvider = StateProvider<int>((ref) => 1);

final attendanceSearchProvider = StateProvider<String?>((ref) => null);

/// =====================================================
/// QUERY (DERIVED STATE - 🔥 PALING PENTING)
/// =====================================================

final attendanceQueryProvider = Provider<AttendanceRequest>((ref) {
  final tab = ref.watch(attendanceTabProvider);
  final month = ref.watch(attendanceMonthProvider);
  final page = ref.watch(attendancePageProvider);
  final search = ref.watch(attendanceSearchProvider);

  return AttendanceRequest(
    type: tab == AttendanceTab.attendance ? 'regular' : 'overnight',
    month: month,
    page: page,
    perPage: 10,
    search: search,
  );
});

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
      );

      return response['data'];
    });

/// =====================================================
/// DETAIL
/// =====================================================

final attendanceDetailProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String type, String transDate})
    >((ref, param) async {
      final api = ref.read(attendanceApiProvider);

      final response = await api.getAttendance(
        type: param.type,
        month: param.transDate.substring(0, 7),
        date: param.transDate,
        page: 1,
        perPage: 1,
      );

      final List data = response['data'];

      if (data.isEmpty) {
        throw Exception('Data absensi tidak ditemukan');
      }

      return data.first;
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

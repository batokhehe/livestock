import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/attendance/data/api/employee_api.dart';

import '../../../core/network/dio_client.dart';
import '../data/model/employee_model.dart';

final attendanceDateProvider = StateProvider<DateTime?>(
  (ref) => DateTime.now(),
);

final attendanceStatusProvider =
    StateNotifierProvider<AttendanceStatusNotifier, Map<int, bool>>(
      (ref) => AttendanceStatusNotifier(ref),
    );

final attendanceApiProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return EmployeeApi(dio);
});

class AttendanceStatusNotifier extends StateNotifier<Map<int, bool>> {
  AttendanceStatusNotifier(this.ref) : super({});

  final Ref ref;

  void init(List<Employee> employees) {
    if (state.isNotEmpty) return;

    state = {for (final e in employees) e.id: true};
  }

  void setStatus(int employeeId, bool isHadir) {
    state = {...state, employeeId: isHadir};
  }

  void reset() {
    state = {};
  }
}

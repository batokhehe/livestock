import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../attendance/data/api/employee_api.dart';
import '../../attendance/data/model/employee_model.dart';
import '../../attendance/data/repository/employee_repository.dart';
import '../../attendance/domain/usecase/get_employee_list_usecase.dart';

final employeeRepositoryProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return EmployeeRepository(EmployeeApi(dio));
});

final getEmployeeListUseCaseProvider = Provider((ref) {
  return GetEmployeeListUseCase(ref.read(employeeRepositoryProvider));
});

final employeeListProvider = FutureProvider<List<Employee>>((ref) async {
  return ref.read(getEmployeeListUseCaseProvider).call();
});

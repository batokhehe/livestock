import '../api/employee_api.dart';
import '../model/employee_model.dart';

class EmployeeRepository {
  final EmployeeApi api;

  EmployeeRepository(this.api);

  Future<List<Employee>> getEmployees() async {
    final res = await api.getEmployees();
    return res.data;
  }
}

import '../../data/model/employee_model.dart';
import '../../data/repository/employee_repository.dart';

class GetEmployeeListUseCase {
  final EmployeeRepository repository;

  GetEmployeeListUseCase(this.repository);

  Future<List<Employee>> call() {
    return repository.getEmployees();
  }
}

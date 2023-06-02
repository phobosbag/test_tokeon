abstract class EmployeeRepository {
  Future<List<dynamic>> getEmployee();

  Future<void> removeEmployee(String email);

  Future<void> editEmployee(String email, Map<String, dynamic> employee);

  Future<void> addEmployee(Map<String, dynamic> employee);
}

abstract class AuthRepository {
  Future<String> login(String email, password);

  Future<void> logout(String token);
}

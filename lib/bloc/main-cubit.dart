import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_tokeon/bloc/abstract-cubit.dart';
import 'package:test_tokeon/domain/entities/employee.dart';
import 'package:test_tokeon/domain/repository/abstract_repository.dart';

class MainCubit extends Cubit<CubitState<List<Employee>>> {
  final List<Employee> _listEmployee = [];

  final employeeRepository = GetIt.instance<EmployeeRepository>();

  MainCubit() : super(CubitState(true, <Employee>[]));

  Future<void> initCubit() async {
    emit(CubitState(true, <Employee>[]));
    _listEmployee.clear();
    for (var element in (await employeeRepository.getEmployee())) {
      _listEmployee.add(Employee.fromJson(element));
    }
    emit(CubitState(false, _listEmployee));
  }

  Future<void> removeEmployee({
    required Employee currentEmployee,
  }) async {
    emit(CubitState(true, _listEmployee));
    employeeRepository.removeEmployee(currentEmployee.email);
    _listEmployee.remove(currentEmployee);
    emit(CubitState(false, _listEmployee));
  }

  Future<void> editEmployee({
    required Employee currentEmployee,
    required String firstName,
    required String lastName,
    required String fatherName,
    required String phone,
    required String email,
    required String birthDate,
    required String comment,
  }) async {
    emit(CubitState(true, _listEmployee));
    Map<String, dynamic> json = {
      'firstName': firstName,
      'lastName': lastName,
      'fatherName': fatherName,
      'phone': phone,
      'email': email,
      'comment': comment,
      'birthDate': birthDate,
    };
    await employeeRepository.editEmployee(currentEmployee.email, json);
    int index = _listEmployee.indexOf(currentEmployee);
    _listEmployee.remove(currentEmployee);
    _listEmployee.insert(index, Employee.fromJson(json));
    emit(CubitState(false, _listEmployee));
  }

  Future<void> addEmployee({
    required String firstName,
    required String lastName,
    required String fatherName,
    required String phone,
    required String email,
    required String birthDate,
    required String comment,
  }) async {
    Map<String, dynamic> json = {
      'firstName': firstName,
      'lastName': lastName,
      'fatherName': fatherName,
      'phone': phone,
      'email': email,
      'comment': comment,
      'birthDate': birthDate,
    };
    emit(CubitState(true, _listEmployee));
    await employeeRepository.addEmployee(json);
    _listEmployee.add(Employee.fromJson(json));
    emit(CubitState(false, _listEmployee));
  }
}

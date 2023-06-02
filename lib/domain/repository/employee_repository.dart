import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_tokeon/domain/repository/abstract_repository.dart';

class EmployeeRepositorySecureStorage implements EmployeeRepository {
  EmployeeRepositorySecureStorage();

  final storage = const FlutterSecureStorage();

  @override
  Future<List<dynamic>> getEmployee() async {
    return jsonDecode((await storage.read(key: 'listEmployee') ?? '[]'));
  }

  @override
  Future<void> removeEmployee(String email) async {
    final list = await getEmployee();
    for (final item in list) {
      if (item['email']==email) {
        list.remove(item);
        break;
      }
    }
    await storage.write(key: 'listEmployee', value: jsonEncode(list));
  }

  @override
  Future<void> editEmployee(String email, Map<String, dynamic> employee) async {
    final list = await getEmployee();
    for (final item in list) {
      if (item['email'] == email) {
        int index = list.indexOf(item);
        list.remove(item);
        list.insert(index,employee);
        break;
      }
    }
    await storage.write(key: 'listEmployee', value: jsonEncode(list));
  }

  @override
  Future<void> addEmployee(Map<String, dynamic> employee) async {
    final list = await getEmployee();
    list.add(employee);
    await storage.write(key: 'listEmployee', value: jsonEncode(list));
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  final String firstName, lastName, fatherName, phone, email, comment, birthDate;

  Employee(
      {required this.firstName,
      required this.lastName,
      this.fatherName = '',
      required this.phone,
      required this.email,
      this.comment = '',
      required this.birthDate});

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}

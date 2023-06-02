// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      fatherName: json['fatherName'] as String? ?? '',
      phone: json['phone'] as String,
      email: json['email'] as String,
      comment: json['comment'] as String? ?? '',
      birthDate: json['birthDate'] as String,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fatherName': instance.fatherName,
      'phone': instance.phone,
      'email': instance.email,
      'comment': instance.comment,
      'birthDate': instance.birthDate,
    };

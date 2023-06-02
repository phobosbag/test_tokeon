// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth-user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => AuthUser(
      token: json['token'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'email': instance.email,
      'token': instance.token,
    };

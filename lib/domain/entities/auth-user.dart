import 'package:json_annotation/json_annotation.dart';

part 'auth-user.g.dart';

@JsonSerializable()
class AuthUser {

  final String  email, token;

  bool get isAuth => token!='';

  AuthUser({required this.token, required this.email});

  AuthUser.undefined() : email = '', token = '';

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

}
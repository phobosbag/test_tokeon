import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:test_tokeon/bloc/abstract-cubit.dart';
import 'package:test_tokeon/domain/entities/auth-user.dart';
import 'package:test_tokeon/domain/repository/abstract_repository.dart';

class AuthCubit extends Cubit<CubitState<AuthUser>> {
  AuthUser _user = AuthUser.undefined();

  final storage = const FlutterSecureStorage();
  final authRepository = GetIt.instance<AuthRepository>();

  AuthCubit() : super(CubitState(true, AuthUser.undefined()));

  Future<void> initCubit() async {
    emit(CubitState(true, AuthUser.undefined()));

    final userFromStorage = await storage.read(key: 'user');

    if (userFromStorage != null) {
      _user = AuthUser.fromJson(jsonDecode(userFromStorage));
    } else {
      _user = AuthUser.undefined();
    }
    emit(CubitState(false, _user));
  }

  Future<void> login(String email, password) async {
    try {
      emit(CubitState(true, _user));
      final token = await authRepository.login(email, password);
      _user = AuthUser(token: token, email: email);
      await storage.write(key: 'user', value: jsonEncode(_user));
      emit(CubitState(false, _user));
    } catch (e) {
      emit(CubitState(false, AuthUser.undefined(), errorMsg: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(CubitState(false, _user));
    _user = AuthUser.undefined();
    storage.delete(key: 'user');
    authRepository.logout(_user.token);
  }
}

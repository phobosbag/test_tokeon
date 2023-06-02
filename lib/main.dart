import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_tokeon/bloc/auth-cubit.dart';
import 'package:test_tokeon/bloc/main-cubit.dart';
import 'package:test_tokeon/domain/repository/abstract_repository.dart';
import 'package:test_tokeon/domain/repository/auth_repository.dart';
import 'package:test_tokeon/domain/repository/employee_repository.dart';
import 'package:test_tokeon/presenter/screens/splash-screen.dart';

void main() {

  final getIt = GetIt.instance;
  getIt.registerSingleton<AuthRepository>(AuthRepositoryMock());
  getIt.registerSingleton<EmployeeRepository>(EmployeeRepositorySecureStorage());

  getIt.registerSingleton<AuthCubit>(AuthCubit());
  getIt.registerSingleton<MainCubit>(MainCubit());

  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: 'Справочник работников компании',
    );
  }
}
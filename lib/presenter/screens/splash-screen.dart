import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_tokeon/bloc/auth-cubit.dart';
import 'package:test_tokeon/bloc/abstract-cubit.dart';
import 'package:test_tokeon/domain/entities/auth-user.dart';
import 'package:test_tokeon/presenter/screens/auth-screen.dart';
import 'package:test_tokeon/presenter/screens/main-screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final authBloc = GetIt.instance<AuthCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      authBloc.initCubit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder(
      bloc: authBloc,
      buildWhen: (_, CubitState<AuthUser> stateB) {
        if (stateB.isLoading == false) {
          if (stateB.data.isAuth) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
          }
          return false;
        }
        return true;
      },
      builder: (BuildContext context, CubitState<AuthUser> state) => const Center(child: CircularProgressIndicator()),
    ));
  }
}

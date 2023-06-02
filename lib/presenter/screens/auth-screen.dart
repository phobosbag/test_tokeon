import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_tokeon/bloc/auth-cubit.dart';
import 'package:test_tokeon/bloc/abstract-cubit.dart';
import 'package:test_tokeon/domain/entities/auth-user.dart';
import 'package:test_tokeon/presenter/screens/main-screen.dart';
import 'package:form_validator/form_validator.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final authBloc = GetIt.instance<AuthCubit>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Авторизация'),
        ),
        body: BlocBuilder(
          bloc: authBloc,
          buildWhen: (_, CubitState<AuthUser> stateB) {
            if (stateB.errorMsg.isNotEmpty) {
              ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                padding: const EdgeInsets.all(20),
                content: Text(stateB.errorMsg.replaceFirst('Exception: ', '')),
                leading: const Icon(Icons.warning_amber),
                backgroundColor: Colors.green,
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ));
            }
            if (stateB.isLoading == false) {
              if (stateB.data.isAuth) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              }
              return false;
            }
            return true;
          },
          builder: (BuildContext context, CubitState<AuthUser> state) {
            return SingleChildScrollView(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 120,
                                ),
                                const Text('Введите email:'),
                                TextFormField(
                                  controller: controllerEmail,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  validator: ValidationBuilder(requiredMessage: 'Введите email')
                                      .email('Email введен не верно')
                                      .build(),
                                ),
                                const SizedBox(
                                  height: 36,
                                ),
                                const Text('Введите пароль'),
                                TextFormField(
                                  controller: controllerPassword,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  obscureText: true,
                                  validator: ValidationBuilder(requiredMessage: 'Введите пароль')
                                      .minLength(8, 'Пароль должен быть больше 8 символов')
                                      .maxLength(50, 'Email не должен быть больше 50 символов')
                                      .regExp(RegExp(r'[a-z]'), 'Пароль должен содержать минимум одну строчную букву')
                                      .regExp(RegExp(r'[A-Z]'), 'Пароль должен содержать минимум одну заглавную букву')
                                      .regExp(RegExp(r'\d'), 'Пароль должен содержать минимум одну цифру')
                                      .build(),
                                ),
                                const SizedBox(
                                  height: 36,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate() && !state.isLoading) {
                                        authBloc.login(controllerEmail.text, controllerPassword.text);
                                      }
                                    },
                                    child: const Text('Войти'))
                              ],
                            )))));
          },
        ));
  }
}

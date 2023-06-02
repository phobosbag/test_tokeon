import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_tokeon/bloc/auth-cubit.dart';
import 'package:test_tokeon/bloc/abstract-cubit.dart';
import 'package:test_tokeon/bloc/main-cubit.dart';
import 'package:test_tokeon/domain/entities/employee.dart';
import 'package:test_tokeon/presenter/screens/edit-screen.dart';
import 'package:test_tokeon/presenter/screens/splash-screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final bloc = GetIt.instance<MainCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bloc.initCubit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Список сотрудников'),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditScreen()),
                    );
                  },
                  child: const Text('Добавить'),
                )),
            Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    await GetIt.instance<AuthCubit>().logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SplashScreen()),
                    );
                  },
                  child: const Text('Выход'),
                ))
          ],
        ),
        body: BlocBuilder(
          bloc: bloc,
          builder: (BuildContext context, CubitState<List<Employee>> state) {
            return SingleChildScrollView(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                        child: state.isLoading
                            ? const CircularProgressIndicator()
                            : state.data.isEmpty
                                ? const Text('Список пуст')
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: state.data
                                        .map((e) => GestureDetector(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => EditScreen(
                                                          employee: e,
                                                        )),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              child: Wrap(
                                                children: [
                                                  Text('${state.data.indexOf(e) + 1}. ФИО:${e.firstName} '),
                                                  Text('${e.lastName} '),
                                                  Text('${e.fatherName}, '),
                                                  Text('телефон:${e.phone} '),
                                                  const Text(
                                                    'Редактировать',
                                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            )))
                                        .toList(),
                                  ))));
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:test_tokeon/bloc/abstract-cubit.dart';
import 'package:test_tokeon/bloc/main-cubit.dart';
import 'package:test_tokeon/domain/entities/employee.dart';
import 'package:form_validator/form_validator.dart';

class EditScreen extends StatefulWidget {
  final Employee? employee;

  const EditScreen({super.key, this.employee});

  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  final bloc = GetIt.instance<MainCubit>();
  final controllerFirstName = TextEditingController();
  final controllerLastName = TextEditingController();
  final controllerFatherName = TextEditingController();
  final controllerPhone = TextEditingController(text: '+7 (');
  final controllerEmail = TextEditingController();
  final controllerBirthDate = TextEditingController();
  final controllerComment = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.employee != null) {
      controllerFirstName.text = widget.employee!.firstName;
      controllerLastName.text = widget.employee!.lastName;
      controllerFatherName.text = widget.employee!.fatherName;
      controllerEmail.text = widget.employee!.email;
      controllerBirthDate.text = widget.employee!.birthDate;
      controllerComment.text = widget.employee!.comment;
      if (widget.employee!.phone.isNotEmpty) {
        controllerPhone.text = widget.employee!.phone;
      }
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.employee == null ? 'Добавление нового сотрудника' : 'Редактирование информации о сотруднике'),
          actions: [
            if (widget.employee != null)
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: () async {
                        await bloc.removeEmployee(currentEmployee: widget.employee!);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Удалить')))
          ],
        ),
        body: BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, CubitState<List<Employee>> state) {
              if (state.isLoading)
                return const Center(
                  child: CircularProgressIndicator(),
                );
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
                                  const Text('Фамилия: (обязательное поле)'),
                                  TextFormField(
                                    controller: controllerLastName,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: ValidationBuilder(requiredMessage: 'Введите фамилию')
                                        .maxLength(50, 'Фамилия не должен быть больше 50 символов')
                                        .regExp(RegExp(r"^[a-zA-Zа-яА-Я]+$"), 'Фамилия должна состоять из букв')
                                        .build(),
                                  ),
                                  const SizedBox(
                                    height: 36,
                                  ),
                                  const Text('Имя: (обязательное поле)'),
                                  TextFormField(
                                    controller: controllerFirstName,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: ValidationBuilder(requiredMessage: 'Введите имя')
                                        .maxLength(50, 'Имя не должен быть больше 50 символов')
                                        .regExp(RegExp(r"^[a-zA-Zа-яА-Я]+$"), 'Имя должно состоять из букв')
                                        .build(),
                                  ),
                                  const SizedBox(
                                    height: 36,
                                  ),
                                  const Text('Отчество:'),
                                  TextFormField(
                                    controller: controllerFatherName,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: ValidationBuilder(optional: true)
                                        .maxLength(50, 'Отчество не должен быть больше 50 символов')
                                        .regExp(RegExp(r"^[a-zA-Zа-яА-Я]+$"), 'Отчество должно состоять из букв')
                                        .build(),
                                  ),
                                  const SizedBox(
                                    height: 36,
                                  ),
                                  const Text('Телефон: (обязательное поле)'),
                                  TextFormField(
                                    controller: controllerPhone,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    inputFormatters: [MaskTextInputFormatter(mask: '+7 (###) ###-##-##')],
                                    onChanged: (e) {
                                      if (e.length < 4) {
                                        controllerPhone.text = '+7 (';
                                        controllerPhone.selection = TextSelection.fromPosition(
                                            TextPosition(offset: controllerPhone.text.length));
                                      }
                                    },
                                    validator: ValidationBuilder(requiredMessage: 'Введите номер телефона')
                                        .phone('Телефон введен не верно')
                                        .minLength(18, 'Телефон введен не полностью')
                                        .build(),
                                  ),
                                  const SizedBox(
                                    height: 36,
                                  ),
                                  const Text('Email: (обязательное поле)'),
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
                                  const Text('Дата рождения: (обязательное поле)'),
                                  TextFormField(
                                    controller: controllerBirthDate,
                                    inputFormatters: [MaskTextInputFormatter(mask: "##.##.####")],
                                    decoration: InputDecoration(
                                        hintText: "31.12.2000",
                                        suffixIcon: IconButton(
                                            onPressed: () async {
                                              DateTime? currentDT;
                                              if (controllerBirthDate.text.isNotEmpty) {
                                                try {
                                                  currentDT = DateTime.parse(
                                                      controllerBirthDate.text.split('.').reversed.join(''));
                                                } catch (_) {}
                                              }
                                              final dt = await showDatePicker(
                                                  context: context,
                                                  initialDate: currentDT ?? DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime.now());
                                              if (dt != null) {
                                                controllerBirthDate.text =
                                                    '${dt.day <= 9 ? '0' : ''}${dt.day}.${dt.month <= 9 ? '0' : ''}${dt.month}.${dt.year}';
                                              }
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.date_range,
                                              size: 32,
                                            ))),
                                    keyboardType: TextInputType.phone,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: ValidationBuilder(requiredMessage: 'Введите дату рождения')
                                        .minLength(10, 'Проверьте дату рождения, формат даты: ДД.ММ.ГГГГ')
                                        .maxLength(10, 'Проверьте дату рождения, формат даты: ДД.ММ.ГГГГ')
                                        .add((s) {
                                      final List<String> list = s!.split('.');

                                      final y = int.parse(list[2]);
                                      if (y < 1900 || y > DateTime.now().year) {
                                        return 'Проверьте дату рождения, формат даты: ДД.ММ.ГГГГ';
                                      } else {
                                        if ((DateTime.parse('${list[2]}-${list[1]}-${list[0]}')).day !=
                                            int.parse(list[0])) {
                                          return 'Проверьте дату рождения, формат даты: ДД.ММ.ГГГГ';
                                        }
                                      }
                                      return null;
                                    }).build(),
                                  ),
                                  const SizedBox(
                                    height: 36,
                                  ),
                                  const Text('Комментарий'),
                                  TextFormField(
                                    controller: controllerComment,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: ValidationBuilder(optional: true)
                                        .maxLength(500, 'Комментарий не должен быть больше 500 символов')
                                        .build(),
                                  ),
                                  const SizedBox(
                                    height: 36,
                                  ),
                                  state.isLoading
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              if (widget.employee == null) {
                                                await bloc.addEmployee(
                                                    firstName: controllerFirstName.text,
                                                    lastName: controllerLastName.text,
                                                    fatherName: controllerFatherName.text,
                                                    phone: controllerPhone.text,
                                                    email: controllerEmail.text,
                                                    birthDate: controllerBirthDate.text,
                                                    comment: controllerComment.text);
                                                Navigator.of(context).pop();
                                              } else {
                                                await bloc.editEmployee(
                                                  currentEmployee: widget.employee!,
                                                  firstName: controllerFirstName.text,
                                                  lastName: controllerLastName.text,
                                                  fatherName: controllerFatherName.text,
                                                  phone: controllerPhone.text,
                                                  email: controllerEmail.text,
                                                  birthDate: controllerBirthDate.text,
                                                  comment: controllerComment.text,
                                                );
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: const Text('Сохранить')),
                                  const SizedBox(
                                    height: 120,
                                  ),
                                ],
                              )))));
            }));
  }
}

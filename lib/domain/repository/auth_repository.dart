import 'package:test_tokeon/domain/repository/abstract_repository.dart';

class AuthRepositoryMock implements AuthRepository {
  AuthRepositoryMock();

  final Map<String, String> clients = {'user@ya.ru': 'Pass4321', 'admin@ya.ru': 'Pass1234'};

  @override
  Future<String> login(String email, password) async {
    if (clients[email.toLowerCase()] == password) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      throw Exception('Неправильный логин или пароль');
    }
  }

  @override
  Future<void> logout(String token) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

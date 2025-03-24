import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Verifica se o usuário está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Armazena os dados do usuário após login bem-sucedido
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userData['id'].toString());
    await prefs.setString('userName', userData['nome']);
    await prefs.setString('userEmail', userData['email']);
    await prefs.setString('userTrainingStyle', userData['estiloTreino']);
  }

  // Recupera os dados do usuário
  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('userId'),
      'nome': prefs.getString('userName'),
      'email': prefs.getString('userEmail'),
      'estiloTreino': prefs.getString('userTrainingStyle'),
    };
  }

  // Realiza o logout limpando todos os dados
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userTrainingStyle');
  }
}
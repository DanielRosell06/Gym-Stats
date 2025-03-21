import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para os campos do formulário
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Variável para controlar o estado de carregamento
  bool _isLoading = false;
  bool _mostrarSenha = false;

  // Método para enviar os dados para a API
  Future<void> _realizarLogin() async {
    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      _mostrarMensagem('Preencha todos os campos');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:3000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': _emailController.text,
          'Senha': _senhaController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login bem sucedido
        _mostrarMensagem('Login feito com suscesso!');
      } else {
        _mostrarMensagem(responseData['erro'] ?? 'Erro desconhecido');
      }
    } catch (e) {
      _mostrarMensagem('Erro na conexão: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarMensagem(String mensagem, {bool sucesso = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: sucesso ? Colors.green : Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.fitness_center,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Bem-vindo de volta!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Faça login para continuar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _senhaController,
                      obscureText: !_mostrarSenha,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _mostrarSenha
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navegação para a tela de recuperação de senha
                        },
                        child: Text('Esqueceu a senha?'),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Botão de login
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          onPressed: _realizarLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            minimumSize: Size(double.infinity, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'ENTRAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    SizedBox(height: 16),

                    // Link para cadastro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Não tem uma conta?'),
                        TextButton(
                          onPressed: () {
                            // Navegação para a tela de cadastro
                          },
                          child: Text('Cadastre-se'),
                        ),
                      ],
                    ),

                    // Separador
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('ou continue com'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),

                    // Botões de login social
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialLoginButton(Icons.g_mobiledata, 'Google'),
                        _socialLoginButton(Icons.facebook, 'Facebook'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialLoginButton(IconData icon, String provider) {
    return OutlinedButton.icon(
      onPressed: () {
        // Implementar login social
      },
      icon: Icon(icon),
      label: Text(provider),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

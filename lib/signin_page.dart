import 'package:flutter/material.dart';
import 'package:gym_stats/login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores para os campos do formulário
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  final TextEditingController _idadeController = TextEditingController();

  // Variáveis para armazenar os valores selecionados
  int _estiloTreino = 0; // 0 = por dia, 1 = sequencial
  bool _treinaTodosDias = false;

  // Dias da semana
  final List<String> _diasSemana = [
    'seg',
    'ter',
    'qua',
    'qui',
    'sex',
    'sab',
    'dom',
  ];
  final List<String> _diasSemanaCompleto = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo',
  ];
  Map<String, bool> _diasSelecionados = {
    'seg': false,
    'ter': false,
    'qua': false,
    'qui': false,
    'sex': false,
    'sab': false,
    'dom': false,
  };

  // Variável para controlar o estado de carregamento
  bool _isLoading = false;

  // Método para atualizar os dias selecionados quando a checkbox for marcada
  void _atualizarDiasSelecionados(bool value) {
    setState(() {
      _treinaTodosDias = value;

      // Se marcou "Não treina em dias específicos"
      if (value) {
        // Marcar todos os dias da semana
        for (var dia in _diasSemana) {
          _diasSelecionados[dia] = true;
        }
        // Forçar estilo sequencial
        _estiloTreino = 1;
      }
    });
  }

  // Método para enviar os dados para a API
  Future<void> _cadastrarUsuario() async {
    // Validar os campos
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty ||
        _confirmarSenhaController.text.isEmpty) {
      _mostrarMensagem('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    // Validar se as senhas são iguais
    if (_senhaController.text != _confirmarSenhaController.text) {
      _mostrarMensagem('As senhas não conferem.');
      return;
    }

    // Verificar se pelo menos um dia da semana está selecionado
    if (!_diasSelecionados.values.contains(true)) {
      _mostrarMensagem('Selecione pelo menos um dia de treino.');
      return;
    }

    // Preparar os dados para envio
    List<String> diasAtivos = [];
    _diasSelecionados.forEach((dia, selecionado) {
      if (selecionado) {
        diasAtivos.add(dia);
      }
    });

    Map<String, dynamic> dadosUsuario = {
      'NomeUsuario': _nomeController.text,
      'Email': _emailController.text,
      'Senha': _senhaController.text,
      'EstiloTreino': _estiloTreino,
      'DiasAtivos': diasAtivos,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      // Enviar requisição POST para a API
      final response = await http.post(
        Uri.parse('http://192.168.1.4:3000/api/usuario'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dadosUsuario),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        // Cadastro realizado com sucesso
        _mostrarMensagem('Usuário cadastrado com sucesso!', sucesso: true);
        // Aqui você pode adicionar a navegação para a tela de login
      } else {
        // Erro ao cadastrar
        Map<String, dynamic> responseData = jsonDecode(response.body);
        _mostrarMensagem('Erro ao cadastrar: ${responseData['erro']}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _mostrarMensagem('Erro de conexão: $e');
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
              'Crie sua conta',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campos de texto para dados pessoais
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome completo',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
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
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _confirmarSenhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar senha',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Seção de Estilo de Treino
                    Text(
                      'Estilo de Treino',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Opção de "Não treina em dias específicos"
                    CheckboxListTile(
                      title: Text('Não treino em dias específicos'),
                      value: _treinaTodosDias,
                      onChanged: (value) {
                        _atualizarDiasSelecionados(value ?? false);
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    // Opções de estilo de treino
                    RadioListTile<int>(
                      title: Text('Treino por dia da semana'),
                      value: 0,
                      groupValue: _estiloTreino,
                      onChanged:
                          _treinaTodosDias
                              ? null
                              : (value) {
                                setState(() {
                                  _estiloTreino = value!;
                                });
                              },
                    ),
                    RadioListTile<int>(
                      title: Text('Treino sequencial'),
                      value: 1,
                      groupValue: _estiloTreino,
                      onChanged: (value) {
                        setState(() {
                          _estiloTreino = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Seção de Dias de Treino
                    Text(
                      'Dias de Treino',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Lista de dias da semana
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: List.generate(_diasSemana.length, (index) {
                        return FilterChip(
                          label: Text(_diasSemanaCompleto[index]),
                          selected: _diasSelecionados[_diasSemana[index]]!,
                          onSelected: (bool selected) {
                            if (!_treinaTodosDias) {
                              setState(() {
                                _diasSelecionados[_diasSemana[index]] =
                                    selected;
                              });
                            }
                          },
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          checkmarkColor: Theme.of(context).colorScheme.primary,
                        );
                      }),
                    ),
                    SizedBox(height: 24),

                    // Botão de cadastro
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          onPressed: _cadastrarUsuario,
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
                            'CADASTRAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    SizedBox(height: 16),

                    // Link para login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Já tem uma conta?'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text('Faça login'),
                        ),
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
}

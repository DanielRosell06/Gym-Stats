import 'package:flutter/material.dart';
import 'package:gym_stats/auth_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart'; // Ajuste o caminho conforme necessário

class MinhaContaPage extends StatefulWidget {
  const MinhaContaPage({super.key});

  @override
  State<MinhaContaPage> createState() => _MinhaContaPageState();
}

class _MinhaContaPageState extends State<MinhaContaPage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final userData = await AuthService.getUserData();
    setState(() {
      _userData = userData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Minha Conta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await AuthService.logout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AuthChecker(),
                    ),
                  );
                },
                tooltip: 'Sair',
              ),
            ],
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações Pessoais',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Nome'),
                    subtitle: Text(_userData?['nome'] ?? 'Não informado'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('E-mail'),
                    subtitle: Text(_userData?['email'] ?? 'Não informado'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Você pode adicionar mais seções aqui
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configurações',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Notificações'),
                    value: true, // Você pode implementar essa preferência
                    onChanged: (value) {
                      // Implementar mudança de preferência
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

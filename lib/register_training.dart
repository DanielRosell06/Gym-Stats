import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gym_stats/auth_service.dart';

class SessionRegistrationPage extends StatefulWidget {
  const SessionRegistrationPage({super.key});

  @override
  State<SessionRegistrationPage> createState() => _SessionRegistrationPageState();
}

class _SessionRegistrationPageState extends State<SessionRegistrationPage> {
  // Lista de treinos do usuário
  final List<Map<String, dynamic>> _workouts = [];
  // Treino do dia (previsto)
  Map<String, dynamic>? _dailyWorkout;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTreinos();
  }

  Future<void> _carregarTreinos() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Obter o ID do usuário logado
      final userData = await AuthService.getUserData();
      final userId = userData['id'];

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.get(
        Uri.parse('http://192.168.0.137:3000/api/treino?idUsuario=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _workouts.clear();
          _workouts.addAll(List<Map<String, dynamic>>.from(responseData));
          
          // Verificar se existe um treino para o dia atual
          final weekdays = ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sab'];
          final today = weekdays[DateTime.now().weekday % 7]; // ajuste para iniciar em domingo
          
          _dailyWorkout = _workouts.firstWhere(
            (workout) => workout['day'] == today,
            orElse: () => {},
          );
        });
      } else {
        throw Exception(responseData['erro'] ?? 'Falha ao carregar treinos');
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _iniciarTreino(Map<String, dynamic> workout) async {
    try {
      // Obter o ID do usuário logado
      final userData = await AuthService.getUserData();
      final userId = userData['id'];

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Aqui você pode implementar a lógica para registrar o início do treino
      // Por exemplo, criar um novo registro em DiaTreino
      
      // Mostrar mensagem de sucesso
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Treino iniciado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Aqui você pode navegar para a página de registro dos exercícios
      // Navigator.push(...);
      
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao iniciar treino: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de treino previsto para hoje
                if (_dailyWorkout != null && _dailyWorkout!.isNotEmpty) ...[
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Treino previsto para hoje',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _dailyWorkout!['name'] ?? 'Sem nome',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Exercícios:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ...(_dailyWorkout!['exercises'] as List<dynamic>).map((exercise) => 
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.fitness_center, size: 16),
                                  const SizedBox(width: 8),
                                  Text(exercise),
                                ],
                              ),
                            ),
                          ).toList(),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _iniciarTreino(_dailyWorkout!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Iniciar treino previsto'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Título da seção de todos os treinos
                Text(
                  'Todos os treinos',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                // Lista de todos os treinos
                if (_workouts.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Nenhum treino cadastrado'),
                    ),
                  )
                else
                  ...List.generate(_workouts.length, (index) {
                    final workout = _workouts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        workout['name'] ?? 'Sem nome',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Dia: ${_getDiaSemanaCompleto(workout['day'])}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => _iniciarTreino(workout),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Iniciar treino'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Exercícios:',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...(workout['exercises'] as List<dynamic>).map((exercise) => 
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.fitness_center, size: 14, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(exercise),
                                  ],
                                ),
                              ),
                            ).toList(),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          );
  }

  // Função auxiliar para converter abreviações de dias para nomes completos
  String _getDiaSemanaCompleto(String? abreviacao) {
    if (abreviacao == null) return 'Não definido';
    
    switch (abreviacao.toLowerCase()) {
      case 'dom': return 'Domingo';
      case 'seg': return 'Segunda-feira';
      case 'ter': return 'Terça-feira';
      case 'qua': return 'Quarta-feira';
      case 'qui': return 'Quinta-feira';
      case 'sex': return 'Sexta-feira';
      case 'sab': return 'Sábado';
      default: return 'Não definido';
    }
  }
}
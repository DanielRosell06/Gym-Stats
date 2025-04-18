import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_stats/auth_service.dart';
import 'package:http/http.dart' as http;

class SessionRegistrationPage extends StatefulWidget {
  const SessionRegistrationPage({super.key});

  @override
  State<SessionRegistrationPage> createState() =>
      _SessionRegistrationPageState();
}

class _SessionRegistrationPageState extends State<SessionRegistrationPage> {
  final List<Map<String, dynamic>> _workouts = [];
  Map<String, dynamic>? _plannedWorkout;
  bool _isLoading = true;
  bool _errorLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorLoading = false;
      });
      
      await Future.wait([
        _carregarTreinos(),
        _carregarTreinoPrevisto(),
      ]);
    } catch (e) {
      setState(() {
        _errorLoading = true;
      });
      debugPrint('Erro ao carregar dados: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _carregarTreinoPrevisto() async {
    try {
      final userData = await AuthService.getUserData();
      final userId = userData?['id'];

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final now = DateTime.now();
      final weekdays = ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sab'];
      final today = weekdays[now.weekday % 7];

      final response = await http.get(
        Uri.parse('http://192.168.0.137:3000/api/treino?idUsuario=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> treinos = jsonDecode(response.body);
        
        final treinoPrevisto = treinos.cast<Map<String, dynamic>>().firstWhere(
          (treino) => treino['day'] == today,
          orElse: () => {},
        );

        if (treinoPrevisto.isNotEmpty) {
          setState(() {
            _plannedWorkout = treinoPrevisto;
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar treino previsto: $e');
    }
  }

  Future<void> _carregarTreinos() async {
    try {
      final userData = await AuthService.getUserData();
      final userId = userData?['id'];

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.get(
        Uri.parse('http://192.168.0.137:3000/api/treino?idUsuario=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        
        setState(() {
          _workouts
            ..clear()
            ..addAll(List<Map<String, dynamic>>.from(responseData));
        });
      } else {
        throw Exception('Falha ao carregar: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao carregar treinos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar treinos: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _iniciarTreino(Map<String, dynamic>? workout) async {
    if (workout == null || workout.isEmpty) return;

    try {
      final userData = await AuthService.getUserData();
      final userId = userData?['id'];

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Iniciando treino: ${workout['name'] ?? 'Sem nome'}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (e) {
      debugPrint('Erro ao iniciar treino: $e');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Treino'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_errorLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Erro ao carregar dados'),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlannedWorkoutSection(),
            const SizedBox(height: 32),
            _buildAllWorkoutsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlannedWorkoutSection() {
    final exercises = _plannedWorkout?['exercises'] as List<dynamic>?;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _plannedWorkout != null 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.today, size: 26),
              const SizedBox(width: 10),
              Text(
                _plannedWorkout != null
                    ? 'Treino Previsto para Hoje'
                    : 'Nenhum treino previsto',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          if (_plannedWorkout != null) ...[
            const SizedBox(height: 16),
            Text(
              _plannedWorkout!['name']?.toString() ?? 'Treino sem nome',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (exercises != null && exercises.isNotEmpty)
              _buildExerciseChips(exercises),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _iniciarTreino(_plannedWorkout),
              child: const Text('Iniciar Treino Previsto'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAllWorkoutsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.fitness_center),
            SizedBox(width: 8),
            Text('Todos os Treinos'),
          ],
        ),
        const SizedBox(height: 16),
        if (_workouts.isEmpty)
          _buildEmptyState()
        else
          _buildWorkoutsList(),
      ],
    );
  }

  Widget _buildExerciseChips(List<dynamic> exercises) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: exercises
          .take(3)
          .map((e) => ExerciseChip(name: e.toString()))
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.sports_gymnastics, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('Você ainda não tem treinos cadastrados'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Criar Treino'),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _workouts.length,
      itemBuilder: (context, index) {
        final workout = _workouts[index];
        final exercises = workout['exercises'] as List<dynamic>?;
        final day = workout['day']?.toString();

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        workout['name']?.toString() ?? 'Treino sem nome',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (day != null)
                      Chip(
                        label: Text(day),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                  ],
                ),
                if (exercises != null && exercises.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildExerciseChips(exercises),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _iniciarTreino(workout),
                  child: const Text('Iniciar Treino'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExerciseChip extends StatelessWidget {
  final String name;

  const ExerciseChip({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(name),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
}
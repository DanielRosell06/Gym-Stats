import 'package:flutter/material.dart';

class WorkoutRegistrationPage extends StatefulWidget {
  const WorkoutRegistrationPage({super.key});

  @override
  State<WorkoutRegistrationPage> createState() => _WorkoutRegistrationPageState();
}

class _WorkoutRegistrationPageState extends State<WorkoutRegistrationPage> {
  // Lista de treinos de exemplo
  final List<Map<String, dynamic>> _workouts = [
    {
      'name': 'Treino A - Peito, Ombro e Tríceps',
      'exercises': [
        'Supino Reto',
        'Desenvolvimento',
        'Tríceps Corda',
        'Crucifixo',
        'Elevação Lateral'
      ],
      'day': 'Segunda-feira'
    },
    {
      'name': 'Treino B - Costas e Bíceps',
      'exercises': [
        'Puxada Frontal',
        'Remada Curvada',
        'Rosca Direta',
        'Pulldown',
        'Rosca Martelo'
      ],
      'day': 'Quarta-feira'
    },
    {
      'name': 'Treino C - Pernas',
      'exercises': [
        'Agachamento',
        'Leg Press',
        'Cadeira Extensora',
        'Mesa Flexora',
        'Panturrilha'
      ],
      'day': 'Sexta-feira'
    },
  ];

  // Estado para os exercícios selecionados no popup
  List<String> _selectedExercises = [];
  
  // Controlador para o nome do treino
  final TextEditingController _workoutNameController = TextEditingController();
  
  // Dia da semana selecionado
  String _selectedDay = 'Segunda-feira';

  // Lista de exercícios disponíveis
  final List<String> _availableExercises = [
    'Supino Reto', 'Desenvolvimento', 'Tríceps Corda', 'Crucifixo', 'Elevação Lateral',
    'Puxada Frontal', 'Remada Curvada', 'Rosca Direta', 'Pulldown', 'Rosca Martelo',
    'Agachamento', 'Leg Press', 'Cadeira Extensora', 'Mesa Flexora', 'Panturrilha',
    'Supino Inclinado', 'Voador', 'Tríceps Francês', 'Barra Fixa', 'Remada Alta',
    'Leg Extension', 'Stiff', 'Levantamento Terra', 'Abdominais', 'Prancha'
  ];

  // Lista de dias da semana
  final List<String> _weekDays = [
    'Segunda-feira', 'Terça-feira', 'Quarta-feira', 
    'Quinta-feira', 'Sexta-feira', 'Sábado', 'Domingo'
  ];

  @override
  void dispose() {
    _workoutNameController.dispose();
    super.dispose();
  }

  void _showAddWorkoutDialog() {
    // Resetar dados do formulário
    _workoutNameController.clear();
    _selectedExercises = [];
    _selectedDay = 'Segunda-feira';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registrar Novo Treino',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Campo nome do treino
                    TextField(
                      controller: _workoutNameController,
                      decoration: InputDecoration(
                        labelText: 'Nome do Treino',
                        hintText: 'Ex: Treino A - Peito e Tríceps',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.fitness_center),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Seleção do dia da semana
                    Text(
                      'Dia do Treino',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedDay,
                          items: _weekDays.map((day) {
                            return DropdownMenuItem<String>(
                              value: day,
                              child: Text(day),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedDay = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Botão para buscar exercícios
                    ElevatedButton.icon(
                      onPressed: () {
                        _showExerciseSearchDialog(context);
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Pesquisar Exercícios'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Lista de exercícios selecionados
                    if (_selectedExercises.isNotEmpty) ...[
                      Text(
                        'Exercícios Selecionados',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: _selectedExercises.map((exercise) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    exercise,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _selectedExercises.remove(exercise);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    
                    // Botões de ação
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (_workoutNameController.text.isNotEmpty && 
                                _selectedExercises.isNotEmpty) {
                              // Adicionar novo treino
                              setState(() {
                                _addNewWorkout();
                              });
                              Navigator.pop(context);
                            } else {
                              // Mostrar erro
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Preencha o nome e selecione pelo menos um exercício'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showExerciseSearchDialog(BuildContext context) {
  TextEditingController searchController = TextEditingController();
  List<String> filteredExercises = List.from(_availableExercises);
  
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setStateDialog) {  // Renomeei para deixar claro que é o setState do diálogo
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Buscar Exercícios',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Digite para buscar',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setStateDialog(() {  // Usar o setState do diálogo
                      filteredExercises = _availableExercises
                          .where((exercise) => exercise.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];
                      final isSelected = _selectedExercises.contains(exercise);
                      
                      return ListTile(
                        title: Text(exercise),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.add_circle_outline),
                        onTap: () {
                          // Aqui precisamos usar o setState do widget pai
                          setState(() {  // Esse setState é do widget pai, não do diálogo
                            if (isSelected) {
                              _selectedExercises.remove(exercise);
                            } else {
                              _selectedExercises.add(exercise);
                            }
                          });
                          setStateDialog(() {});  // Atualizar o UI da lista no diálogo
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Concluir'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ).then((_) {
    searchController.dispose();
  });
}

  void _addNewWorkout() {
    // Adicionar à lista de estado
    setState(() {
      _workouts.add({
        'name': _workoutNameController.text,
        'exercises': List<String>.from(_selectedExercises),
        'day': _selectedDay,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botão para registrar novo treino
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showAddWorkoutDialog,
            icon: const Icon(Icons.add),
            label: const Text(
              'Registrar Novo Treino',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Título da seção
        Text(
          'Meus Treinos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Lista de treinos existentes
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _workouts.length,
          itemBuilder: (context, index) {
            final workout = _workouts[index];
            // Limitar a 4 exercícios para exibição
            final displayExercises = workout['exercises'].length > 4
                ? workout['exercises'].sublist(0, 4)
                : workout['exercises'];

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
                            workout['name'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            workout['day'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: displayExercises.map<Widget>((exercise) {
                        return ExerciseChip(name: exercise);
                      }).toList(),
                    ),
                    if (workout['exercises'].length > 4) ...[
                      const SizedBox(height: 8),
                      Text(
                        '+ ${workout['exercises'].length - 4} exercícios',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            // Implementar edição de treino
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Implementar iniciar treino
                          },
                          icon: const Icon(Icons.fitness_center),
                          label: const Text('Iniciar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 80), // Espaço para o bottom navigation bar
      ],
    );
  }
}

// Usando o componente ExerciseChip da home page
class ExerciseChip extends StatelessWidget {
  final String name;

  const ExerciseChip({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Chip(
        label: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
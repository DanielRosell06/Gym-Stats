import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_stats/auth_checker.dart';
import 'package:gym_stats/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NextWorkoutCard(),
        const SizedBox(height: 24),
        Text(
          'Estatísticas de Treino',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        WorkoutStatsCard(
          title: 'Progressão de Carga',
          chart: const WeightProgressionChart(),
        ),
        const SizedBox(height: 16),
        WorkoutStatsCard(
          title: 'Desempenho por Exercício',
          chart: const ExercisePerformanceChart(),
        ),
        const SizedBox(height: 16),
        const StreakCard(streakDays: 12),
        const SizedBox(height: 16),
        const ImprovementSuggestionsCard(),
        const SizedBox(height: 80),
      ],
    );
  }
}

// Mantenha todas as outras classes abaixo exatamente como estão...

class ImprovedBackgroundCurves extends StatelessWidget {
  const ImprovedBackgroundCurves({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return CustomPaint(
      size: Size(size.width, size.height * 0.5), // Aumentado a altura
      painter: ImprovedCurvesPainter(
        colors: [
          Theme.of(context).colorScheme.primary.withOpacity(0.8),
          Theme.of(context).colorScheme.secondary.withOpacity(0.7),
          Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
        ],
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class ImprovedCurvesPainter extends CustomPainter {
  final List<Color> colors;
  final bool isDarkMode;

  ImprovedCurvesPainter({required this.colors, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Primeira onda (mais externa) - mais suave e arredondada
    final path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(0, height * 0.4);
    path1.quadraticBezierTo(
      width * 0.25,
      height * 0.5,
      width * 0.5,
      height * 0.4,
    );
    path1.quadraticBezierTo(width * 0.75, height * 0.3, width, height * 0.45);
    path1.lineTo(width, 0);
    path1.close();

    // Segunda onda (meio) - mais curta e arredondada
    final path2 = Path();
    path2.moveTo(0, 0);
    path2.lineTo(0, height * 0.3);
    path2.quadraticBezierTo(
      width * 0.3,
      height * 0.4,
      width * 0.6,
      height * 0.3,
    );
    path2.quadraticBezierTo(width * 0.8, height * 0.2, width, height * 0.35);
    path2.lineTo(width, 0);
    path2.close();

    // Terceira onda (mais interna) - mais curta e arredondada
    final path3 = Path();
    path3.moveTo(0, 0);
    path3.lineTo(0, height * 0.2);
    path3.quadraticBezierTo(
      width * 0.35,
      height * 0.3,
      width * 0.7,
      height * 0.2,
    );
    path3.quadraticBezierTo(width * 0.85, height * 0.1, width, height * 0.25);
    path3.lineTo(width, 0);
    path3.close();

    // Desenhar as ondas em ordem reversa (de trás para frente)
    canvas.drawPath(path1, Paint()..color = colors[0]);
    canvas.drawPath(path2, Paint()..color = colors[1]);
    canvas.drawPath(path3, Paint()..color = colors[2]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NextWorkoutCard extends StatelessWidget {
  const NextWorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Próximo Treino',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Treino A - Peito, Ombro e Tríceps',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ExerciseChip(name: 'Supino Reto'),
                ExerciseChip(name: 'Desenvolvimento'),
                ExerciseChip(name: 'Tríceps Corda'),
                ExerciseChip(name: 'Crucifixo'),
                ExerciseChip(name: 'Elevação Lateral'),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.fitness_center),
                label: Text(
                  'Iniciar Treino',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withOpacity(0.15),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class WorkoutStatsCard extends StatelessWidget {
  final String title;
  final Widget chart;

  const WorkoutStatsCard({super.key, required this.title, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(height: 200, child: chart),
          ],
        ),
      ),
    );
  }
}

class WeightProgressionChart extends StatelessWidget {
  const WeightProgressionChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDarkMode ? Colors.white24 : Colors.black12;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: gridColor, strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: gridColor, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${value.toInt()} kg',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final labels = [
                  'Sem 1',
                  'Sem 2',
                  'Sem 3',
                  'Sem 4',
                  'Sem 5',
                  'Sem 6',
                  'Sem 7',
                ];
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      labels[value.toInt()],
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 65),
              FlSpot(1, 68),
              FlSpot(2, 70),
              FlSpot(3, 72),
              FlSpot(4, 75),
              FlSpot(5, 75),
              FlSpot(6, 78),
            ],
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  Theme.of(context).colorScheme.primary.withOpacity(0.0),
                ],
                stops: [0.2, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExercisePerformanceChart extends StatelessWidget {
  const ExercisePerformanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 15,
                color: Theme.of(context).colorScheme.primary,
                width: 20,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 12,
                color: Theme.of(context).colorScheme.secondary,
                width: 20,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: 8,
                color: Theme.of(context).colorScheme.tertiary,
                width: 20,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: 17,
                color: Theme.of(context).colorScheme.primary,
                width: 20,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = 'Supino';
                    break;
                  case 1:
                    text = 'Desenv.';
                    break;
                  case 2:
                    text = 'Tríceps';
                    break;
                  case 3:
                    text = 'Crucifixo';
                    break;
                  default:
                    text = '';
                    break;
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 10,
                  child: Text(
                    text,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${value.toInt()} kg',
                    style: TextStyle(color: labelColor, fontSize: 12),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }
}

class StreakCard extends StatelessWidget {
  final int streakDays;

  const StreakCard({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sequência atual',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                ),
                SizedBox(height: 6),
                Text(
                  '$streakDays dias seguidos',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImprovementSuggestionsCard extends StatelessWidget {
  const ImprovementSuggestionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sugestões de melhora',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ExerciseImproveItem(
              name: 'Tríceps Corda',
              progress: 0.3,
              suggestion: 'Aumente o peso em 2kg',
            ),
            SizedBox(height: 12),
            ExerciseImproveItem(
              name: 'Elevação Lateral',
              progress: 0.5,
              suggestion: 'Aumente 1 repetição',
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseImproveItem extends StatelessWidget {
  final String name;
  final double progress;
  final String suggestion;

  const ExerciseImproveItem({
    super.key,
    required this.name,
    required this.progress,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  suggestion,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
              minHeight: 8,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthChecker()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          elevation: 8,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Treinos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: 'Registrar',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Conta'),
          ],
        ),
      ),
    );
  }
}

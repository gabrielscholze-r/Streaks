import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaks/presentation/viewmodels/home_page_viewmodel.dart';
import 'package:streaks/presentation/pages/add_edit_habit_page.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final Color onSurfaceVariantColor =
        Theme.of(context).colorScheme.onSurfaceVariant;

    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (viewModel.errorMessage != null) {
          return Center(
            child: Text(
              'Error loading score: ${viewModel.errorMessage}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        final totalScore = viewModel.habits.fold<int>(
          0,
          (sum, habit) => sum + habit.streakCount,
        );

        final habitsWithStreaks =
            viewModel.habits.where((habit) => habit.streakCount > 0).toList();
        final sortedHabits = habitsWithStreaks.toList()
          ..sort((a, b) => b.streakCount.compareTo(a.streakCount));

        if (totalScore == 0 && viewModel.habits.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied,
                      size: 80, color: onSurfaceVariantColor),
                  const SizedBox(height: 24),
                  Text(
                    'Você não possui nenhum hábito ativo no momento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Comece a registrar suas streaks para ver seu progresso aqui!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: onSurfaceVariantColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddEditHabitPage(),
                        ),
                      );
                      if (result == true) {
                        viewModel.fetchHabits();
                      }
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Adicionar Novo Hábito'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (viewModel.habits.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_task, size: 80, color: onSurfaceVariantColor),
                  const SizedBox(height: 24),
                  Text(
                    'Nenhum hábito cadastrado ainda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Comece adicionando seu primeiro hábito para iniciar suas streaks!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: onSurfaceVariantColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddEditHabitPage(),
                        ),
                      );
                      if (result == true) {
                        viewModel.fetchHabits();
                      }
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Adicionar Primeiro Hábito'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.star,
                  size: 100,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Sua Pontuação Total de Streaks:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: onSurfaceColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '$totalScore dias',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                  shadows: [
                    Shadow(
                      offset: const Offset(2, 2),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Continue o ótimo trabalho! A consistência é fundamental.',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: onSurfaceVariantColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (sortedHabits.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Hábitos com Maiores Streaks:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: onSurfaceColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ...sortedHabits
                                .take(3)
                                .map((habit) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            habit.name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: onSurfaceColor),
                                          ),
                                          Text(
                                            '${habit.streakCount} dias',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: accentColor),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            if (sortedHabits.length > 3)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'e ${sortedHabits.length - 3} mais...',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: onSurfaceVariantColor),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

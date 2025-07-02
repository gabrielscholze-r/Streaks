import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaks/presentation/viewmodels/home_page_viewmodel.dart';

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
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color accentColor =
        Theme.of(context).colorScheme.secondary; 

    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (viewModel.errorMessage != null) {
          return Center(
            child: Text(
              'Error loading score: ${viewModel.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final totalScore = viewModel.habits.fold<int>(
          0,
          (sum, habit) => sum + habit.streakCount,
        );

        final sortedHabits = viewModel.habits.toList()
          ..sort((a, b) => b.streakCount.compareTo(a.streakCount));

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
                CrossAxisAlignment.center, 
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
                  color: Colors.amber[700],
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Sua Pontuação Total de Streaks:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600, 
                  color: Colors.grey[700], 
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
                  color: Colors.grey[600], 
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                  height: 48), 

              if (viewModel.habits.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Hábitos com Maiores Streaks:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Card(
                      elevation: 4, 
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), 
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0), 
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ...sortedHabits
                                .take(3) 
                                .map((habit) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              8.0), 
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween, 
                                        children: [
                                          Text(
                                            habit.name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[850]),
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
                            if (sortedHabits.length >
                                3) 
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'e ${sortedHabits.length - 3} mais...',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[500]),
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
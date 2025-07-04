import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaks/presentation/viewmodels/home_page_viewmodel.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/presentation/pages/add_edit_habit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Consumer<HomePageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            );
          }
          if (viewModel.errorMessage != null) {
            return Center(
              child: Text(
                'Erro: ${viewModel.errorMessage}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }
          if (viewModel.habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nenhum hábito adicionado.',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Use o botão "+" para adicionar um hábito!',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: viewModel.habits.length,
            itemBuilder: (context, index) {
              final habit = viewModel.habits[index];
              final now = DateTime.now();
              final isCompletedToday = habit.lastCompleted != null &&
                  habit.lastCompleted!.year == now.year &&
                  habit.lastCompleted!.month == now.month &&
                  habit.lastCompleted!.day == now.day;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.directions_run,
                          color: colorScheme.primary,
                          size: 36,
                        ),
                        title: Text(
                          habit.name,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (habit.description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  habit.description,
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Notificação: ${habit.notificationTime.hour.toString().padLeft(2, '0')}:${habit.notificationTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant
                                      .withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Streak: ${habit.streakCount} dias',
                                style: TextStyle(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          isCompletedToday
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: colorScheme.secondary, size: 36),
                                    Text(
                                      'Volte amanhã',
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant
                                            .withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                )
                              : ElevatedButton.icon(
                                  onPressed: () {
                                    viewModel.markHabitComplete(habit);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${habit.name} marcado como completo!'),
                                        backgroundColor: colorScheme.secondary,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        margin: const EdgeInsets.all(16),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text('Concluir'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            icon: Icon(Icons.edit, color: colorScheme.primary),
                            label: const Text('Editar Hábito'),
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddEditHabitPage(habit: habit),
                                ),
                              );
                              if (result == true) {
                                Provider.of<HomePageViewModel>(context,
                                        listen: false)
                                    .fetchHabits();
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              side: BorderSide(color: colorScheme.primary),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            icon: Icon(Icons.delete, color: colorScheme.error),
                            label: const Text('Excluir Hábito'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Excluir Hábito',
                                      style: TextStyle(
                                          color: colorScheme.onSurface),
                                    ),
                                    content: Text(
                                      'Tem certeza que deseja excluir "${habit.name}"?',
                                      style: TextStyle(
                                          color: colorScheme.onSurfaceVariant),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: colorScheme.primary,
                                        ),
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: colorScheme.error,
                                        ),
                                        child: const Text('Excluir'),
                                        onPressed: () {
                                          viewModel.deleteHabit(habit.id);
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${habit.name} excluído.'),
                                              backgroundColor:
                                                  colorScheme.error,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              margin: const EdgeInsets.all(16),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(color: colorScheme.error),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddEditHabitPage(),
            ),
          );
          if (result == true) {
            Provider.of<HomePageViewModel>(context, listen: false)
                .fetchHabits();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

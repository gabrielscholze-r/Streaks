import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/habit_viewmodel.dart';
import '../models/habit.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitVM = Provider.of<HabitViewModel>(context);
    final habits = habitVM.habits;

    return Scaffold(
      appBar: AppBar(title: Text('My Habits')),
      body: habits.isEmpty
          ? Center(child: Text('No habits yet'))
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                Habit habit = habits[index];
                return ListTile(
                  title: Text(habit.title),
                  subtitle: Text(habit.description),
                  trailing: Icon(
                    habit.completed ? Icons.check_circle : Icons.circle_outlined,
                    color: habit.completed ? Colors.green : null,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: habit);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
      ),
    );
  }
}

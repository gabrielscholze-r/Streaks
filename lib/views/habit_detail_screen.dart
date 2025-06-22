import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../viewmodels/habit_viewmodel.dart';

class HabitDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habit = ModalRoute.of(context)!.settings.arguments as Habit;
    final habitVM = Provider.of<HabitViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Habit Details')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(habit.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(habit.description),
            SizedBox(height: 24),
            Row(
              children: [
                Text('Completed: ', style: TextStyle(fontSize: 18)),
                Checkbox(
                  value: habit.completed,
                  onChanged: (val) {
                    habitVM.toggleCompleted(habit.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

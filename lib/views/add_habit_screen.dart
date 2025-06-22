import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../viewmodels/habit_viewmodel.dart';
import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);
  List<bool> _selectedDays = List.generate(7, (_) => false);

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final selectedWeekdays = <int>[];
      for (int i = 0; i < 7; i++) {
        if (_selectedDays[i]) {
          selectedWeekdays.add(i + 1); // 1 = Monday, 7 = Sunday
        }
      }

      if (selectedWeekdays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selecione pelo menos um dia da semana')),
        );
        return;
      }

      final newHabit = Habit(
        id: Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        reminderTime: _selectedTime,
        reminderDays: selectedWeekdays,
      );

      Provider.of<HabitViewModel>(context, listen: false).addHabit(newHabit);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> weekLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Hábito')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título do Hábito'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite um título' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              Text('Horário do lembrete', style: TextStyle(fontWeight: FontWeight.bold)),
              ListTile(
                title: Text('Selecionado: ${_selectedTime.format(context)}'),
                trailing: Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              SizedBox(height: 24),
              Text('Dias da semana', style: TextStyle(fontWeight: FontWeight.bold)),
              ToggleButtons(
                children: weekLabels.map((d) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(d),
                )).toList(),
                isSelected: _selectedDays,
                onPressed: (index) {
                  setState(() {
                    _selectedDays[index] = !_selectedDays[index];
                  });
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveHabit,
                child: Text('Salvar Hábito'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

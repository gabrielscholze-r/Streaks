import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/presentation/viewmodels/add_edit_habit_viewmodel.dart';

final sl = GetIt.instance;

class AddEditHabitPage extends StatefulWidget {
  final Habit? habit;

  const AddEditHabitPage({super.key, this.habit});

  @override
  State<AddEditHabitPage> createState() => _AddEditHabitPageState();
}

class _AddEditHabitPageState extends State<AddEditHabitPage> {
  late AddEditHabitViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = sl<AddEditHabitViewModel>();
    _viewModel.initialize(widget.habit);

    _nameController.text = _viewModel.name;
    _descriptionController.text = _viewModel.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddEditHabitViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.habit == null ? 'Add New Habit' : 'Edit Habit'),
          centerTitle: true,
        ),
        body: Consumer<AddEditHabitViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Habit Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a habit name.';
                        }
                        return null;
                      },
                      onChanged: (value) => viewModel.name = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => viewModel.description = value,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Remind Me On:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: List.generate(7, (index) {
                        return FilterChip(
                          label: Text(_weekDays[index]),
                          selected: viewModel.selectedDays.contains(index),
                          onSelected: (selected) {
                            viewModel.toggleDay(index);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Notification Time:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: Text(
                        '${viewModel.selectedTime.hour.toString().padLeft(2, '0')}:${viewModel.selectedTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: viewModel.selectedTime,
                        );
                        if (pickedTime != null) {
                          viewModel.selectedTime = pickedTime;
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: viewModel.isSaving
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await viewModel.saveHabit();
                                  if (success) {
                                    if (!mounted) return;
                                    Navigator.of(context).pop(true);
                                  } else {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(viewModel.errorMessage ?? 'An error occurred.')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                              child: Text(widget.habit == null ? 'Add Habit' : 'Save Changes'),
                            ),
                    ),
                    if (viewModel.errorMessage != null && !viewModel.isSaving)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: Text(
                            viewModel.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
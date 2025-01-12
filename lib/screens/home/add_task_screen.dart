import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../services/task.dart';
import '../../services/task/task_notifier.dart';
import '../common_widgets.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final Function(Task) onAddTask; //

  const AddTaskScreen({Key? key, required this.onAddTask}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  String priority = "Low";

  Future<void> _selectDueDate(BuildContext context) async {
    // Get current date
    DateTime currentDate = DateTime.now();

    // Show date picker
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // If a date was selected, format it and update the text field
    if (selectedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
      setState(() {
        dueDateController.text = formattedDate;
      });
    }
  }

  void submitTask() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        dueDateController.text.isNotEmpty) {
      final newTask = Task(
        id: "",
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        dueDate: dueDateController.text.trim(),
        priority: priority,
      );

      await ref.read(taskNotifierProvider.notifier).addTask(newTask);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500, color: primDB),
              ),
              TextfieldHelper(
                controller: titleController,
                hintText: 'Enter title here',
              ),
              SizedBox(height: 16),
              Text(
                "Description",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500, color: primDB),
              ),
              TextfieldHelper(
                controller: descriptionController,
                hintText: "Enter description here",
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Text(
                "Due Date",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500, color: primDB),
              ),
              TextfieldHelper(
                readOnly: true,
                controller: dueDateController,
                hintText: 'Select Date',
                onTap: () {
                  _selectDueDate(context);
                },
              ),
              SizedBox(height: 16),
              Text(
                "Priority",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500, color: primDB),
              ),
              SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: priority,
                items: ["Low", "Medium", "High"]
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      priority = value;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "Priority",
                  labelStyle: TextStyle(color: primDB),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.5, horizontal: 12.0),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff004c6d), width: 1.5),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF1bc1c4), width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: submitTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff004c6d), //
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    "Add Task",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

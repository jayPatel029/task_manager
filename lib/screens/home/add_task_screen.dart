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
  bool isLoading = false;

  Future<void> _selectDueDate(BuildContext context) async {
     DateTime currentDate = DateTime.now();

     DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

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
      //todo add loding UI

      setState(() => isLoading = true);

      final newTask = Task(
        id: "",
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        dueDate: dueDateController.text.trim(),
        priority: priority,
      );

      await ref.read(taskNotifierProvider.notifier).addTask(newTask);
      setState(() => isLoading = false);

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: const Text("Add Task"),
        elevation: 2,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field
                  _tfLable("Title"),
                  TextfieldHelper(
                    controller: titleController,
                    hintText: 'Enter task title',
                  ),
                  const SizedBox(height: 16),

                  // Description field
                  _tfLable("Description"),
                  TextfieldHelper(
                    controller: descriptionController,
                    hintText: "Enter task description",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Due Date field
                  _tfLable("Due Date"),
                  TextfieldHelper(
                    readOnly: true,
                    controller: dueDateController,
                    hintText: 'Select date',
                    onTap: () => _selectDueDate(context),
                  ),
                  const SizedBox(height: 16),

                  // Priority Dropdown
                  _tfLable("Priority"),
                  const SizedBox(height: 8),
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
                    decoration: _inputDecoDD("Priority"),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submitTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        "Add Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );



  }


  Widget _tfLable(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.blue[600],
      ),
    );
  }


  InputDecoration _inputDecoDD(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.blue[600]),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      fillColor: Colors.white,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue[700]!, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue[400]!, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

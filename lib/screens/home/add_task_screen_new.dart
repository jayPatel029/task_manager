/*
* add / edit from here
*
* **/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_bloc/screens/home/home_screen.dart';

import '../../services/task.dart';
import '../../services/task/task_notifier.dart';
import '../common_widgets.dart';

class AddTaskNew extends ConsumerStatefulWidget {
  final bool isEdit;
  final Task? task;

  const AddTaskNew({
    Key? key,
    required this.isEdit,
    this.task,
  }) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<AddTaskNew> {
  late TextEditingController titleCont;
  late TextEditingController descCont;
  late TextEditingController dueDateCont;
  String priority = "Low";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleCont = TextEditingController(
        text: widget.isEdit ? widget.task?.title ?? "" : "");
    descCont = TextEditingController(
        text: widget.isEdit ? widget.task?.description ?? "" : "");
    dueDateCont = TextEditingController(
        text: widget.isEdit ? widget.task?.dueDate ?? "" : "");
    priority = widget.isEdit ? widget.task?.priority ?? "Low" : "Low";
  }

  Future<void> _dateSelector(BuildContext context) async {
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
        dueDateCont.text = formattedDate;
      });
    }
  }

  Future<void> saveTask() async {
    if (titleCont.text.isEmpty ||
        descCont.text.isEmpty ||
        dueDateCont.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill in all fields"),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    setState(() => isLoading = true);
// to update
    if (widget.isEdit) {
       final updatedTask = Task(
        id: widget.task!.id,
        title: titleCont.text.trim(),
        description: descCont.text.trim(),
        dueDate: dueDateCont.text.trim(),
        priority: priority,
        isComplete: widget.task!.isComplete,
      );

      await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
    } else {
// to add
       final newTask = Task(
        id: "",
        title: titleCont.text.trim(),
        description: descCont.text.trim(),
        dueDate: dueDateCont.text.trim(),
        priority: priority,
      );

      await ref.read(taskNotifierProvider.notifier).addTask(newTask);
    }

    setState(() => isLoading = false);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (v) => false);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text(
          widget.isEdit ? "Edit Task" : "Add Task",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
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
                   tfLable("Title"),
                  buildTf(
                    controller: titleCont,
                    hintText: "Enter task title",
                  ),
                  const SizedBox(height: 16),

                   tfLable("Description"),
                  buildTf(
                    controller: descCont,
                    hintText: "Enter task description",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                   tfLable("Due Date"),
                  buildTf(
                    controller: dueDateCont,
                    hintText: "Select date",
                    readOnly: true,
                    onTap: () => _dateSelector(context),
                  ),
                  const SizedBox(height: 16),

                   tfLable("Priority"),
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
                    decoration: inputDecoDD("Priority"),
                  ),
                  const SizedBox(height: 32),

                   Center(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                          : Text(
                              widget.isEdit ? "Update Task" : "Add Task",
                              style: const TextStyle(color: Colors.white),
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

  Widget tfLable(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.blue[600],
      ),
    );
  }

  Widget buildTf({
    required TextEditingController controller,
    String hintText = "",
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextfieldHelper(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      hintText: hintText,
    );
  }

  InputDecoration inputDecoDD(String label) {
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

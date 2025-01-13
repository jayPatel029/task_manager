import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_bloc/screens/home/home_screen.dart';

import '../../services/task.dart';
import '../../services/task/task_notifier.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final Task task;

  const EditTaskScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dueDateController;
  String priority = "Low";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    dueDateController = TextEditingController(text: widget.task.dueDate);
    priority = widget.task.priority;
  }

  Future<void> saveTask() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        dueDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill in all fields"),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final updatedTask = Task(
      id: widget.task.id,
      title: titleController.text,
      description: descriptionController.text,
      dueDate: dueDateController.text,
      priority: priority,
      isComplete: widget.task.isComplete,
    );

    await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);

    setState(() => isLoading = false);

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => const HomeScreen()), (val) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
        backgroundColor: Colors.blue[600],
        elevation: 1,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Field
                  _buildLabel("Title"),
                  _buildTextField(
                    controller: titleController,
                    hintText: "Enter task title",
                  ),
                  const SizedBox(height: 16),

                  // Description Field
                  _buildLabel("Description"),
                  _buildTextField(
                    controller: descriptionController,
                    hintText: "Enter task description",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Due Date Field
                  _buildLabel("Due Date"),
                  _buildTextField(
                    controller: dueDateController,
                    hintText: "Enter due date",
                  ),
                  const SizedBox(height: 16),

                  // Priority Dropdown
                  _buildLabel("Priority"),
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
                    decoration: _buildInputDecoration("Priority"),
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 32),
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
                              "Save Task",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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

    //   Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Edit Task"),
    //     backgroundColor: Colors.blue[600], //
    //     elevation: 0,
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         TextField(
    //           controller: titleController,
    //           decoration: InputDecoration(
    //             labelText: "Title",
    //             labelStyle:
    //                 TextStyle(color: Colors.blue[600]), //
    //             focusedBorder: OutlineInputBorder(
    //               borderSide: BorderSide(
    //                   color: Colors.blue[600]!),
    //             ),
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(12),
    //               borderSide:
    //                   BorderSide(color: Colors.blue[200]!),
    //             ),
    //           ),
    //         ),
    //         SizedBox(height: 16),
    //         TextField(
    //           controller: descriptionController,
    //           decoration: InputDecoration(
    //             labelText: "Description",
    //             labelStyle: TextStyle(color: Colors.blue[600]),
    //             focusedBorder: OutlineInputBorder(
    //               borderSide: BorderSide(color: Colors.blue[600]!),
    //             ),
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(12),
    //               borderSide: BorderSide(color: Colors.blue[200]!),
    //             ),
    //           ),
    //         ),
    //         SizedBox(height: 16),
    //         TextField(
    //           controller: dueDateController,
    //           decoration: InputDecoration(
    //             labelText: "Due Date",
    //             labelStyle: TextStyle(color: Colors.blue[600]),
    //             focusedBorder: OutlineInputBorder(
    //               borderSide: BorderSide(color: Colors.blue[600]!),
    //             ),
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(12),
    //               borderSide: BorderSide(color: Colors.blue[200]!),
    //             ),
    //           ),
    //         ),
    //         SizedBox(height: 16),
    //         DropdownButtonFormField<String>(
    //           value: priority,
    //           items: ["Low", "Medium", "High"]
    //               .map((p) => DropdownMenuItem(value: p, child: Text(p)))
    //               .toList(),
    //           onChanged: (value) {
    //             if (value != null) {
    //               setState(() {
    //                 priority = value;
    //               });
    //             }
    //           },
    //           decoration: InputDecoration(
    //             labelText: "Priority",
    //             labelStyle: TextStyle(color: Colors.blue[600]),
    //             focusedBorder: OutlineInputBorder(
    //               borderSide: BorderSide(color: Colors.blue[600]!),
    //             ),
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(12),
    //               borderSide: BorderSide(color: Colors.blue[200]!),
    //             ),
    //           ),
    //         ),
    //         SizedBox(height: 32),
    //         Center(
    //           child: ElevatedButton(
    //             onPressed: () {
    //               saveTask();
    //             },
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor:
    //                   Colors.blue[700], //
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(12),
    //               ),
    //               padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
    //             ),
    //             child: const Text(
    //               "Save Task",
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    //
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.blue[600],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String hintText = "",
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: _buildInputDecoration(hintText),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
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

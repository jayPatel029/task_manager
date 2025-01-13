import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/task.dart';

class TextfieldHelper extends StatefulWidget {
  final String hintText;
  final Function? validator;
  final Widget? prefix;
  final Widget? suffix;
  final Function(String?)? onSaved;
  final TextInputType? textInputType;
  final bool? obscureText;
  final Function(String?)? onChanged;
  final Function()? onTap;
  final bool? enabled;
  final TextEditingController controller;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool? autoFocus;
  final bool readOnly;
  final int? maxLength;
  final String? llabel;

  const TextfieldHelper(
      {Key? key,
      required this.hintText,
      this.validator,
      this.prefix,
      this.textInputType,
      this.obscureText,
      this.onChanged,
      this.onTap,
      this.onSaved,
      required this.controller,
      this.suffix,
      this.enabled,
      this.maxLines,
      this.focusNode,
      this.autoFocus,
      this.readOnly = false,
      this.maxLength,
      this.llabel})
      : super(key: key);

  @override
  State<TextfieldHelper> createState() => _TextfieldHelperState();
}

class _TextfieldHelperState extends State<TextfieldHelper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        cursorColor: Colors.black,
        keyboardType: widget.textInputType ?? TextInputType.text,
        autofocus: widget.autoFocus ?? false,
        focusNode: widget.focusNode,
        enabled: widget.enabled ?? true,
        maxLines: widget.maxLines ?? 1,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText ?? false,
        controller: widget.controller,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 17.sp,
        ),
        onFieldSubmitted: widget.onSaved,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        decoration: inpurdecorationTwo.copyWith(
          prefixIcon: widget.prefix,
          suffixIcon: widget.suffix,
          prefixIconConstraints: BoxConstraints(maxHeight: 0.045.sh),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            color: const Color(0xfffa1a1a1),
          ),
        ),
      ),
    );
  }
}

Color primDB = Color(0xff004c6d);
Color lightB = Color(0xFF1bc1c4);

InputDecoration inpurdecorationTwo = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 12.0),
  fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primDB, width: 1.5),
    borderRadius: BorderRadius.circular(5.0),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: lightB, width: 1.0),
    borderRadius: BorderRadius.circular(5.0),
  ),
);


class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    switch (task.priority.toLowerCase()) {
      case 'high':
        priorityColor = Colors.redAccent;
        break;
      case 'medium':
        priorityColor = Colors.orangeAccent;
        break;
      case 'low':
      default:
        priorityColor = Colors.greenAccent;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blue[50],
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        onTap: onTap,
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue[800],
          ),
        ),
        subtitle: Text(
          task.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.blueGrey[700]),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          children: [
            // Priority Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.priority.toUpperCase(),
                style: TextStyle(
                  color: priorityColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Completion Icon
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                key: ValueKey(task.isComplete),
                icon: Icon(
                  task.isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: task.isComplete ? Colors.green[600] : Colors.grey[600],
                  size: 28,
                ),
                onPressed: onToggleComplete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

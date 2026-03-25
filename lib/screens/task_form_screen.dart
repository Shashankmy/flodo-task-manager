import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  DateTime? date;
  TaskStatus status = TaskStatus.todo;
  String? blockedBy;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      // EDIT MODE → load existing task
      titleCtrl.text = widget.task!.title;
      descCtrl.text = widget.task!.description;
      date = widget.task!.dueDate;
      status = widget.task!.status;
      blockedBy = widget.task!.blockedBy;
    } else {
      // NEW TASK → load draft (if exists)
      loadDraft();
    }
  }

  Future<void> saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('title', titleCtrl.text);
    prefs.setString('desc', descCtrl.text);
  }

  Future<void> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    titleCtrl.text = prefs.getString('title') ?? '';
    descCtrl.text = prefs.getString('desc') ?? '';
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('title');
    prefs.remove('desc');
  }

  Future<void> saveTask() async {
    setState(() => loading = true);

    final provider = Provider.of<TaskProvider>(context, listen: false);

    final task = Task(
      title: titleCtrl.text,
      description: descCtrl.text,
      dueDate: date ?? DateTime.now(),
      status: status,
      blockedBy: blockedBy,
    );

    if (widget.task == null) {
      await provider.addTask(task);
    } else {
      task.id = widget.task!.id;
      await provider.updateTask(task);
    }

    // ✅ Clear draft after saving
    await clearDraft();

    setState(() => loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (_) => saveDraft(),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (_) => saveDraft(),
            ),
            ElevatedButton(
              onPressed: () async {
                date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                setState(() {});
              },
              child: Text(date == null ? 'Pick Date' : date.toString()),
            ),
            DropdownButton<TaskStatus>(
              value: status,
              items: TaskStatus.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => status = val!),
            ),
            DropdownButton<String?>(
              hint: const Text('Blocked By'),
              value: blockedBy,
              items: provider.tasks
                  .map((t) => DropdownMenuItem(
                        value: t.id,
                        child: Text(t.title),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => blockedBy = val),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: saveTask,
                    child: const Text('Save'),
                  )
          ],
        ),
      ),
    );
  }
}
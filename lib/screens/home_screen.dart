import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _debounce;

  void _onSearchChanged(String query, TaskProvider provider) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      provider.setSearch(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TaskFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search tasks...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => _onSearchChanged(value, provider),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<TaskStatus?>(
                  value: provider.filterStatus,
                  decoration: InputDecoration(
                    labelText: "Filter by status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text("All")),
                    ...TaskStatus.values.map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ),
                    ),
                  ],
                  onChanged: provider.setFilter,
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.filteredTasks.isEmpty
                ? const Center(child: Text("No tasks yet. Tap + to create one"))
                : ListView.builder(
                    itemCount: provider.filteredTasks.length,
                    itemBuilder: (_, i) {
                      final task = provider.filteredTasks[i];
                      final blocked = provider.isBlocked(task);

                      return TaskCard(
                        task: task,
                        isBlocked: blocked,
                        searchQuery: provider.searchQuery,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskFormScreen(task: task),
                          ),
                        ),
                        onDelete: () => provider.deleteTask(task.id),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
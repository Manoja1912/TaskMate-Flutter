
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

const Color midnight = Color(0xFF171B2E);
const Color lime = Color(0xFFD7F75B);
const Color ivory = Color(0xFFF7F6F1);
const Color muted = Color(0xFF77798A);
const Color lavender = Color(0xFFE8E1FF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  String selectedFilter = 'All';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final data = await DatabaseHelper.instance.getTasks();
      if (!mounted) return;

      setState(() {
        tasks = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load tasks: $e')),
      );
    }
  }

  List<Task> get filteredTasks {
    if (selectedFilter == 'All') return tasks;
    return tasks.where((task) => task.status == selectedFilter).toList();
  }

  Color priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFC64B43);
      case 'Medium':
        return const Color(0xFFB07820);
      default:
        return const Color(0xFF477B63);
    }
  }

  Future<void> openAddTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    await loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((t) => t.status == 'Completed').length;
    final pending = tasks.where((t) => t.status == 'Pending').length;

    return Scaffold(
      backgroundColor: ivory,
      appBar: AppBar(
        backgroundColor: midnight,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: lime,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: midnight,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'TaskMate',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh tasks',
            onPressed: loadTasks,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadTasks,
        color: midnight,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: midnight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUR PERSONAL WORKSPACE',
                    style: TextStyle(
                      color: Color(0xFFB8BBD0),
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 17),
                  const Text(
                    'Make room for',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'what matters.',
                    style: TextStyle(
                      color: lime,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Small steps. Real progress.',
                    style: TextStyle(
                      color: Color(0xFFB8BBD0),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          'TOTAL TASKS',
                          tasks.length,
                          Icons.layers_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          'COMPLETED',
                          completed,
                          Icons.check_circle_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.pending_outlined,
                        size: 17,
                        color: lime,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '$pending tasks still in progress',
                        style: const TextStyle(
                          color: Color(0xFFD7D9E4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your priorities',
                        style: TextStyle(
                          color: midnight,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Keep your next steps in sight.',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: lime,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: openAddTask,
                    tooltip: 'Add a task',
                    icon: const Icon(
                      Icons.add_rounded,
                      color: midnight,
                      size: 27,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: openAddTask,
                icon: const Icon(Icons.add_task_rounded),
                label: const Text('Create a new task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: midnight,
                  foregroundColor: lime,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Task list',
                  style: TextStyle(
                    color: midnight,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${filteredTasks.length} items',
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedFilter,
              decoration: InputDecoration(
                labelText: 'Filter tasks',
                prefixIcon: const Icon(
                  Icons.tune_rounded,
                  color: midnight,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E3DA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E3DA)),
                ),
              ),
              items: ['All', 'Pending', 'Completed']
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedFilter = value);
                }
              },
            ),

            const SizedBox(height: 14),

            if (loading)
              const Padding(
                padding: EdgeInsets.all(35),
                child: Center(
                  child: CircularProgressIndicator(color: midnight),
                ),
              )
            else if (filteredTasks.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 35,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8E6DF)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5B6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.inbox_outlined,
                        size: 34,
                        color: midnight,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'A fresh start!',
                      style: TextStyle(
                        color: midnight,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your task list is empty. Add a task to get moving.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              ...filteredTasks.map(
                (task) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE8E6DF)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(task: task),
                          ),
                        );
                        await loadTasks();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Container(
                              width: 45,
                              height: 48,
                              decoration: BoxDecoration(
                                color: task.status == 'Completed'
                                    ? const Color(0xFFE8F5B6)
                                    : lavender,
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Icon(
                                task.status == 'Completed'
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.edit_note_rounded,
                                color: midnight,
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: midnight,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    task.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 7,
                                    runSpacing: 6,
                                    children: [
                                      _tag(
                                        task.priority.toUpperCase(),
                                        priorityColor(task.priority),
                                      ),
                                      _tag(
                                        task.status,
                                        task.status == 'Completed'
                                            ? const Color(0xFF477B63)
                                            : const Color(0xFF77798A),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF9B9DAB),
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, int count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF282D43),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF393E53)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: lime, size: 20),
          const SizedBox(height: 13),
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB8BBD0),
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

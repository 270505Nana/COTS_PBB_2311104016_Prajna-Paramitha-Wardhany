import 'package:flutter/material.dart';
import 'package:cots/design_system/styles.dart';
import 'package:cots/models/task.dart';
import 'package:cots/services/task_service.dart';
import 'detail_task_page.dart';
import 'add_task_page.dart';
import 'package:intl/intl.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  final TaskService _service = TaskService();
  List<Task> _tasks = [];
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'BERJALAN', 'SELESAI', 'TERLAMBAT'];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _service.getTasks(status: _selectedFilter == 'Semua' ? null : _selectedFilter);
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Daftar Tugas", style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.text),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
              _loadTasks();
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar Placeholder (Visual only as per design)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari tugas atau mata kuliah...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.text),
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      _loadTasks();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.circle, size: 12, color: AppColors.primary),
                    title: Text(task.title, style: AppTextStyles.section),
                    subtitle: Text(task.course, style: AppTextStyles.caption),
                    trailing: Text(DateFormat('d MMM').format(task.deadline), style: AppTextStyles.body),
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailTaskPage(task: task)));
                      _loadTasks();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
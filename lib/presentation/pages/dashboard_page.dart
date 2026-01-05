import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cots/design_system/styles.dart';
import 'package:cots/models/task.dart';
import 'package:cots/services/task_service.dart';
import 'all_tasks_page.dart';
import 'add_task_page.dart';
import 'detail_task_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TaskService _service = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final tasks = await _service.getTasks(); // Fetch all for counts
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int total = _tasks.length;
    final int selesai = _tasks.where((t) => t.isDone).length;
    // Tugas terdekat (sort by deadline, ambil yg belum selesai)
    final upcomingTasks = _tasks.where((t) => !t.isDone).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tugas Besar", style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt, color: AppColors.primary),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllTasksPage())),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildSummaryCard("Total Tugas", total.toString()),
                      const SizedBox(width: 16),
                      _buildSummaryCard("Selesai", selesai.toString()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("Tugas Terdekat", style: AppTextStyles.section),
                  const SizedBox(height: 16),
                  ...upcomingTasks.take(3).map((task) => _buildTaskCard(task)),
                ],
              ),
            ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
            _loadData();
          },
          label: const Text("Tambah Tugas", style: AppTextStyles.button),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSummaryCard(String title, String count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.body),
            const SizedBox(height: 8),
            Text(count, style: AppTextStyles.title.copyWith(fontSize: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(task.title, style: AppTextStyles.section),
        subtitle: Text("${task.course}\nDeadline: ${DateFormat('d MMM yyyy').format(task.deadline)}", style: AppTextStyles.caption),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: task.isDone ? AppColors.background : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            task.status,
            style: AppTextStyles.caption.copyWith(
              color: task.isDone ? AppColors.muted : AppColors.primary,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailTaskPage(task: task)));
          _loadData();
        },
      ),
    );
  }
}
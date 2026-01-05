// import 'package:flutter/material.dart';
// import 'package:cots/design_system/styles.dart';
// import 'package:cots/models/task.dart';
// import 'package:cots/services/task_service.dart';
// import 'package:cots/presentation/widgets/task_card.dart'; 
// import 'all_tasks_page.dart';
// import 'add_task_page.dart';
// import 'detail_task_page.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   final TaskService _service = TaskService();
//   List<Task> _tasks = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       final tasks = await _service.getTasks();
//       setState(() {
//         _tasks = tasks;
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final int total = _tasks.length;
//     final int selesai = _tasks.where((t) => t.isDone).length;
//     final upcomingTasks = _tasks.where((t) => !t.isDone).toList()
//       ..sort((a, b) => a.deadline.compareTo(b.deadline));

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text("Tugas Besar", style: AppTextStyles.title),
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         centerTitle: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.list_alt, color: AppColors.primary),
//             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllTasksPage())),
//           )
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: _loadData,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         _buildSummaryCard("Total Tugas", total.toString()),
//                         const SizedBox(width: 16),
//                         _buildSummaryCard("Selesai", selesai.toString()),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text("Tugas Terdekat", style: AppTextStyles.section),
//                         GestureDetector(
//                           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllTasksPage())),
//                           child: Text("Lihat Semua", style: AppTextStyles.button.copyWith(color: AppColors.primary)),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     if (upcomingTasks.isEmpty)
//                       const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Tidak ada tugas berjalan.", style: AppTextStyles.caption)))
//                     else
//                       ...upcomingTasks.take(3).map((task) => TaskCard(
//                         task: task,
//                         onTap: () async {
//                           await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailTaskPage(task: task)));
//                           _loadData(); 
//                         },
//                       )),
                    
//                     const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ),
//       floatingActionButton: SizedBox(
//         width: MediaQuery.of(context).size.width - 32,
//         child: FloatingActionButton.extended(
//           backgroundColor: AppColors.primary,
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           onPressed: () async {
//             await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
//             _loadData();
//           },
//           label: const Text("Tambah Tugas", style: AppTextStyles.button),
//           icon: const Icon(Icons.add, color: Colors.white),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//   Widget _buildSummaryCard(String title, String count) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.surface,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: AppTextStyles.body),
//             const SizedBox(height: 8),
//             Text(count, style: AppTextStyles.title.copyWith(fontSize: 32)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../design_system/styles.dart';
import '../../models/task.dart';
import '../../controllers/task_controller.dart';
import '../widgets/task_card.dart';
import 'all_tasks_page.dart';
import 'add_task_page.dart';
import 'detail_task_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Menggunakan TaskController static
      final tasks = await TaskController.getAllTasks();
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int total = _tasks.length;
    final int selesai = _tasks.where((t) => t.isDone).length;
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
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tugas Terdekat", style: AppTextStyles.section),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllTasksPage())),
                          child: Text("Lihat Semua", style: AppTextStyles.button.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (upcomingTasks.isEmpty)
                      const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Tidak ada tugas berjalan.", style: AppTextStyles.caption)))
                    else
                      ...upcomingTasks.take(3).map((task) => TaskCard(
                        task: task,
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailTaskPage(task: task)));
                          _loadData();
                        },
                      )),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
            _loadData();
          },
          label: const Text("Tambah Tugas", style: AppTextStyles.button),
          icon: const Icon(Icons.add, color: Colors.white),
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
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
          ],
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
}
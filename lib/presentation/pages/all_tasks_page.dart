// import 'package:flutter/material.dart';
// import 'package:cots/design_system/styles.dart';
// import 'package:cots/models/task.dart';
// import 'package:cots/services/task_service.dart';
// import 'package:cots/presentation/widgets/task_card.dart';
// import 'detail_task_page.dart';
// import 'add_task_page.dart';

// class AllTasksPage extends StatefulWidget {
//   const AllTasksPage({super.key});

//   @override
//   State<AllTasksPage> createState() => _AllTasksPageState();
// }

// class _AllTasksPageState extends State<AllTasksPage> {
//   final TaskService _service = TaskService();
//   List<Task> _tasks = [];
//   bool _isLoading = true;
//   String _selectedFilter = 'Semua';
//   final List<String> _filters = ['Semua', 'BERJALAN', 'SELESAI', 'TERLAMBAT']; // [cite: 135]

//   @override
//   void initState() {
//     super.initState();
//     _loadTasks();
//   }

//   Future<void> _loadTasks() async {
//     setState(() => _isLoading = true);
//     try {
//       final tasks = await _service.getTasks(status: _selectedFilter == 'Semua' ? null : _selectedFilter);
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
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text("Daftar Tugas", style: AppTextStyles.title),
//         backgroundColor: AppColors.background,
//         iconTheme: const IconThemeData(color: AppColors.text),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
//             onPressed: () async {
//               await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
//               _loadTasks();
//             },
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Cari tugas atau mata kuliah...",
//                 prefixIcon: const Icon(Icons.search, color: AppColors.muted),
//                 filled: true,
//                 fillColor: AppColors.surface,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               children: _filters.map((filter) {
//                 final isSelected = _selectedFilter == filter;
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8),
//                   child: FilterChip(
//                     label: Text(filter),
//                     selected: isSelected,
//                     showCheckmark: false,
//                     backgroundColor: AppColors.surface,
//                     selectedColor: AppColors.primary,
//                     labelStyle: TextStyle(
//                       color: isSelected ? Colors.white : AppColors.text,
//                       fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
//                     ),
//                     onSelected: (bool selected) {
//                       setState(() => _selectedFilter = filter);
//                       _loadTasks();
//                     },
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : RefreshIndicator(
//                     onRefresh: _loadTasks,
//                     child: _tasks.isEmpty
//                         ? const Center(child: Text("Tidak ada tugas ditemukan"))
//                         : ListView.builder(
//                             padding: const EdgeInsets.all(16),
//                             itemCount: _tasks.length,
//                             itemBuilder: (context, index) {
//                               final task = _tasks[index];
//                               return TaskCard(
//                                 task: task,
//                                 onTap: () async {
//                                   await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailTaskPage(task: task)));
//                                   _loadTasks();
//                                 },
//                               );
//                             },
//                           ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../design_system/styles.dart';
import '../../models/task.dart';
import '../../controllers/task_controller.dart';
import '../widgets/task_card.dart';
import 'detail_task_page.dart';
import 'add_task_page.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'BERJALAN', 'SELESAI', 'TERLAMBAT'];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final allTasks = await TaskController.getAllTasks();
      
      // Filter di sisi aplikasi karena endpoint get all
      List<Task> filteredTasks = allTasks;
      if (_selectedFilter != 'Semua') {
        filteredTasks = allTasks.where((t) => t.status == _selectedFilter).toList();
      }

      if (mounted) {
        setState(() {
          _tasks = filteredTasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari tugas atau mata kuliah...",
                prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    showCheckmark: false,
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.text,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                    onSelected: (bool selected) {
                      setState(() => _selectedFilter = filter);
                      _loadTasks();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadTasks,
                    child: _tasks.isEmpty
                        ? const Center(child: Text("Tidak ada tugas ditemukan"))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _tasks.length,
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return TaskCard(
                                task: task,
                                onTap: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailTaskPage(task: task)));
                                  _loadTasks();
                                },
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
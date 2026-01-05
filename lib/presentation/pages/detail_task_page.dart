import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design_system/styles.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

class DetailTaskPage extends StatefulWidget {
  final Task task;
  const DetailTaskPage({super.key, required this.task});

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  late TextEditingController _noteController;
  late bool _isDone;
  final TaskService _service = TaskService();

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.task.note);
    _isDone = widget.task.isDone;
  }

  Future<void> _saveChanges() async {
    // Update Note
    if (_noteController.text != widget.task.note) {
      await _service.updateTaskNote(widget.task.id!, _noteController.text);
    }
    // Update Status
    if (_isDone != widget.task.isDone) {
      await _service.updateTaskStatus(widget.task.id!, _isDone);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Detail Tugas", style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.text),
        elevation: 0,
        actions: [
          TextButton(onPressed: () {}, child: const Text("Edit", style: TextStyle(color: AppColors.primary)))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.task.title, style: AppTextStyles.title),
                  const SizedBox(height: 8),
                  Text(widget.task.course, style: AppTextStyles.body),
                  const SizedBox(height: 16),
                  Text("Deadline", style: AppTextStyles.caption),
                  Text(DateFormat('d MMM yyyy').format(widget.task.deadline), style: AppTextStyles.section),
                  const SizedBox(height: 16),
                  Text("Status", style: AppTextStyles.caption),
                  Chip(
                    label: Text(widget.task.status, style: const TextStyle(color: Colors.white)),
                    backgroundColor: AppColors.primary,
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Penyelesaian", style: AppTextStyles.section),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: CheckboxListTile(
                title: const Text("Tugas sudah selesai", style: AppTextStyles.body),
                subtitle: const Text("Centang jika tugas sudah final.", style: AppTextStyles.caption),
                value: _isDone,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  setState(() => _isDone = val!);
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text("Catatan", style: AppTextStyles.section),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: "Catatan tambahan...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveChanges,
                child: const Text("Simpan Perubahan", style: AppTextStyles.button),
              ),
            )
          ],
        ),
      ),
    );
  }
}
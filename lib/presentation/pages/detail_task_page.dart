import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cots/design_system/styles.dart';
import 'package:cots/models/task.dart';
import 'package:cots/services/task_service.dart';
import 'package:cots/presentation/widgets/custom_button.dart';
import 'package:cots/presentation/widgets/custom_textfield.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.task.note);
    _isDone = widget.task.isDone;
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      // Patch Update Note [cite: 182]
      if (_noteController.text != widget.task.note) {
        await _service.updateTaskNote(widget.task.id!, _noteController.text);
      }
      // Patch Update Status [cite: 190, 200]
      if (_isDone != widget.task.isDone) {
        await _service.updateTaskStatus(widget.task.id!, _isDone);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan perubahan")),
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
          // Tombol Edit dummy (sesuai desain Screen 3)
          TextButton(
            onPressed: () {},
            child: const Text(
              "Edit",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Detail Utama (Judul, Matkul, Deadline, Status) [cite: 37-41]
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.task.title, style: AppTextStyles.title),
                  const SizedBox(height: 8),
                  Text(
                    widget.task.course,
                    style: AppTextStyles.body.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 16),

                  // Row untuk Deadline & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Deadline", style: AppTextStyles.caption),
                          Text(
                            DateFormat(
                              'd MMM yyyy',
                            ).format(widget.task.deadline),
                            style: AppTextStyles.section,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Status", style: AppTextStyles.caption),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.task.status,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text("Penyelesaian", style: AppTextStyles.section),
            const SizedBox(height: 8),

            // Checkbox Penyelesaian [cite: 52]
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: const Text(
                  "Tugas sudah selesai",
                  style: AppTextStyles.body,
                ),
                subtitle: const Text(
                  "Centang jika tugas sudah final.",
                  style: AppTextStyles.caption,
                ),
                value: _isDone,
                activeColor: AppColors.primary,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onChanged: (val) {
                  setState(() => _isDone = val!);
                },
              ),
            ),

            const SizedBox(height: 24),
            // Input Catatan menggunakan CustomTextField [cite: 55-57]
            CustomTextField(
              label: "Catatan",
              hintText: "Pisahkan Controller, Service...",
              controller: _noteController,
              maxLines: 4,
            ),
          ],
        ),
      ),
      // Tombol Simpan menggunakan CustomButton [cite: 67]
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          label: "Simpan Perubahan",
          isLoading: _isLoading,
          onPressed: _saveChanges,
        ),
      ),
    );
  }
}

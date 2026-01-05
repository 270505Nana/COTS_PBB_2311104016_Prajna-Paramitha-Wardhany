import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cots/design_system/styles.dart';
import 'package:cots/models/task.dart';
import 'package:cots/services/task_service.dart';
import 'package:cots/presentation/widgets/custom_button.dart'; 
import 'package:cots/presentation/widgets/custom_textfield.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  // _courseController dihapus, diganti dengan state variable dropdown
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();
  
  DateTime? _selectedDate;
  String? _selectedCourse; // Variabel untuk menyimpan pilihan dropdown

  // List Mata Kuliah sesuai request
  final List<String> _courseList = [
    "PPB",
    "KWU",
    "PPW",
    "Manajemen Proyek",
    "Wawasan global TIK",
    "Penjaminan Mutu",
    "Design Thinking"
  ];

  final TaskService _service = TaskService();
  bool _isLoading = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      setState(() => _isLoading = true);
      
      final newTask = Task(
        title: _titleController.text,
        course: _selectedCourse!, // Mengambil value dari Dropdown
        deadline: _selectedDate!,
        status: "BERJALAN", 
        note: _noteController.text,
        isDone: false, // Default isDone [cite: 179]
      );

      try {
        await _service.addTask(newTask); // POST API [cite: 165]
        if (mounted) Navigator.pop(context);
      } catch (e) {
        print("ERROR SAAT POST: $e");
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menambah tugas")));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tanggal deadline wajib diisi")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tambah Tugas", style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // [cite: 42-43]
            CustomTextField(
              label: "Judul Tugas",
              hintText: "Masukkan judul tugas",
              controller: _titleController,
              validator: (val) => val!.isEmpty ? "Judul tugas wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            
            // --- BAGIAN DROPDOWN (PENGGANTI TEXTFIELD) ---
            // Menggunakan styling manual agar mirip dengan CustomTextField
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Mata Kuliah", style: AppTextStyles.section), // Label
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCourse,
                  hint: Text("Pilih mata kuliah", style: AppTextStyles.caption.copyWith(fontSize: 14)),
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface, // Background putih [cite: 6]
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  items: _courseList.map((String course) {
                    return DropdownMenuItem<String>(
                      value: course,
                      child: Text(course, style: AppTextStyles.body),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCourse = newValue;
                    });
                  },
                  validator: (val) => val == null ? "Mata kuliah wajib diisi" : null,
                ),
              ],
            ),
            // --- END DROPDOWN ---

            const SizedBox(height: 16),
            
            // [cite: 47-48]
            CustomTextField(
              label: "Deadline",
              hintText: "Pilih tanggal",
              controller: _dateController,
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.muted),
              readOnly: true,
              onTap: _pickDate,
              validator: (val) => val!.isEmpty ? "Tanggal wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            
            // [cite: 63]
            CustomTextField(
              label: "Catatan",
              hintText: "Catatan tambahan (opsional)",
              controller: _noteController,
              maxLines: 3,
            ),
          ],
        ),
      ),
      // Footer Button (Batal & Simpan) [cite: 66-68]
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                label: "Batal",
                isOutlined: true,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                label: "Simpan",
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cots/design_system/styles.dart';
import 'package:cots/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Logic warna status
    Color statusColor;
    Color statusBg;
    
    if (task.isDone) {
      statusColor = AppColors.muted;
      statusBg = AppColors.background;
    } else if (task.status == 'TERLAMBAT') {
      statusColor = AppColors.danger;
      statusBg = AppColors.danger.withOpacity(0.1);
    } else {
      statusColor = AppColors.primary;
      statusBg = AppColors.primary.withOpacity(0.1);
    }

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Indikator bulat kecil (seperti di desain List)
              if (!task.isDone) ...[
                Icon(Icons.circle, size: 10, color: statusColor),
                const SizedBox(width: 12),
              ],
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title, 
                      style: AppTextStyles.section,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.course, 
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.status,
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMM').format(task.deadline),
                    style: AppTextStyles.caption,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
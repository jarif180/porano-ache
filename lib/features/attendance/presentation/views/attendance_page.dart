import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/attendance_status.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../schedule/domain/entities/schedule_entity.dart';
import '../../../schedule/presentation/controllers/schedule_notifier.dart';
import '../controllers/attendance_notifier.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      ref.read(attendanceNotifierProvider.notifier).loadAttendanceForDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final attendanceState = ref.watch(attendanceNotifierProvider);
    final scheduleState = ref.watch(scheduleNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'দৈনিক উপস্থিতি' : 'Daily Attendance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/tutor-dashboard'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Date Selector Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        isBn
                            ? BanglaUtils.toBanglaDate(_selectedDate)
                            : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.edit_calendar, size: 16),
                    label: Text(isBn ? 'তারিখ পরিবর্তন' : 'Change Date'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Students Scheduled on this Date
            Expanded(
              child: scheduleState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(e.toString())),
                data: (allSchedules) {
                  // Find all classes scheduled for this weekday
                  final scheduledClasses = allSchedules
                      .where((s) => s.dayOfWeek == _selectedDate.weekday)
                      .toList();

                  if (scheduledClasses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_available, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            isBn ? 'এই তারিখে কোনো ক্লাস নির্ধারিত নেই' : 'No classes scheduled for this date',
                            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  return attendanceState.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text(e.toString())),
                    data: (attendanceRecords) {
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: scheduledClasses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final cls = scheduledClasses[index];

                          // Find if already marked
                          AttendanceStatus? markedStatus;
                          final match = attendanceRecords.where((r) => r.studentId == cls.studentId);
                          if (match.isNotEmpty) {
                            markedStatus = match.first.status;
                          }

                          return _buildAttendanceCard(cls, markedStatus, isBn);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(ScheduleEntity schedule, AttendanceStatus? currentStatus, bool isBn) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    schedule.studentName.isNotEmpty ? schedule.studentName[0] : 'S',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isBn ? schedule.studentNameBn : schedule.studentName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${schedule.subject} • ${schedule.startTime} - ${schedule.endTime}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (currentStatus != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: currentStatus.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isBn ? currentStatus.displayNameBn : currentStatus.displayNameEn,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: currentStatus.color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // One-tap Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: _buildStatusBtn(
                    status: AttendanceStatus.present,
                    isSelected: currentStatus == AttendanceStatus.present,
                    schedule: schedule,
                    isBn: isBn,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatusBtn(
                    status: AttendanceStatus.absent,
                    isSelected: currentStatus == AttendanceStatus.absent,
                    schedule: schedule,
                    isBn: isBn,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatusBtn(
                    status: AttendanceStatus.late,
                    isSelected: currentStatus == AttendanceStatus.late,
                    schedule: schedule,
                    isBn: isBn,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatusBtn(
                    status: AttendanceStatus.excused,
                    isSelected: currentStatus == AttendanceStatus.excused,
                    schedule: schedule,
                    isBn: isBn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBtn({
    required AttendanceStatus status,
    required bool isSelected,
    required ScheduleEntity schedule,
    required bool isBn,
  }) {
    return InkWell(
      onTap: () {
        ref.read(attendanceNotifierProvider.notifier).mark(
          studentId: schedule.studentId,
          studentName: schedule.studentName,
          studentNameBn: schedule.studentNameBn,
          scheduleId: schedule.id,
          date: _selectedDate,
          status: status,
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? status.color : status.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? status.color : status.color.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              status.icon,
              size: 16,
              color: isSelected ? Colors.white : status.color,
            ),
            const SizedBox(height: 2),
            Text(
              isBn ? status.displayNameBn : status.displayNameEn,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : status.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

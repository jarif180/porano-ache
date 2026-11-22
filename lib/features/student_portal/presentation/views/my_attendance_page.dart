import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../attendance/domain/entities/attendance_entity.dart';
import '../../../attendance/presentation/controllers/attendance_notifier.dart';

class MyAttendancePage extends ConsumerStatefulWidget {
  final String studentId;

  const MyAttendancePage({super.key, this.studentId = 'std_001'});

  @override
  ConsumerState<MyAttendancePage> createState() => _MyAttendancePageState();
}

class _MyAttendancePageState extends ConsumerState<MyAttendancePage> {
  AttendanceSummary? _summary;
  List<AttendanceEntity>? _history;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final notifier = ref.read(attendanceNotifierProvider.notifier);
    final summary = await notifier.getSummaryForStudent(widget.studentId);
    final history = await notifier.getHistoryForStudent(widget.studentId);
    if (mounted) {
      setState(() {
        _summary = summary;
        _history = history;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'আমার উপস্থিতি ও দিন গণনা' : 'My Attendance & Day Count'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student-dashboard'),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day Count Summary Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBn ? 'উপস্থিতির হার' : 'Attendance Rate',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isBn
                                ? '${BanglaUtils.toBanglaNumber((_summary?.ratePercentage ?? 0).toStringAsFixed(1))}%'
                                : '${(_summary?.ratePercentage ?? 0).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (_summary?.ratePercentage ?? 0) / 100.0,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Day Count Metrics Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            label: isBn ? 'মোট ক্লাস দিন' : 'Total Days',
                            count: isBn ? BanglaUtils.toBanglaNumber(_summary?.totalDays ?? 0) : '${_summary?.totalDays ?? 0}',
                            color: AppColors.secondary,
                            icon: Icons.calendar_month,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricCard(
                            label: isBn ? 'উপস্থিত' : 'Present',
                            count: isBn ? BanglaUtils.toBanglaNumber(_summary?.presentDays ?? 0) : '${_summary?.presentDays ?? 0}',
                            color: AppColors.present,
                            icon: Icons.check_circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricCard(
                            label: isBn ? 'অনুপস্থিত' : 'Absent',
                            count: isBn ? BanglaUtils.toBanglaNumber(_summary?.absentDays ?? 0) : '${_summary?.absentDays ?? 0}',
                            color: AppColors.absent,
                            icon: Icons.cancel,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricCard(
                            label: isBn ? 'দেরি' : 'Late',
                            count: isBn ? BanglaUtils.toBanglaNumber(_summary?.lateDays ?? 0) : '${_summary?.lateDays ?? 0}',
                            color: AppColors.late,
                            icon: Icons.access_time_filled,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Attendance History List
                    Text(
                      isBn ? 'উপস্থিতি ইতিহাস' : 'Attendance History',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    if (_history == null || _history!.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(isBn ? 'কোনো রেকর্ড নেই' : 'No records yet'),
                        ),
                      )
                    else
                      ..._history!.map((record) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isBn ? BanglaUtils.toBanglaDate(record.date) : '${record.date.day}/${record.date.month}/${record.date.year}',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  if (record.notes.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      record.notes,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: record.status.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isBn ? record.status.displayNameBn : record.status.displayNameEn,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: record.status.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

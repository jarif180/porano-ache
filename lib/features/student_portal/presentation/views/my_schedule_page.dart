import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../schedule/domain/entities/schedule_entity.dart';
import '../../../schedule/presentation/controllers/schedule_notifier.dart';

class MySchedulePage extends ConsumerWidget {
  final String studentId;

  const MySchedulePage({super.key, this.studentId = 'std_001'});

  String _getWeekdayName(int day, bool isBn) {
    switch (day) {
      case DateTime.saturday:
        return isBn ? 'শনিবার' : 'Saturday';
      case DateTime.sunday:
        return isBn ? 'রবিবার' : 'Sunday';
      case DateTime.monday:
        return isBn ? 'সোমবার' : 'Monday';
      case DateTime.tuesday:
        return isBn ? 'মঙ্গলবার' : 'Tuesday';
      case DateTime.wednesday:
        return isBn ? 'বুধবার' : 'Wednesday';
      case DateTime.thursday:
        return isBn ? 'বৃহস্পতিবার' : 'Thursday';
      case DateTime.friday:
        return isBn ? 'শুক্রবার' : 'Friday';
      default:
        return '';
    }
  }

  String _formatTimeRange(String start, String end, bool isBn) {
    if (!isBn) return '$start - $end';
    final partsStart = start.split(':');
    final partsEnd = end.split(':');
    final hStart = int.tryParse(partsStart[0]) ?? 0;
    final mStart = partsStart.length > 1 ? partsStart[1] : '00';
    final hEnd = int.tryParse(partsEnd[0]) ?? 0;
    final mEnd = partsEnd.length > 1 ? partsEnd[1] : '00';

    String period(int h) {
      if (h < 12) return 'সকাল';
      if (h < 16) return 'দুপুর';
      if (h < 19) return 'বিকাল';
      return 'রাত';
    }

    final h12Start = hStart > 12 ? hStart - 12 : (hStart == 0 ? 12 : hStart);
    final h12End = hEnd > 12 ? hEnd - 12 : (hEnd == 0 ? 12 : hEnd);

    return '${period(hStart)} ${BanglaUtils.toBanglaNumber(h12Start)}:${BanglaUtils.toBanglaNumber(mStart)} - ${period(hEnd)} ${BanglaUtils.toBanglaNumber(h12End)}:${BanglaUtils.toBanglaNumber(mEnd)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final scheduleState = ref.watch(scheduleNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'আমার সময়সূচী' : 'My Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student-dashboard'),
        ),
      ),
      body: SafeArea(
        child: scheduleState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (allSchedules) {
            // Filter to this student's schedules
            final myClasses = allSchedules.where((s) => s.studentId == studentId).toList()
              ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.secondary, Color(0xFF4338CA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBn ? 'সাপ্তাহিক রুটিন' : 'Weekly Routine',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isBn
                              ? 'সপ্তাহে মোট ${BanglaUtils.toBanglaNumber(myClasses.length)}টি ক্লাস নির্ধারিত আছে'
                              : 'Total ${myClasses.length} classes scheduled per week',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    isBn ? 'ক্লাস সূচি' : 'Class Timetable',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  if (myClasses.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          isBn ? 'কোনো ক্লাস নির্ধারিত নেই' : 'No classes assigned yet',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ...myClasses.map((cls) {
                      final isToday = cls.dayOfWeek == DateTime.now().weekday;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isToday ? AppColors.primary : AppColors.divider,
                            width: isToday ? 2.0 : 1.0,
                          ),
                          boxShadow: isToday
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _getWeekdayName(cls.dayOfWeek, isBn),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isToday ? AppColors.primary : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (isToday) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isBn ? 'আজ' : 'Today',
                                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    cls.subject,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(height: 1),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  _formatTimeRange(cls.startTime, cls.endTime, isBn),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  cls.location == ClassLocation.online
                                      ? Icons.laptop_mac
                                      : Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isBn ? cls.location.displayNameBn : cls.location.displayNameEn,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

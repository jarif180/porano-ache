import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../domain/entities/schedule_entity.dart';
import '../controllers/schedule_notifier.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  int _selectedDay = DateTime.now().weekday; // 1 = Monday ... 6 = Saturday, 7 = Sunday

  final List<Map<String, dynamic>> _weekdays = [
    {'day': DateTime.saturday, 'en': 'Sat', 'bn': 'শনি'},
    {'day': DateTime.sunday, 'en': 'Sun', 'bn': 'রবি'},
    {'day': DateTime.monday, 'en': 'Mon', 'bn': 'সোম'},
    {'day': DateTime.tuesday, 'en': 'Tue', 'bn': 'মঙ্গল'},
    {'day': DateTime.wednesday, 'en': 'Wed', 'bn': 'বুধ'},
    {'day': DateTime.thursday, 'en': 'Thu', 'bn': 'বৃহ'},
    {'day': DateTime.friday, 'en': 'Fri', 'bn': 'শুক্র'},
  ];

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
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final scheduleState = ref.watch(scheduleNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'সাপ্তাহিক সময়সূচী' : 'Weekly Timetable'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/tutor-dashboard'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Weekday Horizontal Selector
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _weekdays.map((item) {
                    final day = item['day'] as int;
                    final isSelected = day == _selectedDay;
                    final isToday = day == DateTime.now().weekday;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () => setState(() => _selectedDay = day),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 58,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : (isToday ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isToday ? AppColors.primary : AppColors.divider),
                              width: isToday ? 1.5 : 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                isBn ? item['bn'] : item['en'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? Colors.white
                                      : (isToday ? AppColors.primary : Colors.transparent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1),

            // Schedule List for Selected Day
            Expanded(
              child: scheduleState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(e.toString())),
                data: (allSchedules) {
                  final daySchedules = allSchedules
                      .where((s) => s.dayOfWeek == _selectedDay)
                      .toList()
                    ..sort((a, b) => a.startTime.compareTo(b.startTime));

                  if (daySchedules.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: AppColors.textMuted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isBn ? 'এই দিনে কোনো ক্লাস নেই' : 'No classes scheduled for this day',
                            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () => context.push('/schedule/add?day=$_selectedDay'),
                            icon: const Icon(Icons.add),
                            label: Text(isBn ? 'ক্লাস শিডিউল যোগ করুন' : 'Add Class Schedule'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: daySchedules.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final schedule = daySchedules[index];
                      return _buildScheduleCard(schedule, isBn);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/schedule/add?day=$_selectedDay'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          isBn ? 'ক্লাস যোগ করুন' : 'Add Class',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleEntity schedule, bool isBn) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.access_time_filled, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatTimeRange(schedule.startTime, schedule.endTime, isBn),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isBn ? schedule.studentNameBn : schedule.studentName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                  onSelected: (val) {
                    if (val == 'delete') {
                      _confirmDelete(schedule, isBn);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                          const SizedBox(width: 8),
                          Text(isBn ? 'মুছুন' : 'Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book, size: 14, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Text(
                        schedule.subject,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      schedule.location == ClassLocation.online
                          ? Icons.laptop_mac
                          : Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isBn ? schedule.location.displayNameBn : schedule.location.displayNameEn,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(ScheduleEntity schedule, bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isBn ? 'শিডিউল মুছে ফেলবেন?' : 'Delete Class?'),
        content: Text(
          isBn
              ? '${schedule.studentNameBn}-এর এই ক্লাস শিডিউলটি মুছে ফেলতে চান?'
              : 'Are you sure you want to delete this schedule for ${schedule.studentName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isBn ? 'বাতিল' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              ref.read(scheduleNotifierProvider.notifier).deleteSchedule(schedule.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isBn ? 'শিডিউল মুছে ফেলা হয়েছে' : 'Schedule deleted')),
              );
            },
            child: Text(isBn ? 'মুছে ফেলুন' : 'Delete'),
          ),
        ],
      ),
    );
  }
}

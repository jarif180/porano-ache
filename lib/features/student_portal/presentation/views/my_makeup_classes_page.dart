import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../makeup_classes/domain/entities/makeup_class_entity.dart';
import '../../../makeup_classes/presentation/controllers/makeup_class_notifier.dart';

class MyMakeupClassesPage extends ConsumerStatefulWidget {
  final String studentId;

  const MyMakeupClassesPage({super.key, this.studentId = 'std_001'});

  @override
  ConsumerState<MyMakeupClassesPage> createState() => _MyMakeupClassesPageState();
}

class _MyMakeupClassesPageState extends ConsumerState<MyMakeupClassesPage> {
  List<MakeupClassEntity> _classes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final list = await ref
        .read(makeupClassNotifierProvider.notifier)
        .getClassesForStudent(widget.studentId);
    if (mounted) {
      setState(() {
        _classes = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'আমার বিকল্প ক্লাসসমূহ' : 'My Makeup Classes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student-dashboard'),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _classes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_available, size: 64, color: AppColors.present.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text(
                          isBn ? 'আপনার কোন বিকল্প ক্লাস নেই!' : 'No makeup classes scheduled!',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _classes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _classes[index];
                      final isScheduled = item.status == MakeupClassStatus.scheduled;

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isScheduled ? AppColors.accent : AppColors.divider,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.subject,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (isScheduled ? AppColors.accent : AppColors.present).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.status.displayName(isBn),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isScheduled ? AppColors.accent : AppColors.present,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 6),
                                Text(
                                  isBn
                                      ? 'বিকল্প তারিখ: ${BanglaUtils.toBanglaDate(item.makeupDate)}'
                                      : 'Date: ${item.makeupDate.day}/${item.makeupDate.month}/${item.makeupDate.year}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 6),
                                Text(
                                  '${item.startTime} - ${item.endTime}',
                                  style: const TextStyle(fontSize: 13, color: AppColors.primary),
                                ),
                              ],
                            ),
                            if (item.reason.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                '${isBn ? "কারণ: " : "Reason: "}${item.reason}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../domain/entities/makeup_class_entity.dart';
import '../controllers/makeup_class_notifier.dart';

class MakeupClassListPage extends ConsumerWidget {
  const MakeupClassListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final state = ref.watch(makeupClassNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'বিকল্প ক্লাস ব্যবস্থাপনা' : 'Makeup Classes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/tutor-dashboard'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/makeup-classes/add'),
        icon: const Icon(Icons.add),
        label: Text(isBn ? 'নতুন বিকল্প ক্লাস' : 'Schedule Makeup'),
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (classes) {
            if (classes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.event_busy_outlined, size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    Text(
                      isBn ? 'কোন বিকল্প ক্লাস নির্ধারিত নেই' : 'No makeup classes scheduled',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: classes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = classes[index];
                final isScheduled = item.status == MakeupClassStatus.scheduled;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isScheduled
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.divider,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: isScheduled
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : Colors.grey.shade100,
                                child: Icon(
                                  Icons.event_repeat,
                                  color: isScheduled ? AppColors.primary : Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isBn ? item.studentNameBn : item.studentName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    item.subject,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          _buildStatusBadge(item.status, isBn),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.divider, height: 1),
                      const SizedBox(height: 12),

                      // Dates & Times
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isBn ? 'বিকল্প ক্লাসের তারিখ:' : 'Makeup Date:',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isBn
                                      ? BanglaUtils.toBanglaDate(item.makeupDate)
                                      : '${item.makeupDate.day}/${item.makeupDate.month}/${item.makeupDate.year}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${item.startTime} - ${item.endTime}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.primaryDark),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isBn ? 'মিস হওয়া ক্লাস:' : 'Original Missed Date:',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isBn
                                      ? BanglaUtils.toBanglaDate(item.originalDate)
                                      : '${item.originalDate.day}/${item.originalDate.month}/${item.originalDate.year}',
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (item.reason.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${isBn ? "কারণ: " : "Reason: "}${item.reason}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],

                      if (isScheduled) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                ref.read(makeupClassNotifierProvider.notifier).updateStatus(
                                      item.id,
                                      MakeupClassStatus.cancelled,
                                    );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.absent,
                                side: const BorderSide(color: AppColors.absent),
                                visualDensity: VisualDensity.compact,
                              ),
                              icon: const Icon(Icons.close, size: 16),
                              label: Text(isBn ? 'বাতিল' : 'Cancel'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                ref.read(makeupClassNotifierProvider.notifier).updateStatus(
                                      item.id,
                                      MakeupClassStatus.completed,
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.present,
                                foregroundColor: Colors.white,
                                visualDensity: VisualDensity.compact,
                              ),
                              icon: const Icon(Icons.check, size: 16),
                              label: Text(isBn ? 'সম্পন্ন চিহ্নিত করুন' : 'Mark Done'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(MakeupClassStatus status, bool isBn) {
    Color bg;
    Color fg;
    switch (status) {
      case MakeupClassStatus.scheduled:
        bg = AppColors.info.withValues(alpha: 0.12);
        fg = AppColors.info;
        break;
      case MakeupClassStatus.completed:
        bg = AppColors.present.withValues(alpha: 0.12);
        fg = AppColors.present;
        break;
      case MakeupClassStatus.cancelled:
        bg = AppColors.absent.withValues(alpha: 0.12);
        fg = AppColors.absent;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.displayName(isBn),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

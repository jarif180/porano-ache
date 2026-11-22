import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../domain/entities/progress_note_entity.dart';
import '../controllers/progress_notifier.dart';

class ProgressListPage extends ConsumerWidget {
  const ProgressListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final notesState = ref.watch(progressNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'অগ্রগতি ও মূল্যায়ন নোট' : 'Student Progress Notes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/tutor-dashboard'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/progress/add'),
        icon: const Icon(Icons.edit_note),
        label: Text(isBn ? 'নতুন মূল্যায়ন' : 'Add Note'),
      ),
      body: SafeArea(
        child: notesState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (notes) {
            if (notes.isEmpty) {
              return Center(
                child: Text(
                  isBn ? 'কোন অগ্রগতির রেকর্ড পাওয়া যায়নি' : 'No progress notes found',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final note = notes[index];
                return _buildNoteCard(context, ref, note, isBn);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoteCard(
    BuildContext context,
    WidgetRef ref,
    ProgressNoteEntity note,
    bool isBn,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? note.studentNameBn : note.studentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${note.subject} • ${isBn ? BanglaUtils.toBanglaDate(note.date) : "${note.date.day}/${note.date.month}/${note.date.year}"}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              _buildRatingStars(note.rating),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${isBn ? "টপিক: " : "Topic: "}${note.topic}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            note.notes,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: note.homeworkStatus == HomeworkStatus.completed
                      ? AppColors.present.withValues(alpha: 0.1)
                      : AppColors.absent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  note.homeworkStatus.displayName(isBn),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: note.homeworkStatus == HomeworkStatus.completed
                        ? AppColors.present
                        : AppColors.absent,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
                onPressed: () {
                  ref.read(progressNotifierProvider.notifier).deleteNote(note.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        if (rating >= starValue) {
          return const Icon(Icons.star, color: Colors.amber, size: 18);
        } else if (rating >= starValue - 0.5) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 18);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 18);
        }
      }),
    );
  }
}

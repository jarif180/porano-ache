import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../progress/domain/entities/progress_note_entity.dart';
import '../../../progress/presentation/controllers/progress_notifier.dart';

class MyProgressPage extends ConsumerStatefulWidget {
  final String studentId;

  const MyProgressPage({super.key, this.studentId = 'std_001'});

  @override
  ConsumerState<MyProgressPage> createState() => _MyProgressPageState();
}

class _MyProgressPageState extends ConsumerState<MyProgressPage> {
  List<ProgressNoteEntity> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await ref
        .read(progressNotifierProvider.notifier)
        .getNotesForStudent(widget.studentId);
    if (mounted) {
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'আমার অগ্রগতি ও ফলাফল' : 'My Academic Progress'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student-dashboard'),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Average Rating Summary Header
                    _buildSummaryCard(isBn),
                    const SizedBox(height: 24),

                    // Evaluation List
                    Text(
                      isBn ? 'সাম্প্রতিক মূল্যায়ন ও মতামত' : 'Recent Evaluations & Feedback',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),

                    if (_notes.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            isBn ? 'এখনো কোন মূল্যায়ন রেকর্ড নেই' : 'No evaluations recorded yet',
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _notes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final note = _notes[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      note.subject,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                                    ),
                                    _buildRatingStars(note.rating),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isBn
                                      ? 'তারিখ: ${BanglaUtils.toBanglaDate(note.date)}'
                                      : 'Date: ${note.date.day}/${note.date.month}/${note.date.year}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${isBn ? "টপিক: " : "Topic: "}${note.topic}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  note.notes,
                                  style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
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
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryCard(bool isBn) {
    final avgRating = _notes.isEmpty
        ? 0.0
        : _notes.fold<double>(0, (sum, n) => sum + n.rating) / _notes.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isBn ? 'সামগ্রিক পারফরম্যান্স রেটিং' : 'Overall Performance Rating',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Text('/ 5.0', style: TextStyle(color: Colors.white70, fontSize: 18)),
              const Spacer(),
              _buildRatingStars(avgRating, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isBn
                ? 'চমৎকার অগ্রগতি! নিয়মিত হোমওয়ার্ক ও অধ্যবসায় বজায় রাখো।'
                : 'Excellent progress! Keep up regular homework and study habits.',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        if (rating >= starValue) {
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (rating >= starValue - 0.5) {
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: size);
        }
      }),
    );
  }
}

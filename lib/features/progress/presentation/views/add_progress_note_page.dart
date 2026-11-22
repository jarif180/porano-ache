import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../students/domain/entities/student_entity.dart';
import '../../../students/presentation/controllers/student_notifier.dart';
import '../../domain/entities/progress_note_entity.dart';
import '../controllers/progress_notifier.dart';

class AddProgressNotePage extends ConsumerStatefulWidget {
  const AddProgressNotePage({super.key});

  @override
  ConsumerState<AddProgressNotePage> createState() => _AddProgressNotePageState();
}

class _AddProgressNotePageState extends ConsumerState<AddProgressNotePage> {
  final _formKey = GlobalKey<FormState>();

  StudentEntity? _selectedStudent;
  late TextEditingController _subjectController;
  late TextEditingController _topicController;
  late TextEditingController _notesController;

  DateTime _date = DateTime.now();
  double _rating = 5.0;
  HomeworkStatus _homeworkStatus = HomeworkStatus.completed;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: 'গণিত');
    _topicController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _topicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedStudent == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('অনুগ্রহ করে একজন শিক্ষার্থী নির্বাচন করুন')),
        );
        return;
      }

      ref.read(progressNotifierProvider.notifier).addNote(
            studentId: _selectedStudent!.id,
            studentName: _selectedStudent!.fullName,
            studentNameBn: _selectedStudent!.fullNameBn,
            date: _date,
            subject: _subjectController.text.trim(),
            topic: _topicController.text.trim(),
            notes: _notesController.text.trim(),
            rating: _rating,
            homeworkStatus: _homeworkStatus,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('মূল্যায়ন নোট সফলভাবে সংরক্ষিত হয়েছে!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final studentState = ref.watch(studentListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'নতুন মূল্যায়ন যোগ করুন' : 'Add Progress Evaluation'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Picker
                Text(
                  isBn ? 'শিক্ষার্থী' : 'Student',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                studentState.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Error loading students'),
                  data: (students) {
                    return DropdownButtonFormField<StudentEntity>(
                      value: _selectedStudent,
                      decoration: const InputDecoration(
                        hintText: 'শিক্ষার্থী নির্বাচন করুন',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      items: students.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(isBn ? '${s.fullNameBn} (${s.gradeLevel})' : '${s.fullName} (${s.gradeLevel})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedStudent = val;
                          if (val != null && val.subjects.isNotEmpty) {
                            _subjectController.text = val.subjects.first;
                          }
                        });
                      },
                      validator: (val) => val == null ? (isBn ? 'বাধ্যতামূলক' : 'Required') : null,
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Subject
                Text(
                  isBn ? 'বিষয়' : 'Subject',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.book_outlined)),
                  validator: (val) => (val == null || val.isEmpty) ? (isBn ? 'বাধ্যতামূলক' : 'Required') : null,
                ),
                const SizedBox(height: 20),

                // Topic
                Text(
                  isBn ? 'পাঠ্য বিষয় বা টপিক' : 'Topic Covered',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _topicController,
                  decoration: InputDecoration(
                    hintText: isBn ? 'উদা: বীজগণিত অধ্যায় ৪, সমীকরণ' : 'e.g. Chapter 4 Equations',
                    prefixIcon: const Icon(Icons.topic_outlined),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? (isBn ? 'বাধ্যতামূলক' : 'Required') : null,
                ),
                const SizedBox(height: 20),

                // Date Picker
                Text(
                  isBn ? 'তারিখ' : 'Date',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2025),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text(
                          isBn ? BanglaUtils.toBanglaDate(_date) : '${_date.day}/${_date.month}/${_date.year}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Star Rating Picker (1 to 5)
                Text(
                  isBn ? 'আজকের পারফরম্যান্স রেটিং' : 'Performance Rating',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          final star = index + 1;
                          return IconButton(
                            icon: Icon(
                              _rating >= star ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() => _rating = star.toDouble());
                            },
                          );
                        }),
                      ),
                      Text(
                        '$_rating / 5',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Homework Status Picker
                Text(
                  isBn ? 'হোমওয়ার্কের অবস্থা' : 'Homework Status',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<HomeworkStatus>(
                  value: _homeworkStatus,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.assignment_outlined)),
                  items: HomeworkStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.displayName(isBn)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _homeworkStatus = val);
                  },
                ),
                const SizedBox(height: 20),

                // Detailed Notes
                Text(
                  isBn ? 'শিক্ষার্থীর অগ্রগতি ও মন্তব্যের বিবরণ' : 'Progress Notes & Feedback',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: isBn
                        ? 'শিক্ষার্থী আজকের পড়ায় কতটা মনোযোগী ছিল, কোথায় উন্নতি দরকার...'
                        : 'Enter student feedback, areas for improvement...',
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? (isBn ? 'মন্তব্য লিখুন' : 'Required') : null,
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _save,
                    child: Text(isBn ? 'মূল্যায়ন সংরক্ষণ করুন' : 'Save Progress Evaluation'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

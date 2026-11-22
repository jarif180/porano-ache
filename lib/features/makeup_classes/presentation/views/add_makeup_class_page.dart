import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../students/domain/entities/student_entity.dart';
import '../../../students/presentation/controllers/student_notifier.dart';
import '../controllers/makeup_class_notifier.dart';

class AddMakeupClassPage extends ConsumerStatefulWidget {
  const AddMakeupClassPage({super.key});

  @override
  ConsumerState<AddMakeupClassPage> createState() => _AddMakeupClassPageState();
}

class _AddMakeupClassPageState extends ConsumerState<AddMakeupClassPage> {
  final _formKey = GlobalKey<FormState>();

  StudentEntity? _selectedStudent;
  late TextEditingController _subjectController;
  late TextEditingController _reasonController;

  DateTime _originalDate = DateTime.now().subtract(const Duration(days: 2));
  DateTime _makeupDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: 'গণিত');
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedStudent == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('অনুগ্রহ করে একজন শিক্ষার্থী নির্বাচন করুন')),
        );
        return;
      }

      ref.read(makeupClassNotifierProvider.notifier).addMakeupClass(
            studentId: _selectedStudent!.id,
            studentName: _selectedStudent!.fullName,
            studentNameBn: _selectedStudent!.fullNameBn,
            subject: _subjectController.text.trim(),
            originalDate: _originalDate,
            makeupDate: _makeupDate,
            startTime: _formatTimeOfDay(_startTime),
            endTime: _formatTimeOfDay(_endTime),
            reason: _reasonController.text.trim(),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('বিকল্প ক্লাস সফলভাবে শিডিউল করা হয়েছে!')),
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
        title: Text(isBn ? 'বিকল্প ক্লাস শিডিউল করুন' : 'Schedule Makeup Class'),
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
                        hintText: 'শিক্ষার্থী বেছে নিন',
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
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.book_outlined),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? (isBn ? 'বাধ্যতামূলক' : 'Required') : null,
                ),
                const SizedBox(height: 20),

                // Original Missed Date Picker
                Text(
                  isBn ? 'যেদিনের ক্লাস মিস হয়েছিল' : 'Original Missed Date',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _originalDate,
                      firstDate: DateTime(2025),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _originalDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event_busy, color: AppColors.absent),
                        const SizedBox(width: 12),
                        Text(
                          isBn ? BanglaUtils.toBanglaDate(_originalDate) : '${_originalDate.day}/${_originalDate.month}/${_originalDate.year}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // New Makeup Date Picker
                Text(
                  isBn ? 'নতুন বিকল্প ক্লাসের তারিখ' : 'New Makeup Date',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _makeupDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 60)),
                    );
                    if (picked != null) {
                      setState(() => _makeupDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event_available, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text(
                          isBn ? BanglaUtils.toBanglaDate(_makeupDate) : '${_makeupDate.day}/${_makeupDate.month}/${_makeupDate.year}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBn ? 'শুরুর সময়' : 'Start Time',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () async {
                              final picked = await showTimePicker(context: context, initialTime: _startTime);
                              if (picked != null) setState(() => _startTime = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.divider),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time, size: 18),
                                  const SizedBox(width: 8),
                                  Text(_formatTimeOfDay(_startTime)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBn ? 'শেষের সময়' : 'End Time',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () async {
                              final picked = await showTimePicker(context: context, initialTime: _endTime);
                              if (picked != null) setState(() => _endTime = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.divider),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time, size: 18),
                                  const SizedBox(width: 8),
                                  Text(_formatTimeOfDay(_endTime)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Reason
                Text(
                  isBn ? 'বিকল্প ক্লাসের কারণ' : 'Reason for Makeup',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: isBn ? 'ক্লাস পিছিয়ে নেওয়ার কারণ লিখুন...' : 'Enter reason...',
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _save,
                    child: Text(isBn ? 'শিডিউল সংরক্ষণ করুন' : 'Save Makeup Schedule'),
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

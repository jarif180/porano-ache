import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/student_entity.dart';
import '../controllers/student_notifier.dart';

class AddEditStudentPage extends ConsumerStatefulWidget {
  final String? studentId;

  const AddEditStudentPage({super.key, this.studentId});

  @override
  ConsumerState<AddEditStudentPage> createState() => _AddEditStudentPageState();
}

class _AddEditStudentPageState extends ConsumerState<AddEditStudentPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _nameBnController;
  late TextEditingController _institutionController;
  late TextEditingController _parentNameController;
  late TextEditingController _parentPhoneController;
  late TextEditingController _parentEmailController;
  late TextEditingController _feeController;
  late TextEditingController _notesController;

  String _selectedGrade = 'Class 10';
  final List<String> _selectedSubjects = [];
  String _inviteCode = '';
  bool _isInit = false;

  final List<String> _gradeOptions = [
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'SSC Candidate',
    'HSC (11th)',
    'HSC (12th)',
    'O Level',
    'A Level',
    'University Admission',
  ];

  final List<String> _availableSubjects = [
    'General Math',
    'Higher Math',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'ICT',
    'Accounting',
    'General Science',
    'Bangla',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameBnController = TextEditingController();
    _institutionController = TextEditingController();
    _parentNameController = TextEditingController();
    _parentPhoneController = TextEditingController();
    _parentEmailController = TextEditingController();
    _feeController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      if (widget.studentId != null) {
        // Edit mode - load existing student
        final studentState = ref.read(studentListNotifierProvider);
        studentState.whenData((students) {
          final existing = students.firstWhere((s) => s.id == widget.studentId);
          _nameController.text = existing.fullName;
          _nameBnController.text = existing.fullNameBn;
          _institutionController.text = existing.institution;
          _parentNameController.text = existing.parentName;
          _parentPhoneController.text = existing.parentPhone;
          _parentEmailController.text = existing.parentEmail;
          _feeController.text = existing.monthlyFee.toStringAsFixed(0);
          _notesController.text = existing.notes;
          _selectedGrade = existing.gradeLevel;
          _selectedSubjects.addAll(existing.subjects);
          _inviteCode = existing.inviteCode;
        });
      } else {
        // Create mode - generate random code
        _inviteCode = ref.read(studentListNotifierProvider.notifier).getNewInviteCode();
        _selectedSubjects.add('General Math');
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameBnController.dispose();
    _institutionController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _parentEmailController.dispose();
    _feeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedSubjects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('অনুগ্রহ করে অন্তত একটি বিষয় নির্বাচন করুন')),
        );
        return;
      }

      final student = StudentEntity(
        id: widget.studentId ?? 'std_${DateTime.now().millisecondsSinceEpoch}',
        tutorId: 'tutor_001',
        fullName: _nameController.text.trim(),
        fullNameBn: _nameBnController.text.trim().isNotEmpty
            ? _nameBnController.text.trim()
            : _nameController.text.trim(),
        gradeLevel: _selectedGrade,
        institution: _institutionController.text.trim(),
        subjects: List.from(_selectedSubjects),
        parentName: _parentNameController.text.trim(),
        parentPhone: _parentPhoneController.text.trim(),
        parentEmail: _parentEmailController.text.trim(),
        monthlyFee: double.tryParse(_feeController.text.trim()) ?? 0.0,
        inviteCode: _inviteCode,
        notes: _notesController.text.trim(),
        createdAt: DateTime.now(),
      );

      if (widget.studentId != null) {
        ref.read(studentListNotifierProvider.notifier).updateStudent(student);
      } else {
        ref.read(studentListNotifierProvider.notifier).addStudent(student);
      }

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.studentId != null;
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit
            ? (isBn ? 'শিক্ষার্থী সম্পাদনা' : 'Edit Student')
            : (isBn ? 'নতুন শিক্ষার্থী যোগ' : 'Add New Student')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Invite Code Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.key, color: AppColors.secondary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isBn ? 'শিক্ষার্থীর ইনভাইট কোড' : 'Student Invite Code',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            Text(
                              _inviteCode,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: AppColors.secondary, size: 20),
                        tooltip: isBn ? 'নতুন কোড তৈরি করুন' : 'Generate new code',
                        onPressed: () {
                          setState(() {
                            _inviteCode = ref.read(studentListNotifierProvider.notifier).getNewInviteCode();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Name Fields
                _buildSectionHeader(isBn ? 'সাধারণ তথ্যাবলী' : 'Basic Information'),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: isBn ? 'শিক্ষার্থীর নাম (ইংরেজিতে)' : 'Full Name (English)',
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'নাম প্রদান করুন' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _nameBnController,
                  decoration: InputDecoration(
                    labelText: isBn ? 'শিক্ষার্থীর নাম (বাংলায়)' : 'Full Name (Bangla)',
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 12),

                // Grade / Class Selector
                DropdownButtonFormField<String>(
                  value: _selectedGrade,
                  decoration: InputDecoration(
                    labelText: isBn ? 'শ্রেণি / গ্রেড' : 'Class / Grade',
                    prefixIcon: const Icon(Icons.school_outlined),
                  ),
                  items: _gradeOptions.map((grade) {
                    return DropdownMenuItem(
                      value: grade,
                      child: Text(grade),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedGrade = val);
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _institutionController,
                  decoration: InputDecoration(
                    labelText: isBn ? 'শিক্ষা প্রতিষ্ঠানের নাম' : 'School / College Name',
                    prefixIcon: const Icon(Icons.account_balance_outlined),
                  ),
                ),
                const SizedBox(height: 20),

                // Subjects Selection
                _buildSectionHeader(isBn ? 'পঠিত বিষয়সমূহ' : 'Subjects Taught'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableSubjects.map((subject) {
                    final isSelected = _selectedSubjects.contains(subject);
                    return FilterChip(
                      label: Text(subject),
                      selected: isSelected,
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSubjects.add(subject);
                          } else {
                            _selectedSubjects.remove(subject);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Guardian / Contact Info
                _buildSectionHeader(isBn ? 'অভিভাবকের তথ্য' : 'Guardian Contact'),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _parentNameController,
                  decoration: InputDecoration(
                    labelText: isBn ? 'অভিভাবকের নাম' : 'Parent / Guardian Name',
                    prefixIcon: const Icon(Icons.family_restroom_outlined),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'অভিভাবকের নাম দিন' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _parentPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: isBn ? 'অভিভাবকের মোবাইল নম্বর' : 'Parent Phone Number',
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'মোবাইল নম্বর দিন' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _parentEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: isBn ? 'অভিভাবকের ইমেইল (ঐচ্ছিক)' : 'Parent Email (Optional)',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 20),

                // Fee & Notes
                _buildSectionHeader(isBn ? 'বেতন ও মন্তব্য' : 'Fee & Notes'),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _feeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: isBn ? 'মাসিক বেতন (টাকা)' : 'Monthly Fee (BDT)',
                    prefixIcon: const Icon(Icons.attach_money_outlined),
                    suffixText: '৳',
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'মাসিক বেতন উল্লেখ করুন';
                    if (double.tryParse(val) == null) return 'সঠিক সংখ্যা দিন';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: isBn ? 'বিশেষ মন্তব্য / নোট' : 'Special Notes / Weak Areas',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.note_alt_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Submit Button
                ElevatedButton(
                  onPressed: _saveStudent,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: Text(
                    isEdit
                        ? (isBn ? 'পরিবর্তন সংরক্ষণ করুন' : 'Update Student')
                        : (isBn ? 'শিক্ষার্থী সংরক্ষণ করুন' : 'Save Student'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
      ),
    );
  }
}

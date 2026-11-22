import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../students/domain/entities/student_entity.dart';
import '../../../students/presentation/controllers/student_notifier.dart';
import '../../domain/entities/schedule_entity.dart';
import '../controllers/schedule_notifier.dart';

class AddEditSchedulePage extends ConsumerStatefulWidget {
  final int? initialDay;

  const AddEditSchedulePage({super.key, this.initialDay});

  @override
  ConsumerState<AddEditSchedulePage> createState() => _AddEditSchedulePageState();
}

class _AddEditSchedulePageState extends ConsumerState<AddEditSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  StudentEntity? _selectedStudent;
  String _selectedSubject = '';
  late int _selectedDay;
  TimeOfDay _startTime = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  ClassLocation _selectedLocation = ClassLocation.studentHome;
  final TextEditingController _locationDetailsController = TextEditingController();

  ScheduleEntity? _detectedConflict;

  final List<Map<String, dynamic>> _weekdays = [
    {'day': DateTime.saturday, 'en': 'Saturday', 'bn': 'শনিবার'},
    {'day': DateTime.sunday, 'en': 'Sunday', 'bn': 'রবিবার'},
    {'day': DateTime.monday, 'en': 'Monday', 'bn': 'সোমবার'},
    {'day': DateTime.tuesday, 'en': 'Tuesday', 'bn': 'মঙ্গলবার'},
    {'day': DateTime.wednesday, 'en': 'Wednesday', 'bn': 'বুধবার'},
    {'day': DateTime.thursday, 'en': 'Thursday', 'bn': 'বৃহস্পতিবার'},
    {'day': DateTime.friday, 'en': 'Friday', 'bn': 'শুক্রবার'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay ?? DateTime.saturday;
  }

  @override
  void dispose() {
    _locationDetailsController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final h = tod.hour.toString().padLeft(2, '0');
    final m = tod.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _checkConflict() async {
    final startStr = _formatTimeOfDay(_startTime);
    final endStr = _formatTimeOfDay(_endTime);

    final conflict = await ref.read(scheduleNotifierProvider.notifier).checkConflict(
      dayOfWeek: _selectedDay,
      startTime: startStr,
      endTime: endStr,
    );

    setState(() {
      _detectedConflict = conflict;
    });
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        // Auto adjust end time to 1 hour later if before
        final startMin = picked.hour * 60 + picked.minute;
        final endMin = _endTime.hour * 60 + _endTime.minute;
        if (endMin <= startMin) {
          _endTime = TimeOfDay(hour: (picked.hour + 1) % 24, minute: picked.minute);
        }
      });
      _checkConflict();
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() => _endTime = picked);
      _checkConflict();
    }
  }

  void _saveSchedule() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedStudent == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('অনুগ্রহ করে একজন শিক্ষার্থী নির্বাচন করুন')),
        );
        return;
      }

      final schedule = ScheduleEntity(
        id: 'sch_${DateTime.now().millisecondsSinceEpoch}',
        tutorId: 'tutor_001',
        studentId: _selectedStudent!.id,
        studentName: _selectedStudent!.fullName,
        studentNameBn: _selectedStudent!.fullNameBn,
        subject: _selectedSubject.isNotEmpty
            ? _selectedSubject
            : (_selectedStudent!.subjects.isNotEmpty ? _selectedStudent!.subjects.first : 'General Math'),
        dayOfWeek: _selectedDay,
        startTime: _formatTimeOfDay(_startTime),
        endTime: _formatTimeOfDay(_endTime),
        location: _selectedLocation,
        locationDetails: _locationDetailsController.text.trim(),
        recurrence: 'weekly',
        createdAt: DateTime.now(),
      );

      ref.read(scheduleNotifierProvider.notifier).addSchedule(schedule);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final studentState = ref.watch(studentListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'নতুন ক্লাস শিডিউল' : 'Add Class Schedule'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Conflict Warning Banner
                if (_detectedConflict != null) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.warning),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isBn
                                ? 'সতর্কতা: এই সময়ে ইতোমধ্যে ${_detectedConflict!.studentNameBn}-এর ক্লাস আছে (${_detectedConflict!.startTime} - ${_detectedConflict!.endTime})।'
                                : 'Warning: Conflict with ${_detectedConflict!.studentName}\'s class (${_detectedConflict!.startTime} - ${_detectedConflict!.endTime}).',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFC2410C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Student Selector Dropdown
                _buildSectionHeader(isBn ? 'শিক্ষার্থী ও বিষয়' : 'Student & Subject'),
                const SizedBox(height: 12),

                studentState.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                  data: (students) {
                    final activeStudents = students.where((s) => s.isActive).toList();
                    return DropdownButtonFormField<StudentEntity>(
                      value: _selectedStudent,
                      decoration: InputDecoration(
                        labelText: isBn ? 'শিক্ষার্থী নির্বাচন করুন' : 'Select Student',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      items: activeStudents.map((std) {
                        return DropdownMenuItem(
                          value: std,
                          child: Text('${isBn ? std.fullNameBn : std.fullName} (${std.gradeLevel})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedStudent = val;
                          if (val != null && val.subjects.isNotEmpty) {
                            _selectedSubject = val.subjects.first;
                          }
                        });
                      },
                      validator: (val) => val == null ? 'শিক্ষার্থী নির্বাচন করুন' : null,
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Subject Selector
                if (_selectedStudent != null && _selectedStudent!.subjects.isNotEmpty) ...[
                  Text(
                    isBn ? 'বিষয় নির্বাচন করুন' : 'Select Subject',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: _selectedStudent!.subjects.map((sub) {
                      final isSelected = _selectedSubject == sub;
                      return ChoiceChip(
                        label: Text(sub),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedSubject = sub);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Weekday Selector
                _buildSectionHeader(isBn ? 'সপ্তাহের দিন' : 'Day of Week'),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: _selectedDay,
                  decoration: InputDecoration(
                    labelText: isBn ? 'দিন' : 'Day',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  items: _weekdays.map((item) {
                    return DropdownMenuItem<int>(
                      value: item['day'] as int,
                      child: Text(isBn ? item['bn'] : item['en']),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedDay = val);
                      _checkConflict();
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Time Pickers
                _buildSectionHeader(isBn ? 'ক্লাসের সময়' : 'Class Time'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickStartTime,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(isBn ? 'শুরুর সময়' : 'Start Time', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 18, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text(_formatTimeOfDay(_startTime), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _pickEndTime,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(isBn ? 'শেষের সময়' : 'End Time', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 18, color: AppColors.secondary),
                                  const SizedBox(width: 6),
                                  Text(_formatTimeOfDay(_endTime), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Location Selector
                _buildSectionHeader(isBn ? 'ক্লাসের স্থান' : 'Location'),
                const SizedBox(height: 12),
                DropdownButtonFormField<ClassLocation>(
                  value: _selectedLocation,
                  decoration: InputDecoration(
                    labelText: isBn ? 'স্থান' : 'Location',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  items: ClassLocation.values.map((loc) {
                    return DropdownMenuItem(
                      value: loc,
                      child: Text(isBn ? loc.displayNameBn : loc.displayNameEn),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLocation = val);
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _locationDetailsController,
                  decoration: InputDecoration(
                    labelText: isBn ? 'বিস্তারিত ঠিকানা / অনলাইন লিংক' : 'Address Details / Online Link',
                    prefixIcon: const Icon(Icons.map_outlined),
                  ),
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _saveSchedule,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: Text(
                    isBn ? 'শিডিউল সংরক্ষণ করুন' : 'Save Class Schedule',
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

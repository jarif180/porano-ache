import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../models/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  // Pre-loaded schedule for the week (Saturday to Thursday classes typical in Bangladesh)
  final List<ScheduleModel> _schedules = [
    // Saturday: Tahmid (4:00 PM - 5:00 PM), Nusrat (5:30 PM - 7:00 PM)
    ScheduleModel(
      id: 'sch_001',
      tutorId: 'tutor_001',
      studentId: 'std_001',
      studentName: 'Tahmid Hasan',
      studentNameBn: 'তাহমিদ হাসান',
      subject: 'Higher Math',
      dayOfWeek: DateTime.saturday,
      startTime: '16:00',
      endTime: '17:00',
      location: ClassLocation.studentHome,
      locationDetails: 'Dhanmondi, Road 8/A',
      recurrence: 'weekly',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ScheduleModel(
      id: 'sch_002',
      tutorId: 'tutor_001',
      studentId: 'std_002',
      studentName: 'Nusrat Jahan',
      studentNameBn: 'নুসরাত জাহান',
      subject: 'Physics',
      dayOfWeek: DateTime.saturday,
      startTime: '17:30',
      endTime: '19:00',
      location: ClassLocation.studentHome,
      locationDetails: 'Lalmatia, Block C',
      recurrence: 'weekly',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    // Monday: Tahmid (4:00 PM - 5:00 PM), Rafi (8:00 PM - 9:00 PM)
    ScheduleModel(
      id: 'sch_003',
      tutorId: 'tutor_001',
      studentId: 'std_001',
      studentName: 'Tahmid Hasan',
      studentNameBn: 'তাহমিদ হাসান',
      subject: 'General Math',
      dayOfWeek: DateTime.monday,
      startTime: '16:00',
      endTime: '17:00',
      location: ClassLocation.studentHome,
      locationDetails: 'Dhanmondi, Road 8/A',
      recurrence: 'weekly',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ScheduleModel(
      id: 'sch_004',
      tutorId: 'tutor_001',
      studentId: 'std_003',
      studentName: 'Rafi Alvi',
      studentNameBn: 'রাফি আলভী',
      subject: 'General Science',
      dayOfWeek: DateTime.monday,
      startTime: '20:00',
      endTime: '21:00',
      location: ClassLocation.online,
      locationDetails: 'Google Meet',
      recurrence: 'weekly',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    // Wednesday: Tahmid (4:00 PM - 5:00 PM), Nusrat (5:30 PM - 7:00 PM)
    ScheduleModel(
      id: 'sch_005',
      tutorId: 'tutor_001',
      studentId: 'std_001',
      studentName: 'Tahmid Hasan',
      studentNameBn: 'তাহমিদ হাসান',
      subject: 'Higher Math',
      dayOfWeek: DateTime.wednesday,
      startTime: '16:00',
      endTime: '17:00',
      location: ClassLocation.studentHome,
      locationDetails: 'Dhanmondi, Road 8/A',
      recurrence: 'weekly',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ScheduleModel(
      id: 'sch_006',
      tutorId: 'tutor_001',
      studentId: 'std_002',
      studentName: 'Nusrat Jahan',
      studentNameBn: 'নুসরাত জাহান',
      subject: 'Chemistry',
      dayOfWeek: DateTime.wednesday,
      startTime: '17:30',
      endTime: '19:00',
      location: ClassLocation.studentHome,
      locationDetails: 'Lalmatia, Block C',
      recurrence: 'weekly',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Future<List<ScheduleEntity>> getSchedules({bool activeOnly = true}) async {
    if (activeOnly) {
      return List.unmodifiable(_schedules.where((s) => s.isActive));
    }
    return List.unmodifiable(_schedules);
  }

  @override
  Future<List<ScheduleEntity>> getSchedulesForDay(int dayOfWeek) async {
    return List.unmodifiable(
      _schedules.where((s) => s.isActive && s.dayOfWeek == dayOfWeek),
    );
  }

  @override
  Future<List<ScheduleEntity>> getSchedulesForStudent(String studentId) async {
    return List.unmodifiable(
      _schedules.where((s) => s.isActive && s.studentId == studentId),
    );
  }

  @override
  Future<void> addSchedule(ScheduleEntity schedule) async {
    _schedules.add(ScheduleModel.fromEntity(schedule));
  }

  @override
  Future<void> updateSchedule(ScheduleEntity schedule) async {
    final idx = _schedules.indexWhere((s) => s.id == schedule.id);
    if (idx != -1) {
      _schedules[idx] = ScheduleModel.fromEntity(schedule);
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    _schedules.removeWhere((s) => s.id == id);
  }

  @override
  Future<ScheduleEntity?> checkConflict({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    String? excludeScheduleId,
  }) async {
    final newStart = _parseTime(startTime);
    final newEnd = _parseTime(endTime);

    for (final schedule in _schedules) {
      if (!schedule.isActive) continue;
      if (excludeScheduleId != null && schedule.id == excludeScheduleId) continue;
      if (schedule.dayOfWeek != dayOfWeek) continue;

      final existingStart = _parseTime(schedule.startTime);
      final existingEnd = _parseTime(schedule.endTime);

      // Overlap condition: start < existingEnd && end > existingStart
      if (newStart < existingEnd && newEnd > existingStart) {
        return schedule;
      }
    }
    return null;
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return hour * 60 + minute;
  }
}

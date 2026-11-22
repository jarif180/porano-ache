import '../../../../core/enums/attendance_status.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final List<AttendanceModel> _records = [
    // Tahmid's records (45 total classes: 40 present, 5 absent/late)
    ...List.generate(40, (i) {
      final date = DateTime.now().subtract(Duration(days: (45 - i) * 2));
      return AttendanceModel(
        id: 'att_std1_p_$i',
        scheduleId: 'sch_001',
        studentId: 'std_001',
        studentName: 'Tahmid Hasan',
        studentNameBn: 'তাহমিদ হাসান',
        tutorId: 'tutor_001',
        date: date,
        status: AttendanceStatus.present,
        notes: '',
        markedAt: date.add(const Duration(hours: 1)),
      );
    }),
    ...List.generate(3, (i) {
      final date = DateTime.now().subtract(Duration(days: (i + 1) * 7));
      return AttendanceModel(
        id: 'att_std1_a_$i',
        scheduleId: 'sch_001',
        studentId: 'std_001',
        studentName: 'Tahmid Hasan',
        studentNameBn: 'তাহমিদ হাসান',
        tutorId: 'tutor_001',
        date: date,
        status: AttendanceStatus.absent,
        notes: 'Sickness / School exam',
        markedAt: date.add(const Duration(hours: 1)),
      );
    }),
    ...List.generate(2, (i) {
      final date = DateTime.now().subtract(Duration(days: (i + 2) * 5));
      return AttendanceModel(
        id: 'att_std1_l_$i',
        scheduleId: 'sch_001',
        studentId: 'std_001',
        studentName: 'Tahmid Hasan',
        studentNameBn: 'তাহমিদ হাসান',
        tutorId: 'tutor_001',
        date: date,
        status: AttendanceStatus.late,
        notes: 'Late 15 min due to traffic',
        markedAt: date.add(const Duration(hours: 1)),
      );
    }),
  ];

  @override
  Future<List<AttendanceEntity>> getAttendanceForDate(DateTime date) async {
    return _records.where((r) {
      return r.date.year == date.year &&
          r.date.month == date.month &&
          r.date.day == date.day;
    }).toList();
  }

  @override
  Future<List<AttendanceEntity>> getAttendanceForStudent(String studentId) async {
    return _records
        .where((r) => r.studentId == studentId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<AttendanceSummary> getStudentSummary(String studentId) async {
    final list = _records.where((r) => r.studentId == studentId).toList();
    final present = list.where((r) => r.status == AttendanceStatus.present).length;
    final absent = list.where((r) => r.status == AttendanceStatus.absent).length;
    final late = list.where((r) => r.status == AttendanceStatus.late).length;
    final excused = list.where((r) => r.status == AttendanceStatus.excused).length;

    return AttendanceSummary(
      totalDays: list.length,
      presentDays: present,
      absentDays: absent,
      lateDays: late,
      excusedDays: excused,
    );
  }

  @override
  Future<void> markAttendance({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required String scheduleId,
    required DateTime date,
    required AttendanceStatus status,
    String notes = '',
  }) async {
    // Check if record exists for this student on this day
    final existingIdx = _records.indexWhere((r) {
      return r.studentId == studentId &&
          r.date.year == date.year &&
          r.date.month == date.month &&
          r.date.day == date.day;
    });

    if (existingIdx != -1) {
      _records[existingIdx] = AttendanceModel.fromEntity(
        _records[existingIdx].copyWith(
          status: status,
          notes: notes,
          markedAt: DateTime.now(),
        ),
      );
    } else {
      _records.add(
        AttendanceModel(
          id: 'att_${DateTime.now().millisecondsSinceEpoch}',
          scheduleId: scheduleId,
          studentId: studentId,
          studentName: studentName,
          studentNameBn: studentNameBn,
          tutorId: 'tutor_001',
          date: date,
          status: status,
          notes: notes,
          markedAt: DateTime.now(),
        ),
      );
    }
  }
}

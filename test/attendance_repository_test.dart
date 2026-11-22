import 'package:flutter_test/flutter_test.dart';
import 'package:porano_ache/core/enums/attendance_status.dart';
import 'package:porano_ache/features/attendance/data/repositories/attendance_repository_impl.dart';

void main() {
  group('AttendanceRepositoryImpl Tests', () {
    late AttendanceRepositoryImpl repository;

    setUp(() {
      repository = AttendanceRepositoryImpl();
    });

    test('getStudentSummary calculates counts and rate accurately', () async {
      final summary = await repository.getStudentSummary('std_001');
      expect(summary.totalDays, 45);
      expect(summary.presentDays, 40);
      expect(summary.absentDays, 3);
      expect(summary.lateDays, 2);
      expect(summary.ratePercentage, closeTo(88.88, 0.1));
    });

    test('markAttendance creates new attendance record', () async {
      final testDate = DateTime(2026, 11, 25);
      await repository.markAttendance(
        studentId: 'std_002',
        studentName: 'Nusrat Jahan',
        studentNameBn: 'নুসরাত জাহান',
        scheduleId: 'sch_002',
        date: testDate,
        status: AttendanceStatus.present,
      );

      final records = await repository.getAttendanceForDate(testDate);
      expect(records.length, 1);
      expect(records.first.studentId, 'std_002');
      expect(records.first.status, AttendanceStatus.present);
    });

    test('markAttendance updates existing record if already marked on same date', () async {
      final testDate = DateTime(2026, 11, 26);
      await repository.markAttendance(
        studentId: 'std_003',
        studentName: 'Rafi Alvi',
        studentNameBn: 'রাফি আলভী',
        scheduleId: 'sch_004',
        date: testDate,
        status: AttendanceStatus.present,
      );

      // Change to absent
      await repository.markAttendance(
        studentId: 'std_003',
        studentName: 'Rafi Alvi',
        studentNameBn: 'রাফি আলভী',
        scheduleId: 'sch_004',
        date: testDate,
        status: AttendanceStatus.absent,
        notes: 'Had a fever',
      );

      final records = await repository.getAttendanceForDate(testDate);
      expect(records.length, 1);
      expect(records.first.status, AttendanceStatus.absent);
      expect(records.first.notes, 'Had a fever');
    });
  });
}

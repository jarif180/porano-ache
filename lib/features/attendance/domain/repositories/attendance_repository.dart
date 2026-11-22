import '../../../../core/enums/attendance_status.dart';
import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceEntity>> getAttendanceForDate(DateTime date);
  Future<List<AttendanceEntity>> getAttendanceForStudent(String studentId);
  Future<AttendanceSummary> getStudentSummary(String studentId);
  Future<void> markAttendance({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required String scheduleId,
    required DateTime date,
    required AttendanceStatus status,
    String notes,
  });
}

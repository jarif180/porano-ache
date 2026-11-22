import '../../../../core/enums/attendance_status.dart';

class AttendanceEntity {
  final String id;
  final String scheduleId;
  final String studentId;
  final String studentName;
  final String studentNameBn;
  final String tutorId;
  final DateTime date;
  final AttendanceStatus status;
  final String notes;
  final DateTime markedAt;

  const AttendanceEntity({
    required this.id,
    required this.scheduleId,
    required this.studentId,
    required this.studentName,
    required this.studentNameBn,
    required this.tutorId,
    required this.date,
    required this.status,
    this.notes = '',
    required this.markedAt,
  });

  AttendanceEntity copyWith({
    String? id,
    String? scheduleId,
    String? studentId,
    String? studentName,
    String? studentNameBn,
    String? tutorId,
    DateTime? date,
    AttendanceStatus? status,
    String? notes,
    DateTime? markedAt,
  }) {
    return AttendanceEntity(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentNameBn: studentNameBn ?? this.studentNameBn,
      tutorId: tutorId ?? this.tutorId,
      date: date ?? this.date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      markedAt: markedAt ?? this.markedAt,
    );
  }
}

class AttendanceSummary {
  final int totalDays;
  final int presentDays;
  final int absentDays;
  final int lateDays;
  final int excusedDays;

  const AttendanceSummary({
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
    required this.excusedDays,
  });

  double get ratePercentage {
    if (totalDays == 0) return 0.0;
    return (presentDays / totalDays) * 100.0;
  }
}

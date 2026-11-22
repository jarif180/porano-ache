import '../../../../core/enums/attendance_status.dart';
import '../../domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required super.id,
    required super.scheduleId,
    required super.studentId,
    required super.studentName,
    required super.studentNameBn,
    required super.tutorId,
    required super.date,
    required super.status,
    super.notes = '',
    required super.markedAt,
  });

  factory AttendanceModel.fromEntity(AttendanceEntity entity) {
    return AttendanceModel(
      id: entity.id,
      scheduleId: entity.scheduleId,
      studentId: entity.studentId,
      studentName: entity.studentName,
      studentNameBn: entity.studentNameBn,
      tutorId: entity.tutorId,
      date: entity.date,
      status: entity.status,
      notes: entity.notes,
      markedAt: entity.markedAt,
    );
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map, String id) {
    return AttendanceModel(
      id: id,
      scheduleId: map['scheduleId'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      studentNameBn: map['studentNameBn'] as String? ?? '',
      tutorId: map['tutorId'] as String? ?? '',
      date: map['date'] != null
          ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: AttendanceStatus.values.firstWhere(
        (st) => st.name == map['status'],
        orElse: () => AttendanceStatus.present,
      ),
      notes: map['notes'] as String? ?? '',
      markedAt: map['markedAt'] != null
          ? DateTime.tryParse(map['markedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scheduleId': scheduleId,
      'studentId': studentId,
      'studentName': studentName,
      'studentNameBn': studentNameBn,
      'tutorId': tutorId,
      'date': date.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'markedAt': markedAt.toIso8601String(),
    };
  }
}

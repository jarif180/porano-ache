import '../../domain/entities/makeup_class_entity.dart';

class MakeupClassModel extends MakeupClassEntity {
  const MakeupClassModel({
    required super.id,
    super.originalScheduleId = '',
    required super.studentId,
    required super.studentName,
    required super.studentNameBn,
    required super.tutorId,
    required super.subject,
    required super.originalDate,
    required super.makeupDate,
    required super.startTime,
    required super.endTime,
    required super.reason,
    required super.status,
    required super.createdAt,
  });

  factory MakeupClassModel.fromEntity(MakeupClassEntity entity) {
    return MakeupClassModel(
      id: entity.id,
      originalScheduleId: entity.originalScheduleId,
      studentId: entity.studentId,
      studentName: entity.studentName,
      studentNameBn: entity.studentNameBn,
      tutorId: entity.tutorId,
      subject: entity.subject,
      originalDate: entity.originalDate,
      makeupDate: entity.makeupDate,
      startTime: entity.startTime,
      endTime: entity.endTime,
      reason: entity.reason,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  factory MakeupClassModel.fromMap(Map<String, dynamic> map, String docId) {
    return MakeupClassModel(
      id: docId,
      originalScheduleId: map['originalScheduleId'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      studentNameBn: map['studentNameBn'] as String? ?? '',
      tutorId: map['tutorId'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      originalDate: DateTime.tryParse(map['originalDate'] as String? ?? '') ?? DateTime.now(),
      makeupDate: DateTime.tryParse(map['makeupDate'] as String? ?? '') ?? DateTime.now(),
      startTime: map['startTime'] as String? ?? '16:00',
      endTime: map['endTime'] as String? ?? '17:00',
      reason: map['reason'] as String? ?? '',
      status: MakeupClassStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => MakeupClassStatus.scheduled,
      ),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originalScheduleId': originalScheduleId,
      'studentId': studentId,
      'studentName': studentName,
      'studentNameBn': studentNameBn,
      'tutorId': tutorId,
      'subject': subject,
      'originalDate': originalDate.toIso8601String(),
      'makeupDate': makeupDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'reason': reason,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

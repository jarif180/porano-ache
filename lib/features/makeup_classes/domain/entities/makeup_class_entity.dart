enum MakeupClassStatus {
  scheduled,
  completed,
  cancelled;

  String displayName(bool isBn) {
    switch (this) {
      case MakeupClassStatus.scheduled:
        return isBn ? 'নির্ধারিত' : 'Scheduled';
      case MakeupClassStatus.completed:
        return isBn ? 'সম্পন্ন' : 'Completed';
      case MakeupClassStatus.cancelled:
        return isBn ? 'বাতিল' : 'Cancelled';
    }
  }
}

class MakeupClassEntity {
  final String id;
  final String originalScheduleId;
  final String studentId;
  final String studentName;
  final String studentNameBn;
  final String tutorId;
  final String subject;
  final DateTime originalDate;
  final DateTime makeupDate;
  final String startTime;
  final String endTime;
  final String reason;
  final MakeupClassStatus status;
  final DateTime createdAt;

  const MakeupClassEntity({
    required this.id,
    this.originalScheduleId = '',
    required this.studentId,
    required this.studentName,
    required this.studentNameBn,
    required this.tutorId,
    required this.subject,
    required this.originalDate,
    required this.makeupDate,
    required this.startTime,
    required this.endTime,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  MakeupClassEntity copyWith({
    String? id,
    String? originalScheduleId,
    String? studentId,
    String? studentName,
    String? studentNameBn,
    String? tutorId,
    String? subject,
    DateTime? originalDate,
    DateTime? makeupDate,
    String? startTime,
    String? endTime,
    String? reason,
    MakeupClassStatus? status,
    DateTime? createdAt,
  }) {
    return MakeupClassEntity(
      id: id ?? this.id,
      originalScheduleId: originalScheduleId ?? this.originalScheduleId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentNameBn: studentNameBn ?? this.studentNameBn,
      tutorId: tutorId ?? this.tutorId,
      subject: subject ?? this.subject,
      originalDate: originalDate ?? this.originalDate,
      makeupDate: makeupDate ?? this.makeupDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

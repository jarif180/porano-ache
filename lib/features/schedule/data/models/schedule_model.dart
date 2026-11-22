import '../../domain/entities/schedule_entity.dart';

class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({
    required super.id,
    required super.tutorId,
    required super.studentId,
    required super.studentName,
    required super.studentNameBn,
    required super.subject,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    super.location = ClassLocation.studentHome,
    super.locationDetails = '',
    super.recurrence = 'weekly',
    super.isActive = true,
    required super.createdAt,
  });

  factory ScheduleModel.fromEntity(ScheduleEntity entity) {
    return ScheduleModel(
      id: entity.id,
      tutorId: entity.tutorId,
      studentId: entity.studentId,
      studentName: entity.studentName,
      studentNameBn: entity.studentNameBn,
      subject: entity.subject,
      dayOfWeek: entity.dayOfWeek,
      startTime: entity.startTime,
      endTime: entity.endTime,
      location: entity.location,
      locationDetails: entity.locationDetails,
      recurrence: entity.recurrence,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map, String id) {
    return ScheduleModel(
      id: id,
      tutorId: map['tutorId'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      studentNameBn: map['studentNameBn'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      dayOfWeek: (map['dayOfWeek'] as num?)?.toInt() ?? 1,
      startTime: map['startTime'] as String? ?? '16:00',
      endTime: map['endTime'] as String? ?? '17:00',
      location: ClassLocation.values.firstWhere(
        (loc) => loc.name == map['location'],
        orElse: () => ClassLocation.studentHome,
      ),
      locationDetails: map['locationDetails'] as String? ?? '',
      recurrence: map['recurrence'] as String? ?? 'weekly',
      isActive: map['isActive'] as bool? ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tutorId': tutorId,
      'studentId': studentId,
      'studentName': studentName,
      'studentNameBn': studentNameBn,
      'subject': subject,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'location': location.name,
      'locationDetails': locationDetails,
      'recurrence': recurrence,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

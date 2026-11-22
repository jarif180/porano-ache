enum ClassLocation {
  tutorHome,
  studentHome,
  online,
  institution;

  String get displayNameEn {
    switch (this) {
      case ClassLocation.tutorHome:
        return 'Tutor\'s Place';
      case ClassLocation.studentHome:
        return 'Student\'s Home';
      case ClassLocation.online:
        return 'Online (Zoom / Meet)';
      case ClassLocation.institution:
        return 'Coaching / Center';
    }
  }

  String get displayNameBn {
    switch (this) {
      case ClassLocation.tutorHome:
        return 'শিক্ষকের বাসায়';
      case ClassLocation.studentHome:
        return 'শিক্ষার্থীর বাসায়';
      case ClassLocation.online:
        return 'অনলাইন (গুগল মিট / জুম)';
      case ClassLocation.institution:
        return 'কোচিং সেন্টার';
    }
  }
}

class ScheduleEntity {
  final String id;
  final String tutorId;
  final String studentId;
  final String studentName;
  final String studentNameBn;
  final String subject;
  final int dayOfWeek; // 1 = Monday ... 6 = Saturday, 7 = Sunday (DateTime standard)
  final String startTime; // '16:00' (24-hr)
  final String endTime; // '17:00' (24-hr)
  final ClassLocation location;
  final String locationDetails;
  final String recurrence; // 'weekly', 'biweekly', 'one-time'
  final bool isActive;
  final DateTime createdAt;

  const ScheduleEntity({
    required this.id,
    required this.tutorId,
    required this.studentId,
    required this.studentName,
    required this.studentNameBn,
    required this.subject,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.location = ClassLocation.studentHome,
    this.locationDetails = '',
    this.recurrence = 'weekly',
    this.isActive = true,
    required this.createdAt,
  });

  ScheduleEntity copyWith({
    String? id,
    String? tutorId,
    String? studentId,
    String? studentName,
    String? studentNameBn,
    String? subject,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    ClassLocation? location,
    String? locationDetails,
    String? recurrence,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      tutorId: tutorId ?? this.tutorId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentNameBn: studentNameBn ?? this.studentNameBn,
      subject: subject ?? this.subject,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      locationDetails: locationDetails ?? this.locationDetails,
      recurrence: recurrence ?? this.recurrence,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

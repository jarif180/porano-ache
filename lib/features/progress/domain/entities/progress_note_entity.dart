enum HomeworkStatus {
  completed,
  incomplete,
  notAssigned;

  String displayName(bool isBn) {
    switch (this) {
      case HomeworkStatus.completed:
        return isBn ? 'হোমওয়ার্ক সম্পন্ন' : 'HW Completed';
      case HomeworkStatus.incomplete:
        return isBn ? 'হোমওয়ার্ক অসম্পূর্ণ' : 'HW Incomplete';
      case HomeworkStatus.notAssigned:
        return isBn ? 'দেওয়া হয়নি' : 'No HW';
    }
  }
}

class ProgressNoteEntity {
  final String id;
  final String studentId;
  final String studentName;
  final String studentNameBn;
  final String tutorId;
  final DateTime date;
  final String subject;
  final String topic;
  final String notes;
  final double rating; // 1.0 to 5.0
  final HomeworkStatus homeworkStatus;
  final DateTime createdAt;

  const ProgressNoteEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentNameBn,
    required this.tutorId,
    required this.date,
    required this.subject,
    required this.topic,
    required this.notes,
    required this.rating,
    required this.homeworkStatus,
    required this.createdAt,
  });

  ProgressNoteEntity copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? studentNameBn,
    String? tutorId,
    DateTime? date,
    String? subject,
    String? topic,
    String? notes,
    double? rating,
    HomeworkStatus? homeworkStatus,
    DateTime? createdAt,
  }) {
    return ProgressNoteEntity(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentNameBn: studentNameBn ?? this.studentNameBn,
      tutorId: tutorId ?? this.tutorId,
      date: date ?? this.date,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      homeworkStatus: homeworkStatus ?? this.homeworkStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

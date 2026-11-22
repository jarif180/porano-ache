import '../../domain/entities/progress_note_entity.dart';

class ProgressNoteModel extends ProgressNoteEntity {
  const ProgressNoteModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.studentNameBn,
    required super.tutorId,
    required super.date,
    required super.subject,
    required super.topic,
    required super.notes,
    required super.rating,
    required super.homeworkStatus,
    required super.createdAt,
  });

  factory ProgressNoteModel.fromEntity(ProgressNoteEntity entity) {
    return ProgressNoteModel(
      id: entity.id,
      studentId: entity.studentId,
      studentName: entity.studentName,
      studentNameBn: entity.studentNameBn,
      tutorId: entity.tutorId,
      date: entity.date,
      subject: entity.subject,
      topic: entity.topic,
      notes: entity.notes,
      rating: entity.rating,
      homeworkStatus: entity.homeworkStatus,
      createdAt: entity.createdAt,
    );
  }

  factory ProgressNoteModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProgressNoteModel(
      id: docId,
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      studentNameBn: map['studentNameBn'] as String? ?? '',
      tutorId: map['tutorId'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      subject: map['subject'] as String? ?? '',
      topic: map['topic'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      homeworkStatus: HomeworkStatus.values.firstWhere(
        (e) => e.name == map['homeworkStatus'],
        orElse: () => HomeworkStatus.completed,
      ),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentNameBn': studentNameBn,
      'tutorId': tutorId,
      'date': date.toIso8601String(),
      'subject': subject,
      'topic': topic,
      'notes': notes,
      'rating': rating,
      'homeworkStatus': homeworkStatus.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

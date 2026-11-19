import '../../domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    required super.tutorId,
    required super.fullName,
    required super.fullNameBn,
    required super.gradeLevel,
    required super.institution,
    required super.subjects,
    required super.parentName,
    required super.parentPhone,
    super.parentEmail = '',
    required super.monthlyFee,
    required super.inviteCode,
    super.isActive = true,
    super.notes = '',
    required super.createdAt,
  });

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      tutorId: entity.tutorId,
      fullName: entity.fullName,
      fullNameBn: entity.fullNameBn,
      gradeLevel: entity.gradeLevel,
      institution: entity.institution,
      subjects: entity.subjects,
      parentName: entity.parentName,
      parentPhone: entity.parentPhone,
      parentEmail: entity.parentEmail,
      monthlyFee: entity.monthlyFee,
      inviteCode: entity.inviteCode,
      isActive: entity.isActive,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  factory StudentModel.fromMap(Map<String, dynamic> map, String id) {
    return StudentModel(
      id: id,
      tutorId: map['tutorId'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      fullNameBn: map['fullNameBn'] as String? ?? '',
      gradeLevel: map['gradeLevel'] as String? ?? '',
      institution: map['institution'] as String? ?? '',
      subjects: (map['subjects'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      parentName: map['parentName'] as String? ?? '',
      parentPhone: map['parentPhone'] as String? ?? '',
      parentEmail: map['parentEmail'] as String? ?? '',
      monthlyFee: (map['monthlyFee'] as num?)?.toDouble() ?? 0.0,
      inviteCode: map['inviteCode'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? true,
      notes: map['notes'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tutorId': tutorId,
      'fullName': fullName,
      'fullNameBn': fullNameBn,
      'gradeLevel': gradeLevel,
      'institution': institution,
      'subjects': subjects,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'parentEmail': parentEmail,
      'monthlyFee': monthlyFee,
      'inviteCode': inviteCode,
      'isActive': isActive,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

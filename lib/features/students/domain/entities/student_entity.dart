class StudentEntity {
  final String id;
  final String tutorId;
  final String fullName;
  final String fullNameBn;
  final String gradeLevel;
  final String institution;
  final List<String> subjects;
  final String parentName;
  final String parentPhone;
  final String parentEmail;
  final double monthlyFee;
  final String inviteCode;
  final bool isActive;
  final String notes;
  final DateTime createdAt;

  const StudentEntity({
    required this.id,
    required this.tutorId,
    required this.fullName,
    required this.fullNameBn,
    required this.gradeLevel,
    required this.institution,
    required this.subjects,
    required this.parentName,
    required this.parentPhone,
    this.parentEmail = '',
    required this.monthlyFee,
    required this.inviteCode,
    this.isActive = true,
    this.notes = '',
    required this.createdAt,
  });

  StudentEntity copyWith({
    String? id,
    String? tutorId,
    String? fullName,
    String? fullNameBn,
    String? gradeLevel,
    String? institution,
    List<String>? subjects,
    String? parentName,
    String? parentPhone,
    String? parentEmail,
    double? monthlyFee,
    String? inviteCode,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      tutorId: tutorId ?? this.tutorId,
      fullName: fullName ?? this.fullName,
      fullNameBn: fullNameBn ?? this.fullNameBn,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      institution: institution ?? this.institution,
      subjects: subjects ?? this.subjects,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      parentEmail: parentEmail ?? this.parentEmail,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      inviteCode: inviteCode ?? this.inviteCode,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

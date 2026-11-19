enum UserRole {
  tutor,
  student,
  parent;

  String get displayNameEn {
    switch (this) {
      case UserRole.tutor:
        return 'Tutor';
      case UserRole.student:
        return 'Student';
      case UserRole.parent:
        return 'Parent';
    }
  }

  String get displayNameBn {
    switch (this) {
      case UserRole.tutor:
        return 'শিক্ষক / টিউটর';
      case UserRole.student:
        return 'শিক্ষার্থী';
      case UserRole.parent:
        return 'অভিভাবক';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'parent':
        return UserRole.parent;
      case 'tutor':
      default:
        return UserRole.tutor;
    }
  }
}

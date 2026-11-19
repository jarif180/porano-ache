import 'package:flutter_test/flutter_test.dart';
import 'package:porano_ache/features/students/data/repositories/student_repository_impl.dart';
import 'package:porano_ache/features/students/domain/entities/student_entity.dart';

void main() {
  group('StudentRepositoryImpl Tests', () {
    late StudentRepositoryImpl repository;

    setUp(() {
      repository = StudentRepositoryImpl();
    });

    test('getStudents returns initial students list', () async {
      final students = await repository.getStudents();
      expect(students.length, 3);
      expect(students.first.fullName, 'Tahmid Hasan');
      expect(students.first.fullNameBn, 'তাহমিদ হাসান');
    });

    test('addStudent adds a new student to repository', () async {
      final newStudent = StudentEntity(
        id: 'std_test',
        tutorId: 'tutor_001',
        fullName: 'Ayman Sadiq',
        fullNameBn: 'আয়মান সাদিক',
        gradeLevel: 'HSC',
        institution: 'Notre Dame College',
        subjects: ['English'],
        parentName: 'Mr. Sadiq',
        parentPhone: '01700000000',
        monthlyFee: 4000,
        inviteCode: 'PA9999',
        createdAt: DateTime.now(),
      );

      await repository.addStudent(newStudent);
      final students = await repository.getStudents();
      expect(students.length, 4);

      final fetched = await repository.getStudentById('std_test');
      expect(fetched, isNotNull);
      expect(fetched!.fullName, 'Ayman Sadiq');
    });

    test('updateStudent updates an existing student', () async {
      final existing = (await repository.getStudents()).first;
      final updated = existing.copyWith(monthlyFee: 5000);

      await repository.updateStudent(updated);
      final fetched = await repository.getStudentById(existing.id);
      expect(fetched!.monthlyFee, 5000);
    });

    test('toggleStudentStatus archives and unarchives a student', () async {
      final student = (await repository.getStudents()).first;
      expect(student.isActive, isTrue);

      await repository.toggleStudentStatus(student.id);
      final activeOnly = await repository.getStudents(includeInactive: false);
      expect(activeOnly.any((s) => s.id == student.id), isFalse);

      final all = await repository.getStudents(includeInactive: true);
      expect(all.firstWhere((s) => s.id == student.id).isActive, isFalse);
    });

    test('deleteStudent deletes student from repository', () async {
      await repository.deleteStudent('std_001');
      final fetched = await repository.getStudentById('std_001');
      expect(fetched, isNull);
    });

    test('generateInviteCode produces valid PAXXXX format', () {
      final code = repository.generateInviteCode();
      expect(code.startsWith('PA'), isTrue);
      expect(code.length, 6);
    });
  });
}

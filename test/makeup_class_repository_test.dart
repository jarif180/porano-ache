import 'package:flutter_test/flutter_test.dart';
import 'package:porano_ache/features/makeup_classes/data/repositories/makeup_class_repository_impl.dart';
import 'package:porano_ache/features/makeup_classes/domain/entities/makeup_class_entity.dart';

void main() {
  group('MakeupClassRepositoryImpl', () {
    late MakeupClassRepositoryImpl repository;

    setUp(() {
      repository = MakeupClassRepositoryImpl();
    });

    test('getMakeupClasses returns initial sample classes', () async {
      final classes = await repository.getMakeupClasses();
      expect(classes.length, greaterThanOrEqualTo(2));
    });

    test('getMakeupClassesForStudent filters properly', () async {
      final classes = await repository.getMakeupClassesForStudent('std_001');
      for (final c in classes) {
        expect(c.studentId, 'std_001');
      }
    });

    test('addMakeupClass adds a class successfully', () async {
      final newClass = MakeupClassEntity(
        id: 'makeup_test',
        studentId: 'std_002',
        studentName: 'Nusrat Jahan',
        studentNameBn: 'নুসরাত জাহান',
        tutorId: 'tutor_001',
        subject: 'পদার্থবিজ্ঞান',
        originalDate: DateTime.now().subtract(const Duration(days: 1)),
        makeupDate: DateTime.now().add(const Duration(days: 2)),
        startTime: '17:00',
        endTime: '18:30',
        reason: 'Holiday',
        status: MakeupClassStatus.scheduled,
        createdAt: DateTime.now(),
      );

      await repository.addMakeupClass(newClass);
      final classes = await repository.getMakeupClasses();
      expect(classes.any((c) => c.id == 'makeup_test'), true);
    });

    test('updateStatus updates status of a makeup class', () async {
      await repository.updateStatus('makeup_001', MakeupClassStatus.completed);
      final classes = await repository.getMakeupClasses();
      final updated = classes.firstWhere((c) => c.id == 'makeup_001');
      expect(updated.status, MakeupClassStatus.completed);
    });
  });
}

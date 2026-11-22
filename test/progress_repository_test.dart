import 'package:flutter_test/flutter_test.dart';
import 'package:porano_ache/features/progress/data/repositories/progress_repository_impl.dart';
import 'package:porano_ache/features/progress/domain/entities/progress_note_entity.dart';

void main() {
  group('ProgressRepositoryImpl', () {
    late ProgressRepositoryImpl repository;

    setUp(() {
      repository = ProgressRepositoryImpl();
    });

    test('getNotes returns initial sample notes', () async {
      final notes = await repository.getNotes();
      expect(notes.isNotEmpty, true);
      expect(notes.length, greaterThanOrEqualTo(4));
    });

    test('getNotesForStudent filters notes by studentId', () async {
      final notes = await repository.getNotesForStudent('std_001');
      expect(notes.isNotEmpty, true);
      for (final n in notes) {
        expect(n.studentId, 'std_001');
      }
    });

    test('addNote adds a new progress evaluation', () async {
      final newNote = ProgressNoteEntity(
        id: 'prog_test',
        studentId: 'std_002',
        studentName: 'Nusrat Jahan',
        studentNameBn: 'নুসরাত জাহান',
        tutorId: 'tutor_001',
        date: DateTime.now(),
        subject: 'পদার্থবিজ্ঞান',
        topic: 'আলোর প্রতিফলন',
        notes: 'Good understanding of mirrors',
        rating: 4.5,
        homeworkStatus: HomeworkStatus.completed,
        createdAt: DateTime.now(),
      );

      await repository.addNote(newNote);
      final notes = await repository.getNotes();
      expect(notes.any((n) => n.id == 'prog_test'), true);
    });

    test('deleteNote removes note', () async {
      await repository.deleteNote('prog_001');
      final notes = await repository.getNotes();
      expect(notes.any((n) => n.id == 'prog_001'), false);
    });
  });
}

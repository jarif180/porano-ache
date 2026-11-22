import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/progress_note_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../data/repositories/progress_repository_impl.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl();
});

class ProgressNotifier extends StateNotifier<AsyncValue<List<ProgressNoteEntity>>> {
  final ProgressRepository _repository;

  ProgressNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      state = const AsyncValue.loading();
      final notes = await _repository.getNotes();
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addNote({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required DateTime date,
    required String subject,
    required String topic,
    required String notes,
    required double rating,
    required HomeworkStatus homeworkStatus,
  }) async {
    try {
      final newNote = ProgressNoteEntity(
        id: 'prog_${DateTime.now().millisecondsSinceEpoch}',
        studentId: studentId,
        studentName: studentName,
        studentNameBn: studentNameBn,
        tutorId: 'tutor_001',
        date: date,
        subject: subject,
        topic: topic,
        notes: notes,
        rating: rating,
        homeworkStatus: homeworkStatus,
        createdAt: DateTime.now(),
      );
      await _repository.addNote(newNote);
      await loadNotes();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _repository.deleteNote(id);
      await loadNotes();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<ProgressNoteEntity>> getNotesForStudent(String studentId) async {
    return await _repository.getNotesForStudent(studentId);
  }
}

final progressNotifierProvider =
    StateNotifierProvider<ProgressNotifier, AsyncValue<List<ProgressNoteEntity>>>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return ProgressNotifier(repo);
});

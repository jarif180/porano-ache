import '../entities/progress_note_entity.dart';

abstract class ProgressRepository {
  Future<List<ProgressNoteEntity>> getNotes();
  Future<List<ProgressNoteEntity>> getNotesForStudent(String studentId);
  Future<void> addNote(ProgressNoteEntity note);
  Future<void> deleteNote(String id);
}

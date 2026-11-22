import '../../domain/entities/progress_note_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../models/progress_note_model.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final List<ProgressNoteModel> _notes = [
    ProgressNoteModel(
      id: 'prog_001',
      studentId: 'std_001',
      studentName: 'Tahmid Hasan',
      studentNameBn: 'তাহমিদ হাসান',
      tutorId: 'tutor_001',
      date: DateTime.now().subtract(const Duration(days: 2)),
      subject: 'উচ্চতর গণিত',
      topic: 'ত্রিকোণমিতি অধ্যায় ৮.২',
      notes: 'ত্রিকোণমিতিক অনুপাতের মান নির্ণয় ও সূত্র প্রয়োগে চমৎকার দক্ষতা প্রদর্শন করেছে। সব গাণিতিক সমস্যার সমাধান নির্ভুল ছিল।',
      rating: 5.0,
      homeworkStatus: HomeworkStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ProgressNoteModel(
      id: 'prog_002',
      studentId: 'std_001',
      studentName: 'Tahmid Hasan',
      studentNameBn: 'তাহমিদ হাসান',
      tutorId: 'tutor_001',
      date: DateTime.now().subtract(const Duration(days: 5)),
      subject: 'পদার্থবিজ্ঞান',
      topic: 'গতি ও বলের সমীকরণ',
      notes: 'গতির ৩য় সমীকরণের গাণিতিক বিশ্লেষণে কিছুটা দ্বিধায় ছিল, বিস্তারিতভাবে বুঝিয়ে দেওয়ার পর স্পষ্ট হয়েছে।',
      rating: 4.5,
      homeworkStatus: HomeworkStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ProgressNoteModel(
      id: 'prog_003',
      studentId: 'std_002',
      studentName: 'Nusrat Jahan',
      studentNameBn: 'নুসরাত জাহান',
      tutorId: 'tutor_001',
      date: DateTime.now().subtract(const Duration(days: 1)),
      subject: 'পদার্থবিজ্ঞান',
      topic: 'তাপগতিবিদ্যা প্রথম সূত্র',
      notes: 'রুদ্ধতাপীয় প্রক্রিয়ার গ্রাফ অঙ্কনে আরো মনোযোগ দেওয়া প্রয়োজন। পরবর্তী ক্লাসে রিভিশন নেওয়া হবে।',
      rating: 4.0,
      homeworkStatus: HomeworkStatus.incomplete,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ProgressNoteModel(
      id: 'prog_004',
      studentId: 'std_003',
      studentName: 'Rafi Alvi',
      studentNameBn: 'রাফি আলভী',
      tutorId: 'tutor_001',
      date: DateTime.now().subtract(const Duration(days: 4)),
      subject: 'রসায়ন',
      topic: 'পর্যায় সারণি ও ইলেকট্রন বিন্যাস',
      notes: 'পর্যায়বৃত্ত ধর্ম খুব দ্রুত মুখস্থ ও অনুধাবন করেছে। ক্লাস টেস্টে ১০ এ ৯ পেয়েছে।',
      rating: 4.8,
      homeworkStatus: HomeworkStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  @override
  Future<List<ProgressNoteEntity>> getNotes() async {
    return List.unmodifiable(_notes..sort((a, b) => b.date.compareTo(a.date)));
  }

  @override
  Future<List<ProgressNoteEntity>> getNotesForStudent(String studentId) async {
    return List.unmodifiable(
      _notes.where((n) => n.studentId == studentId).toList()
        ..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  @override
  Future<void> addNote(ProgressNoteEntity note) async {
    _notes.insert(0, ProgressNoteModel.fromEntity(note));
  }

  @override
  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
  }
}

import '../../domain/entities/makeup_class_entity.dart';
import '../../domain/repositories/makeup_class_repository.dart';
import '../models/makeup_class_model.dart';

class MakeupClassRepositoryImpl implements MakeupClassRepository {
  final List<MakeupClassModel> _classes = [
    MakeupClassModel(
      id: 'makeup_001',
      studentId: 'std_003',
      studentName: 'Rafi Alvi',
      studentNameBn: 'রাফি আলভী',
      tutorId: 'tutor_001',
      subject: 'রসায়ন',
      originalDate: DateTime.now().subtract(const Duration(days: 3)),
      makeupDate: DateTime.now().add(const Duration(days: 1)),
      startTime: '20:00',
      endTime: '21:00',
      reason: 'শিক্ষার্থীর স্কুলের বার্ষিক পরীক্ষার কারণে পূর্বনির্ধারিত ক্লাস পেছানো হয়েছিল',
      status: MakeupClassStatus.scheduled,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    MakeupClassModel(
      id: 'makeup_002',
      studentId: 'std_001',
      studentName: 'Tahmid Hasan',
      studentNameBn: 'তাহমিদ হাসান',
      tutorId: 'tutor_001',
      subject: 'উচ্চতর গণিত',
      originalDate: DateTime.now().subtract(const Duration(days: 7)),
      makeupDate: DateTime.now().subtract(const Duration(days: 4)),
      startTime: '18:00',
      endTime: '19:30',
      reason: 'শিক্ষকের অসুস্থতার জন্য বিকল্প ক্লাস নেওয়া হয়েছে',
      status: MakeupClassStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  @override
  Future<List<MakeupClassEntity>> getMakeupClasses() async {
    return List.unmodifiable(_classes..sort((a, b) => b.makeupDate.compareTo(a.makeupDate)));
  }

  @override
  Future<List<MakeupClassEntity>> getMakeupClassesForStudent(String studentId) async {
    return List.unmodifiable(
      _classes.where((c) => c.studentId == studentId).toList()
        ..sort((a, b) => b.makeupDate.compareTo(a.makeupDate)),
    );
  }

  @override
  Future<void> addMakeupClass(MakeupClassEntity makeupClass) async {
    _classes.insert(0, MakeupClassModel.fromEntity(makeupClass));
  }

  @override
  Future<void> updateStatus(String id, MakeupClassStatus status) async {
    final idx = _classes.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _classes[idx] = MakeupClassModel.fromEntity(
        _classes[idx].copyWith(status: status),
      );
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/makeup_class_entity.dart';
import '../../domain/repositories/makeup_class_repository.dart';
import '../../data/repositories/makeup_class_repository_impl.dart';

final makeupClassRepositoryProvider = Provider<MakeupClassRepository>((ref) {
  return MakeupClassRepositoryImpl();
});

class MakeupClassNotifier extends StateNotifier<AsyncValue<List<MakeupClassEntity>>> {
  final MakeupClassRepository _repository;

  MakeupClassNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadMakeupClasses();
  }

  Future<void> loadMakeupClasses() async {
    try {
      state = const AsyncValue.loading();
      final list = await _repository.getMakeupClasses();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMakeupClass({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required String subject,
    required DateTime originalDate,
    required DateTime makeupDate,
    required String startTime,
    required String endTime,
    required String reason,
  }) async {
    try {
      final newClass = MakeupClassEntity(
        id: 'makeup_${DateTime.now().millisecondsSinceEpoch}',
        studentId: studentId,
        studentName: studentName,
        studentNameBn: studentNameBn,
        tutorId: 'tutor_001',
        subject: subject,
        originalDate: originalDate,
        makeupDate: makeupDate,
        startTime: startTime,
        endTime: endTime,
        reason: reason,
        status: MakeupClassStatus.scheduled,
        createdAt: DateTime.now(),
      );
      await _repository.addMakeupClass(newClass);
      await loadMakeupClasses();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateStatus(String id, MakeupClassStatus status) async {
    try {
      await _repository.updateStatus(id, status);
      await loadMakeupClasses();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<MakeupClassEntity>> getClassesForStudent(String studentId) async {
    return await _repository.getMakeupClassesForStudent(studentId);
  }
}

final makeupClassNotifierProvider =
    StateNotifierProvider<MakeupClassNotifier, AsyncValue<List<MakeupClassEntity>>>((ref) {
  final repo = ref.watch(makeupClassRepositoryProvider);
  return MakeupClassNotifier(repo);
});

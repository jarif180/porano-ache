import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/repositories/student_repository.dart';
import '../../data/repositories/student_repository_impl.dart';

// Provider for the repository
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepositoryImpl();
});

// StateNotifier for managing the list of students
class StudentNotifier extends StateNotifier<AsyncValue<List<StudentEntity>>> {
  final StudentRepository _repository;

  StudentNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadStudents();
  }

  Future<void> loadStudents({bool includeInactive = true}) async {
    try {
      state = const AsyncValue.loading();
      final students = await _repository.getStudents(includeInactive: includeInactive);
      state = AsyncValue.data(students);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addStudent(StudentEntity student) async {
    try {
      await _repository.addStudent(student);
      await loadStudents();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateStudent(StudentEntity student) async {
    try {
      await _repository.updateStudent(student);
      await loadStudents();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _repository.deleteStudent(id);
      await loadStudents();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleStudentStatus(String id) async {
    try {
      await _repository.toggleStudentStatus(id);
      await loadStudents();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  String getNewInviteCode() {
    return _repository.generateInviteCode();
  }
}

final studentListNotifierProvider =
    StateNotifierProvider<StudentNotifier, AsyncValue<List<StudentEntity>>>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return StudentNotifier(repository);
});

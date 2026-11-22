import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/attendance_status.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../data/repositories/attendance_repository_impl.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepositoryImpl();
});

class AttendanceNotifier extends StateNotifier<AsyncValue<List<AttendanceEntity>>> {
  final AttendanceRepository _repository;
  DateTime _selectedDate = DateTime.now();

  AttendanceNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadAttendanceForDate(_selectedDate);
  }

  DateTime get selectedDate => _selectedDate;

  Future<void> loadAttendanceForDate(DateTime date) async {
    try {
      _selectedDate = date;
      state = const AsyncValue.loading();
      final records = await _repository.getAttendanceForDate(date);
      state = AsyncValue.data(records);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> mark({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required String scheduleId,
    required DateTime date,
    required AttendanceStatus status,
    String notes = '',
  }) async {
    try {
      await _repository.markAttendance(
        studentId: studentId,
        studentName: studentName,
        studentNameBn: studentNameBn,
        scheduleId: scheduleId,
        date: date,
        status: status,
        notes: notes,
      );
      await loadAttendanceForDate(_selectedDate);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<AttendanceSummary> getSummaryForStudent(String studentId) async {
    return await _repository.getStudentSummary(studentId);
  }

  Future<List<AttendanceEntity>> getHistoryForStudent(String studentId) async {
    return await _repository.getAttendanceForStudent(studentId);
  }
}

final attendanceNotifierProvider =
    StateNotifierProvider<AttendanceNotifier, AsyncValue<List<AttendanceEntity>>>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return AttendanceNotifier(repository);
});

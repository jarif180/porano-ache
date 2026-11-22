import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../data/repositories/schedule_repository_impl.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepositoryImpl();
});

class ScheduleNotifier extends StateNotifier<AsyncValue<List<ScheduleEntity>>> {
  final ScheduleRepository _repository;

  ScheduleNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    try {
      state = const AsyncValue.loading();
      final schedules = await _repository.getSchedules();
      state = AsyncValue.data(schedules);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<ScheduleEntity?> checkConflict({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    String? excludeScheduleId,
  }) async {
    return await _repository.checkConflict(
      dayOfWeek: dayOfWeek,
      startTime: startTime,
      endTime: endTime,
      excludeScheduleId: excludeScheduleId,
    );
  }

  Future<void> addSchedule(ScheduleEntity schedule) async {
    try {
      await _repository.addSchedule(schedule);
      await loadSchedules();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateSchedule(ScheduleEntity schedule) async {
    try {
      await _repository.updateSchedule(schedule);
      await loadSchedules();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteSchedule(String id) async {
    try {
      await _repository.deleteSchedule(id);
      await loadSchedules();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final scheduleNotifierProvider =
    StateNotifierProvider<ScheduleNotifier, AsyncValue<List<ScheduleEntity>>>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return ScheduleNotifier(repository);
});

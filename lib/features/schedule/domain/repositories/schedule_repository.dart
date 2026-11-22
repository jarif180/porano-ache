import '../entities/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> getSchedules({bool activeOnly = true});
  Future<List<ScheduleEntity>> getSchedulesForDay(int dayOfWeek);
  Future<List<ScheduleEntity>> getSchedulesForStudent(String studentId);
  Future<void> addSchedule(ScheduleEntity schedule);
  Future<void> updateSchedule(ScheduleEntity schedule);
  Future<void> deleteSchedule(String id);
  Future<ScheduleEntity?> checkConflict({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    String? excludeScheduleId,
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:porano_ache/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:porano_ache/features/schedule/domain/entities/schedule_entity.dart';

void main() {
  group('ScheduleRepositoryImpl Tests', () {
    late ScheduleRepositoryImpl repository;

    setUp(() {
      repository = ScheduleRepositoryImpl();
    });

    test('getSchedules returns initial schedules', () async {
      final list = await repository.getSchedules();
      expect(list.isNotEmpty, isTrue);
      expect(list.any((s) => s.studentName == 'Tahmid Hasan'), isTrue);
    });

    test('getSchedulesForDay filters correctly by weekday', () async {
      final saturdayClasses = await repository.getSchedulesForDay(DateTime.saturday);
      expect(saturdayClasses.every((s) => s.dayOfWeek == DateTime.saturday), isTrue);
      expect(saturdayClasses.length, 2);
    });

    test('getSchedulesForStudent filters by studentId', () async {
      final tahmidClasses = await repository.getSchedulesForStudent('std_001');
      expect(tahmidClasses.every((s) => s.studentId == 'std_001'), isTrue);
      expect(tahmidClasses.length, 3);
    });

    test('checkConflict detects overlapping time slots on same day', () async {
      // There is an existing class on Saturday 16:00 - 17:00
      final conflict = await repository.checkConflict(
        dayOfWeek: DateTime.saturday,
        startTime: '16:30',
        endTime: '17:30',
      );
      expect(conflict, isNotNull);
      expect(conflict!.studentName, 'Tahmid Hasan');
    });

    test('checkConflict returns null for non-overlapping times', () async {
      final noConflict = await repository.checkConflict(
        dayOfWeek: DateTime.saturday,
        startTime: '12:00',
        endTime: '13:00',
      );
      expect(noConflict, isNull);
    });

    test('addSchedule adds a new class slot', () async {
      final newSlot = ScheduleEntity(
        id: 'sch_test',
        tutorId: 'tutor_001',
        studentId: 'std_003',
        studentName: 'Rafi Alvi',
        studentNameBn: 'রাফি আলভী',
        subject: 'Math',
        dayOfWeek: DateTime.tuesday,
        startTime: '18:00',
        endTime: '19:00',
        createdAt: DateTime.now(),
      );

      await repository.addSchedule(newSlot);
      final tuesdayClasses = await repository.getSchedulesForDay(DateTime.tuesday);
      expect(tuesdayClasses.length, 1);
      expect(tuesdayClasses.first.id, 'sch_test');
    });

    test('deleteSchedule removes class slot', () async {
      await repository.deleteSchedule('sch_001');
      final saturday = await repository.getSchedulesForDay(DateTime.saturday);
      expect(saturday.any((s) => s.id == 'sch_001'), isFalse);
    });
  });
}

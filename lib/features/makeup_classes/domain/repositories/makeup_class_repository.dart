import '../entities/makeup_class_entity.dart';

abstract class MakeupClassRepository {
  Future<List<MakeupClassEntity>> getMakeupClasses();
  Future<List<MakeupClassEntity>> getMakeupClassesForStudent(String studentId);
  Future<void> addMakeupClass(MakeupClassEntity makeupClass);
  Future<void> updateStatus(String id, MakeupClassStatus status);
}

import 'dart:math';
import '../../domain/entities/student_entity.dart';
import '../../domain/repositories/student_repository.dart';
import '../models/student_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  // In-memory student cache populated with initial mock students
  final List<StudentModel> _students = [
    StudentModel(
      id: 'std_001',
      tutorId: 'tutor_001',
      fullName: 'Tahmid Hasan',
      fullNameBn: 'তাহমিদ হাসান',
      gradeLevel: 'Class 10',
      institution: 'Viqarunnisa Noon School / Govt. Lab',
      subjects: ['Higher Math', 'General Math'],
      parentName: 'Hasanuzzaman',
      parentPhone: '01712345678',
      parentEmail: 'hasanuzzaman@example.com',
      monthlyFee: 3000.0,
      inviteCode: 'PA9281',
      isActive: true,
      notes: 'Strong in algebra, needs practice in trigonometry.',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    StudentModel(
      id: 'std_002',
      tutorId: 'tutor_001',
      fullName: 'Nusrat Jahan',
      fullNameBn: 'নুসরাত জাহান',
      gradeLevel: 'HSC (11th)',
      institution: 'Dhaka City College',
      subjects: ['Physics', 'Chemistry'],
      parentName: 'Rehana Akter',
      parentPhone: '01898765432',
      parentEmail: 'rehana.akter@example.com',
      monthlyFee: 3500.0,
      inviteCode: 'PA4820',
      isActive: true,
      notes: 'Good conceptual understanding of Mechanics.',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    StudentModel(
      id: 'std_003',
      tutorId: 'tutor_001',
      fullName: 'Rafi Alvi',
      fullNameBn: 'রাফি আলভী',
      gradeLevel: 'Class 9',
      institution: 'St. Joseph Higher Secondary School',
      subjects: ['General Science', 'General Math'],
      parentName: 'Mohammad Alvi',
      parentPhone: '01911223344',
      parentEmail: 'm.alvi@example.com',
      monthlyFee: 2500.0,
      inviteCode: 'PA7154',
      isActive: true,
      notes: 'Regular in classes, needs regular homework review.',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  @override
  Future<List<StudentEntity>> getStudents({bool includeInactive = false}) async {
    if (includeInactive) {
      return List.unmodifiable(_students);
    }
    return List.unmodifiable(_students.where((s) => s.isActive));
  }

  @override
  Future<StudentEntity?> getStudentById(String id) async {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addStudent(StudentEntity student) async {
    final model = StudentModel.fromEntity(student);
    _students.add(model);
  }

  @override
  Future<void> updateStudent(StudentEntity student) async {
    final index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _students[index] = StudentModel.fromEntity(student);
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    _students.removeWhere((s) => s.id == id);
  }

  @override
  Future<void> toggleStudentStatus(String id) async {
    final index = _students.indexWhere((s) => s.id == id);
    if (index != -1) {
      final current = _students[index];
      _students[index] = StudentModel.fromEntity(
        current.copyWith(isActive: !current.isActive),
      );
    }
  }

  @override
  String generateInviteCode() {
    final random = Random();
    final digits = 1000 + random.nextInt(9000); // 4-digit number
    return 'PA$digits';
  }
}

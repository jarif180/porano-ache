import '../../../../core/enums/payment_status.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final List<PaymentModel> _payments = [
    // Current Month (November 2026) Dues
    PaymentModel(
      id: 'pay_001',
      studentId: 'std_001',
      studentName: 'Tahmid Hasan',
      studentNameBn: 'তাহমিদ হাসান',
      tutorId: 'tutor_001',
      amount: 3000.0,
      dueDate: DateTime(2026, 11, 25),
      status: PaymentStatus.unpaid,
      method: PaymentMethod.cash,
      month: 'নভেম্বর ২০২৬',
      notes: 'Monthly tuition fee',
      createdAt: DateTime(2026, 11, 1),
    ),
    PaymentModel(
      id: 'pay_002',
      studentId: 'std_002',
      studentName: 'Nusrat Jahan',
      studentNameBn: 'নুসরাত জাহান',
      tutorId: 'tutor_001',
      amount: 3500.0,
      dueDate: DateTime(2026, 11, 15),
      status: PaymentStatus.overdue,
      method: PaymentMethod.bkash,
      month: 'নভেম্বর ২০২৬',
      notes: 'Fee due date passed',
      createdAt: DateTime(2026, 11, 1),
    ),
    // Previous Months (Paid)
    PaymentModel(
      id: 'pay_003',
      studentId: 'std_001',
      studentName: 'Tahmid Hasan',
      studentNameBn: 'তাহমিদ হাসান',
      tutorId: 'tutor_001',
      amount: 3000.0,
      dueDate: DateTime(2026, 10, 25),
      paidDate: DateTime(2026, 10, 24),
      status: PaymentStatus.paid,
      method: PaymentMethod.cash,
      month: 'অক্টোবর ২০২৬',
      notes: 'Paid cash in hand by guardian',
      createdAt: DateTime(2026, 10, 1),
    ),
    PaymentModel(
      id: 'pay_004',
      studentId: 'std_002',
      studentName: 'Nusrat Jahan',
      studentNameBn: 'নুসরাত জাহান',
      tutorId: 'tutor_001',
      amount: 3500.0,
      dueDate: DateTime(2026, 10, 15),
      paidDate: DateTime(2026, 10, 14),
      status: PaymentStatus.paid,
      method: PaymentMethod.bkash,
      gatewayTxnId: 'BKS_9847291',
      month: 'অক্টোবর ২০২৬',
      notes: 'Paid via bKash online gateway',
      createdAt: DateTime(2026, 10, 1),
    ),
    PaymentModel(
      id: 'pay_005',
      studentId: 'std_003',
      studentName: 'Rafi Alvi',
      studentNameBn: 'রাফি আলভী',
      tutorId: 'tutor_001',
      amount: 2500.0,
      dueDate: DateTime(2026, 11, 10),
      paidDate: DateTime(2026, 11, 9),
      status: PaymentStatus.paid,
      method: PaymentMethod.nagad,
      gatewayTxnId: 'NGD_2847192',
      month: 'নভেম্বর ২০২৬',
      notes: 'Paid via Nagad online gateway',
      createdAt: DateTime(2026, 11, 1),
    ),
  ];

  @override
  Future<List<PaymentEntity>> getPayments() async {
    return List.unmodifiable(_payments..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  @override
  Future<List<PaymentEntity>> getPaymentsForStudent(String studentId) async {
    return List.unmodifiable(
      _payments.where((p) => p.studentId == studentId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  @override
  Future<void> recordPayment({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required double amount,
    required PaymentMethod method,
    required DateTime paidDate,
    required String month,
    String gatewayTxnId = '',
    String notes = '',
  }) async {
    // Check if an unpaid invoice already exists for this student and month
    final existingIdx = _payments.indexWhere(
      (p) => p.studentId == studentId && p.month == month && p.status != PaymentStatus.paid,
    );

    if (existingIdx != -1) {
      _payments[existingIdx] = PaymentModel.fromEntity(
        _payments[existingIdx].copyWith(
          paidDate: paidDate,
          status: PaymentStatus.paid,
          method: method,
          gatewayTxnId: gatewayTxnId,
          notes: notes.isNotEmpty ? notes : _payments[existingIdx].notes,
        ),
      );
    } else {
      _payments.insert(
        0,
        PaymentModel(
          id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
          studentId: studentId,
          studentName: studentName,
          studentNameBn: studentNameBn,
          tutorId: 'tutor_001',
          amount: amount,
          dueDate: paidDate,
          paidDate: paidDate,
          status: PaymentStatus.paid,
          method: method,
          gatewayTxnId: gatewayTxnId,
          month: month,
          notes: notes,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> createInvoice({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required double amount,
    required DateTime dueDate,
    required String month,
  }) async {
    _payments.insert(
      0,
      PaymentModel(
        id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
        studentId: studentId,
        studentName: studentName,
        studentNameBn: studentNameBn,
        tutorId: 'tutor_001',
        amount: amount,
        dueDate: dueDate,
        status: DateTime.now().isAfter(dueDate) ? PaymentStatus.overdue : PaymentStatus.unpaid,
        month: month,
        createdAt: DateTime.now(),
      ),
    );
  }
}

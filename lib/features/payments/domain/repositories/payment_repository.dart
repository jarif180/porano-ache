import '../../../../core/enums/payment_status.dart';
import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<List<PaymentEntity>> getPayments();
  Future<List<PaymentEntity>> getPaymentsForStudent(String studentId);
  Future<void> recordPayment({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required double amount,
    required PaymentMethod method,
    required DateTime paidDate,
    required String month,
    String gatewayTxnId,
    String notes,
  });
  Future<void> createInvoice({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required double amount,
    required DateTime dueDate,
    required String month,
  });
}

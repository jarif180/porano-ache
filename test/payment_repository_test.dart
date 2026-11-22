import 'package:flutter_test/flutter_test.dart';
import 'package:porano_ache/core/enums/payment_status.dart';
import 'package:porano_ache/features/payments/data/repositories/payment_repository_impl.dart';

void main() {
  group('PaymentRepositoryImpl', () {
    late PaymentRepositoryImpl repository;

    setUp(() {
      repository = PaymentRepositoryImpl();
    });

    test('getPayments returns initial seed payments', () async {
      final payments = await repository.getPayments();
      expect(payments.isNotEmpty, true);
      expect(payments.length, greaterThanOrEqualTo(5));
    });

    test('getPaymentsForStudent returns payments for specific student', () async {
      final payments = await repository.getPaymentsForStudent('std_001');
      expect(payments.isNotEmpty, true);
      for (final p in payments) {
        expect(p.studentId, 'std_001');
      }
    });

    test('recordPayment updates existing unpaid invoice', () async {
      await repository.recordPayment(
        studentId: 'std_001',
        studentName: 'Tahmid Hasan',
        studentNameBn: 'তাহমিদ হাসান',
        amount: 3000.0,
        method: PaymentMethod.bkash,
        paidDate: DateTime.now(),
        month: 'নভেম্বর ২০২৬',
        gatewayTxnId: 'BKS_TEST_123',
        notes: 'Paid via bKash',
      );

      final payments = await repository.getPaymentsForStudent('std_001');
      final updated = payments.firstWhere((p) => p.month == 'নভেম্বর ২০২৬');
      expect(updated.status, PaymentStatus.paid);
      expect(updated.method, PaymentMethod.bkash);
      expect(updated.gatewayTxnId, 'BKS_TEST_123');
    });

    test('createInvoice creates new pending payment', () async {
      await repository.createInvoice(
        studentId: 'std_001',
        studentName: 'Tahmid Hasan',
        studentNameBn: 'তাহমিদ হাসান',
        amount: 3000.0,
        dueDate: DateTime(2026, 12, 25),
        month: 'ডিসেম্বর ২০২৬',
      );

      final payments = await repository.getPaymentsForStudent('std_001');
      final invoice = payments.firstWhere((p) => p.month == 'ডিসেম্বর ২০২৬');
      expect(invoice.amount, 3000.0);
      expect(invoice.status, PaymentStatus.unpaid);
    });
  });
}

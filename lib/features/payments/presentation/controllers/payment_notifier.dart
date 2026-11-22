import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/payment_status.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../data/repositories/payment_repository_impl.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl();
});

class PaymentNotifier extends StateNotifier<AsyncValue<List<PaymentEntity>>> {
  final PaymentRepository _repository;

  PaymentNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      state = const AsyncValue.loading();
      final payments = await _repository.getPayments();
      state = AsyncValue.data(payments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

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
    try {
      await _repository.recordPayment(
        studentId: studentId,
        studentName: studentName,
        studentNameBn: studentNameBn,
        amount: amount,
        method: method,
        paidDate: paidDate,
        month: month,
        gatewayTxnId: gatewayTxnId,
        notes: notes,
      );
      await loadPayments();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createInvoice({
    required String studentId,
    required String studentName,
    required String studentNameBn,
    required double amount,
    required DateTime dueDate,
    required String month,
  }) async {
    try {
      await _repository.createInvoice(
        studentId: studentId,
        studentName: studentName,
        studentNameBn: studentNameBn,
        amount: amount,
        dueDate: dueDate,
        month: month,
      );
      await loadPayments();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<PaymentEntity>> getHistoryForStudent(String studentId) async {
    return await _repository.getPaymentsForStudent(studentId);
  }
}

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, AsyncValue<List<PaymentEntity>>>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return PaymentNotifier(repository);
});

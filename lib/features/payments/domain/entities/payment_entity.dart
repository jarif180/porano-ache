import '../../../../core/enums/payment_status.dart';

class PaymentEntity {
  final String id;
  final String studentId;
  final String studentName;
  final String studentNameBn;
  final String tutorId;
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final PaymentStatus status;
  final PaymentMethod method;
  final String gatewayTxnId;
  final String month;
  final String notes;
  final DateTime createdAt;

  const PaymentEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentNameBn,
    required this.tutorId,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.method = PaymentMethod.cash,
    this.gatewayTxnId = '',
    required this.month,
    this.notes = '',
    required this.createdAt,
  });

  PaymentEntity copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? studentNameBn,
    String? tutorId,
    double? amount,
    DateTime? dueDate,
    DateTime? paidDate,
    PaymentStatus? status,
    PaymentMethod? method,
    String? gatewayTxnId,
    String? month,
    String? notes,
    DateTime? createdAt,
  }) {
    return PaymentEntity(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentNameBn: studentNameBn ?? this.studentNameBn,
      tutorId: tutorId ?? this.tutorId,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      status: status ?? this.status,
      method: method ?? this.method,
      gatewayTxnId: gatewayTxnId ?? this.gatewayTxnId,
      month: month ?? this.month,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

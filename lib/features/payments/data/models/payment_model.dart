import '../../../../core/enums/payment_status.dart';
import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.studentNameBn,
    required super.tutorId,
    required super.amount,
    required super.dueDate,
    super.paidDate,
    required super.status,
    super.method = PaymentMethod.cash,
    super.gatewayTxnId = '',
    required super.month,
    super.notes = '',
    required super.createdAt,
  });

  factory PaymentModel.fromEntity(PaymentEntity entity) {
    return PaymentModel(
      id: entity.id,
      studentId: entity.studentId,
      studentName: entity.studentName,
      studentNameBn: entity.studentNameBn,
      tutorId: entity.tutorId,
      amount: entity.amount,
      dueDate: entity.dueDate,
      paidDate: entity.paidDate,
      status: entity.status,
      method: entity.method,
      gatewayTxnId: entity.gatewayTxnId,
      month: entity.month,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map, String id) {
    return PaymentModel(
      id: id,
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      studentNameBn: map['studentNameBn'] as String? ?? '',
      tutorId: map['tutorId'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      paidDate: map['paidDate'] != null ? DateTime.tryParse(map['paidDate'].toString()) : null,
      status: PaymentStatus.values.firstWhere(
        (st) => st.name == map['status'],
        orElse: () => PaymentStatus.unpaid,
      ),
      method: PaymentMethod.values.firstWhere(
        (m) => m.name == map['method'],
        orElse: () => PaymentMethod.cash,
      ),
      gatewayTxnId: map['gatewayTxnId'] as String? ?? '',
      month: map['month'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentNameBn': studentNameBn,
      'tutorId': tutorId,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'status': status.name,
      'method': method.name,
      'gatewayTxnId': gatewayTxnId,
      'month': month,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

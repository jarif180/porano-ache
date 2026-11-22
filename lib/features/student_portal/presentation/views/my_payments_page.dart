import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/payment_status.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../payments/presentation/controllers/payment_notifier.dart';

class MyPaymentsPage extends ConsumerStatefulWidget {
  final String studentId;

  const MyPaymentsPage({super.key, this.studentId = 'std_001'});

  @override
  ConsumerState<MyPaymentsPage> createState() => _MyPaymentsPageState();
}

class _MyPaymentsPageState extends ConsumerState<MyPaymentsPage> {
  List<PaymentEntity> _payments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    final payments = await ref
        .read(paymentNotifierProvider.notifier)
        .getHistoryForStudent(widget.studentId);
    if (mounted) {
      setState(() {
        _payments = payments;
        _isLoading = false;
      });
    }
  }

  void _showPaymentModal(BuildContext context, PaymentEntity pendingPayment, bool isBn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isBn ? 'পেমেন্ট গেটওয়ে নির্বাচন করুন' : 'Select Payment Gateway',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                isBn
                    ? 'মাসের বেতন: ${BanglaUtils.toBanglaTaka(pendingPayment.amount)} (${pendingPayment.month})'
                    : 'Monthly Fee: ৳${pendingPayment.amount.toStringAsFixed(0)} (${pendingPayment.month})',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // bKash Gateway
              _buildGatewayOption(
                title: 'bKash (বিকাশ)',
                subtitle: isBn ? 'অনলাইন ইনস্ট্যান্ট পেমেন্ট' : 'Instant Online Payment',
                badgeText: 'bKash',
                badgeColor: const Color(0xFFE2136E),
                onTap: () {
                  Navigator.pop(ctx);
                  _processOnlinePayment(pendingPayment, PaymentMethod.bkash, 'bKash', isBn);
                },
              ),
              const SizedBox(height: 10),

              // Nagad Gateway
              _buildGatewayOption(
                title: 'Nagad (নগদ)',
                subtitle: isBn ? 'ডাক বিভাগ ডিজিটাল লেনদেন' : 'Digital Financial Service',
                badgeText: 'নগদ',
                badgeColor: const Color(0xFFF7941D),
                onTap: () {
                  Navigator.pop(ctx);
                  _processOnlinePayment(pendingPayment, PaymentMethod.nagad, 'Nagad', isBn);
                },
              ),
              const SizedBox(height: 10),

              // Rocket Gateway
              _buildGatewayOption(
                title: 'Rocket (রকেট)',
                subtitle: isBn ? 'ডাচ-বাংলা মোবাইল ব্যাংকিং' : 'DBBL Mobile Banking',
                badgeText: 'রকেট',
                badgeColor: const Color(0xFF8C3494),
                onTap: () {
                  Navigator.pop(ctx);
                  _processOnlinePayment(pendingPayment, PaymentMethod.rocket, 'Rocket', isBn);
                },
              ),
              const SizedBox(height: 10),

              // Cash in Hand
              _buildGatewayOption(
                title: isBn ? 'সরাসরি নগদ (Cash in Hand)' : 'Cash in Hand',
                subtitle: isBn ? 'শিক্ষককে সরাসরি পরিশোধ নিশ্চিত করুন' : 'Confirm direct cash payment',
                badgeText: 'নগদ',
                badgeColor: AppColors.present,
                onTap: () {
                  Navigator.pop(ctx);
                  _processCashPayment(pendingPayment, isBn);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _processOnlinePayment(
    PaymentEntity payment,
    PaymentMethod method,
    String gatewayName,
    bool isBn,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.lock, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Text(isBn ? 'SSLCommerz সিকিউর পে' : 'SSLCommerz Secure Pay'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                isBn
                    ? '$gatewayName গেটওয়ের মাধ্যমে পেমেন্ট সম্পন্ন হচ্ছে...'
                    : 'Processing payment via $gatewayName gateway...',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                isBn
                    ? 'পরিমাণ: ${BanglaUtils.toBanglaTaka(payment.amount)}'
                    : 'Amount: ৳${payment.amount.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading

      final txnId = '${method.name.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      await ref.read(paymentNotifierProvider.notifier).recordPayment(
            studentId: payment.studentId,
            studentName: payment.studentName,
            studentNameBn: payment.studentNameBn,
            amount: payment.amount,
            method: method,
            paidDate: DateTime.now(),
            month: payment.month,
            gatewayTxnId: txnId,
            notes: 'Paid online via $gatewayName (SSLCommerz)',
          );

      await _fetchPayments();

      if (!mounted) return;
      _showSuccessReceipt(payment.amount, payment.month, method, txnId, isBn);
    });
  }

  void _processCashPayment(PaymentEntity payment, bool isBn) async {
    await ref.read(paymentNotifierProvider.notifier).recordPayment(
          studentId: payment.studentId,
          studentName: payment.studentName,
          studentNameBn: payment.studentNameBn,
          amount: payment.amount,
          method: PaymentMethod.cash,
          paidDate: DateTime.now(),
          month: payment.month,
          notes: 'Paid cash directly',
        );

    await _fetchPayments();

    if (!mounted) return;
    _showSuccessReceipt(payment.amount, payment.month, PaymentMethod.cash, 'CASH_REC', isBn);
  }

  void _showSuccessReceipt(
    double amount,
    String month,
    PaymentMethod method,
    String txnId,
    bool isBn,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.present.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: AppColors.present, size: 54),
              ),
              const SizedBox(height: 16),
              Text(
                isBn ? 'পেমেন্ট সফল হয়েছে!' : 'Payment Successful!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                isBn
                    ? 'আপনার $month মাসের বেতন সফলভাবে পরিশোধ করা হয়েছে।'
                    : 'Your fee for $month has been paid successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isBn ? 'পরিমাণ:' : 'Amount:', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Text(
                          isBn ? BanglaUtils.toBanglaTaka(amount) : '৳${amount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isBn ? 'মাধ্যম:' : 'Method:', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Text(method.displayName(isBn), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isBn ? 'ট্রানজ্যাকশন আইডি:' : 'Txn ID:', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Text(txnId, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isBn ? 'ঠিক আছে' : 'OK'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGatewayOption({
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            badgeText,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textMuted),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'আমার বেতন ও পেমেন্ট' : 'My Tuition Fees & Payments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student-dashboard'),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Banner
                    _buildSummaryBanner(isBn),
                    const SizedBox(height: 24),

                    // Pending Invoices Section
                    Text(
                      isBn ? 'বকেয়া বেতন' : 'Pending Fees',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _buildPendingSection(isBn),
                    const SizedBox(height: 24),

                    // Past Payment History Section
                    Text(
                      isBn ? 'পরিশোধের ইতিহাস' : 'Payment History',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _buildHistorySection(isBn),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryBanner(bool isBn) {
    final pendingList = _payments.where((p) => p.status != PaymentStatus.paid).toList();
    final totalDue = pendingList.fold<double>(0, (sum, p) => sum + p.amount);

    final paidList = _payments.where((p) => p.status == PaymentStatus.paid).toList();
    final totalPaid = paidList.fold<double>(0, (sum, p) => sum + p.amount);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: totalDue > 0
              ? [const Color(0xFFE2136E), const Color(0xFFB50D54)]
              : [AppColors.present, AppColors.present.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (totalDue > 0 ? const Color(0xFFE2136E) : AppColors.present).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isBn ? 'বর্তমান বকেয়া' : 'Current Due',
                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  totalDue > 0 ? (isBn ? 'বকেয়া আছে' : 'Due') : (isBn ? 'কোন বকেয়া নেই' : 'Clear'),
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isBn ? BanglaUtils.toBanglaTaka(totalDue) : '৳${totalDue.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBn ? 'মোট পরিশোধিত' : 'Total Paid',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isBn ? BanglaUtils.toBanglaTaka(totalPaid) : '৳${totalPaid.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isBn ? 'টিউটর' : 'Tutor',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isBn ? 'জারিফ স্যার' : 'Zarif Sir',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingSection(bool isBn) {
    final pending = _payments.where((p) => p.status != PaymentStatus.paid).toList();
    if (pending.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.present.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.present.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.present, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                isBn ? 'সব বেতন পরিশোধিত! আপনার কোন বকেয়া ফি নেই।' : 'All fees cleared! No pending dues.',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.present),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: pending.map((payment) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.absent.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.month,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isBn
                            ? 'শেষ তারিখ: ${BanglaUtils.toBanglaDate(payment.dueDate)}'
                            : 'Due Date: ${payment.dueDate.day}/${payment.dueDate.month}/${payment.dueDate.year}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  Text(
                    isBn ? BanglaUtils.toBanglaTaka(payment.amount) : '৳${payment.amount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.absent),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showPaymentModal(context, payment, isBn),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2136E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.payment, size: 18),
                  label: Text(
                    isBn ? 'এখনই পরিশোধ করুন (bKash / Nagad / Cash)' : 'Pay Now (bKash / Nagad / Cash)',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistorySection(bool isBn) {
    final paid = _payments.where((p) => p.status == PaymentStatus.paid).toList();
    if (paid.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            isBn ? 'কোন অতীত পেমেন্ট রেকর্ড নেই' : 'No past payment history',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: paid.map((payment) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.present.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check_circle_outline, color: AppColors.present, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.month,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          payment.method.displayName(isBn),
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                        if (payment.gatewayTxnId.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text('• ${payment.gatewayTxnId}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ],
                    ),
                    if (payment.paidDate != null)
                      Text(
                        isBn
                            ? 'পরিশোধ: ${BanglaUtils.toBanglaDate(payment.paidDate!)}'
                            : 'Paid: ${payment.paidDate!.day}/${payment.paidDate!.month}/${payment.paidDate!.year}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                  ],
                ),
              ),
              Text(
                isBn ? BanglaUtils.toBanglaTaka(payment.amount) : '৳${payment.amount.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.present),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

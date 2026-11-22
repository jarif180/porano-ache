import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/payment_status.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../domain/entities/payment_entity.dart';
import '../controllers/payment_notifier.dart';

class PaymentListPage extends ConsumerStatefulWidget {
  const PaymentListPage({super.key});

  @override
  ConsumerState<PaymentListPage> createState() => _PaymentListPageState();
}

class _PaymentListPageState extends ConsumerState<PaymentListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final paymentState = ref.watch(paymentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'পেমেন্ট ও বেতন ব্যবস্থাপনা' : 'Tuition Fees & Payments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/tutor-dashboard'),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: isBn ? 'বকেয়া তালিকা' : 'Pending Fees'),
            Tab(text: isBn ? 'পরিশোধিত ইতিহাস' : 'Payment History'),
          ],
        ),
      ),
      body: SafeArea(
        child: paymentState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (allPayments) {
            final pendingPayments = allPayments
                .where((p) => p.status != PaymentStatus.paid)
                .toList();
            final paidPayments = allPayments
                .where((p) => p.status == PaymentStatus.paid)
                .toList();

            final totalCollected = paidPayments.fold<double>(0.0, (acc, p) => acc + p.amount);
            final totalDue = pendingPayments.fold<double>(0.0, (acc, p) => acc + p.amount);

            return Column(
              children: [
                // Top Summary Row
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isBn ? 'মোট আদায়' : 'Total Collected',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isBn ? BanglaUtils.toBanglaTaka(totalCollected) : '৳${totalCollected.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.success),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isBn ? 'মোট বকেয়া' : 'Total Due',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isBn ? BanglaUtils.toBanglaTaka(totalDue) : '৳${totalDue.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPaymentList(pendingPayments, isBn, isPending: true),
                      _buildPaymentList(paidPayments, isBn, isPending: false),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/payments/record'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_card),
        label: Text(
          isBn ? 'পেমেন্ট রেকর্ড করুন' : 'Record Payment',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPaymentList(List<PaymentEntity> payments, bool isBn, {required bool isPending}) {
    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              isPending
                  ? (isBn ? 'কোনো বকেয়া বেতন নেই' : 'No pending fees')
                  : (isBn ? 'কোনো পরিশোধের ইতিহাস নেই' : 'No payment history yet'),
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: payments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isBn ? payment.studentNameBn : payment.studentName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: payment.status.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isBn ? payment.status.displayNameBn : payment.status.displayNameEn,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: payment.status.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  payment.month,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isBn ? payment.method.displayNameBn : payment.method.displayNameEn,
                            style: const TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (payment.gatewayTxnId.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(
                            'Txn: ${payment.gatewayTxnId}',
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      isBn ? BanglaUtils.toBanglaTaka(payment.amount) : '৳${payment.amount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

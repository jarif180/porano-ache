import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../../l10n/app_localizations.dart';

class StudentDashboardPage extends ConsumerStatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  ConsumerState<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends ConsumerState<StudentDashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'শিক্ষার্থী পোর্টাল' : 'Student Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(Icons.school, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBn ? 'তাহমিদ হাসান' : 'Tahmid Hasan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isBn ? 'দশম শ্রেণি • বিজ্ঞান বিভাগ' : 'Class 10 • Science',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isBn ? 'টিউটর: জারিফ স্যার' : 'Tutor: Zarif Sir',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Day Count Summary Header
              Text(
                isBn ? 'দিন গণনা ও উপস্থিতি' : 'Day Count & Attendance',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Day Count Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildDayCountCard(
                      label: l10n.totalDays,
                      count: isBn ? BanglaUtils.toBanglaNumber(45) : '45',
                      color: AppColors.secondary,
                      icon: Icons.calendar_month,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDayCountCard(
                      label: l10n.presentDays,
                      count: isBn ? BanglaUtils.toBanglaNumber(40) : '40',
                      color: AppColors.present,
                      icon: Icons.check_circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDayCountCard(
                      label: l10n.absentDays,
                      count: isBn ? BanglaUtils.toBanglaNumber(5) : '5',
                      color: AppColors.absent,
                      icon: Icons.cancel,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Payment Status & Pay Now Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.08),
                      blurRadius: 10,
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
                        Row(
                          children: [
                            const Icon(Icons.receipt_long, color: AppColors.accent, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              isBn ? 'চলতি মাসের বেতন (নভেম্বর)' : 'Monthly Fee (November)',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l10n.unpaid,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isBn ? BanglaUtils.toBanglaTaka(2500) : '৳2,500',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              isBn ? 'বকেয়া তারিখ: ২৫ নভেম্বর' : 'Due: Nov 25',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showPaymentDialog(context, isBn);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE2136E), // bKash brand pink
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.payment, size: 18),
                          label: Text(
                            l10n.payNow,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Next Class Card
              Text(
                isBn ? 'পরবর্তী ক্লাস' : 'Next Class',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.calculate_outlined, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBn ? 'উচ্চতর গণিত • ত্রিকোণমিতি' : 'Higher Math • Trigonometry',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isBn ? 'আজ বিকাল ৪:০০ - ৫:০০' : 'Today 4:00 PM - 5:00 PM',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isBn ? 'স্থান: বাসায় (হোম টিউশন)' : 'Location: Home Tuition',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick Action Tiles for Makeup Classes & Progress
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push('/my-makeup-classes'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event_repeat, color: AppColors.accent, size: 24),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                isBn ? 'বিকল্প ক্লাস' : 'Makeup Classes',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.accent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push('/my-progress'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_outline, color: AppColors.primary, size: 24),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                isBn ? 'আমার ফলাফল' : 'My Progress',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Recent Progress Note
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isBn ? 'শিক্ষকের মন্তব্য ও অগ্রগতি' : 'Tutor Feedback & Progress',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/my-progress'),
                    child: Text(isBn ? 'সব দেখুন' : 'See All'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isBn ? 'অধ্যায় ৮: পরিমিতি' : 'Chapter 8: Mensuration',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < 4 ? Icons.star : Icons.star_border,
                              color: AppColors.accent,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isBn
                          ? 'আজকের ক্লাসে সূত্রগুলো ভালোভাবে বুঝেছে। আগামী ক্লাসে অনুশীলনী ৮.২ এর অঙ্কগুলো সমাধান করা হবে।'
                          : 'Understood formulas well in today class. Will solve exercise 8.2 in next class.',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isBn ? 'তারিখ: ১৮ নভেম্বর ২০২৬' : 'Date: 18 Nov 2026',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 1) {
            context.push('/my-schedule');
          } else if (index == 2) {
            context.push('/my-attendance');
          } else if (index == 3) {
            context.push('/my-payments');
          } else {
            setState(() => _currentIndex = index);
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: l10n.mySchedule,
          ),
          NavigationDestination(
            icon: const Icon(Icons.check_circle_outline),
            selectedIcon: const Icon(Icons.check_circle),
            label: l10n.myAttendance,
          ),
          NavigationDestination(
            icon: const Icon(Icons.payment_outlined),
            selectedIcon: const Icon(Icons.payment),
            label: l10n.myPayments,
          ),
        ],
      ),
    );
  }

  Widget _buildDayCountCard({
    required String label,
    required String count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, bool isBn) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isBn ? 'পেমেন্ট মাধ্যম বেছে নিন' : 'Select Payment Method',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE2136E).withValues(alpha: 0.1),
                  child: const Text('বিকাশ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFE2136E))),
                ),
                title: const Text('bKash'),
                subtitle: Text(isBn ? 'বিকাশ অনলাইন পেমেন্ট' : 'bKash Online Payment'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isBn ? 'SSLCommerz বিকাশ গেটওয়ে সংযুক্ত হচ্ছে...' : 'Connecting bKash gateway...')),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFF7941D).withValues(alpha: 0.1),
                  child: const Text('নগদ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF7941D))),
                ),
                title: const Text('Nagad'),
                subtitle: Text(isBn ? 'নগদ অনলাইন পেমেন্ট' : 'Nagad Online Payment'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isBn ? 'SSLCommerz নগদ গেটওয়ে সংযুক্ত হচ্ছে...' : 'Connecting Nagad gateway...')),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.present.withValues(alpha: 0.1),
                  child: const Icon(Icons.money, color: AppColors.present),
                ),
                title: Text(isBn ? 'হাতে নগদ প্রদান' : 'Cash in Hand'),
                subtitle: Text(isBn ? 'শিক্ষককে সরাসরি পরিশোধ করেছেন' : 'Paid cash directly to tutor'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isBn ? 'নগদ পেমেন্টের অনুরোধ শিক্ষকের কাছে পাঠানো হয়েছে' : 'Cash payment request sent to tutor')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

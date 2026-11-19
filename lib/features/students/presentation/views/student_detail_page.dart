import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../domain/entities/student_entity.dart';
import '../controllers/student_notifier.dart';

class StudentDetailPage extends ConsumerStatefulWidget {
  final String studentId;

  const StudentDetailPage({super.key, required this.studentId});

  @override
  ConsumerState<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends ConsumerState<StudentDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final studentState = ref.watch(studentListNotifierProvider);

    return studentState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (students) {
        final student = students.firstWhere(
          (s) => s.id == widget.studentId,
          orElse: () => throw Exception('Student not found'),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(isBn ? student.fullNameBn : student.fullName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/students/edit/${student.id}'),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: isBn ? 'তথ্যাবলী' : 'Info'),
                Tab(text: isBn ? 'উপস্থিতি' : 'Attendance'),
                Tab(text: isBn ? 'পেমেন্ট' : 'Payments'),
                Tab(text: isBn ? 'অগ্রগতি' : 'Progress'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildInfoTab(student, isBn),
              _buildAttendanceTab(student, isBn),
              _buildPaymentsTab(student, isBn),
              _buildProgressTab(student, isBn),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTab(StudentEntity student, bool isBn) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    student.fullName.isNotEmpty ? student.fullName[0].toUpperCase() : 'S',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isBn ? student.fullNameBn : student.fullName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isBn ? student.fullName : student.fullNameBn,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${student.gradeLevel} • ${student.institution}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Invite Code Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? 'শিক্ষার্থী পোর্টাল ইনভাইট কোড' : 'Student Portal Invite Code',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      student.inviteCode,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: student.inviteCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isBn ? 'কোড কপি করা হয়েছে!' : 'Invite code copied!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.copy, size: 16),
                  label: Text(isBn ? 'কপি' : 'Copy'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Details List
          _buildInfoTile(
            icon: Icons.subject,
            title: isBn ? 'বিষয়সমূহ' : 'Subjects',
            content: student.subjects.join(', '),
          ),
          _buildInfoTile(
            icon: Icons.payments_outlined,
            title: isBn ? 'মাসিক বেতন' : 'Monthly Fee',
            content: isBn
                ? BanglaUtils.toBanglaTaka(student.monthlyFee)
                : '৳${student.monthlyFee.toStringAsFixed(0)}',
          ),
          _buildInfoTile(
            icon: Icons.person_outline,
            title: isBn ? 'অভিভাবকের নাম' : 'Parent Name',
            content: student.parentName,
          ),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            title: isBn ? 'অভিভাবকের ফোন' : 'Parent Phone',
            content: student.parentPhone,
          ),
          if (student.parentEmail.isNotEmpty)
            _buildInfoTile(
              icon: Icons.email_outlined,
              title: isBn ? 'অভিভাবকের ইমেইল' : 'Parent Email',
              content: student.parentEmail,
            ),
          if (student.notes.isNotEmpty)
            _buildInfoTile(
              icon: Icons.note_outlined,
              title: isBn ? 'মন্তব্য' : 'Notes',
              content: student.notes,
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab(StudentEntity student, bool isBn) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: isBn ? 'মোট দিন' : 'Total Days',
                  value: isBn ? BanglaUtils.toBanglaNumber(45) : '45',
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  title: isBn ? 'উপস্থিত' : 'Present',
                  value: isBn ? BanglaUtils.toBanglaNumber(40) : '40',
                  color: AppColors.present,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  title: isBn ? 'অনুপস্থিত' : 'Absent',
                  value: isBn ? BanglaUtils.toBanglaNumber(5) : '5',
                  color: AppColors.absent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  title: isBn ? 'শতকরা' : 'Rate',
                  value: isBn ? '৮৯%' : '89%',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            isBn ? 'সাম্প্রতিক উপস্থিতি ইতিহাস' : 'Recent Attendance Logs',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildAttendanceRow('১৮ নভেম্বর ২০২৬', 'উপস্থিত', AppColors.present, isBn),
          _buildAttendanceRow('১৬ নভেম্বর ২০২৬', 'উপস্থিত', AppColors.present, isBn),
          _buildAttendanceRow('১৪ নভেম্বর ২০২৬', 'অনুপস্থিত (অসুস্থতা)', AppColors.absent, isBn),
          _buildAttendanceRow('১২ নভেম্বর ২০২৬', 'উপস্থিত', AppColors.present, isBn),
          _buildAttendanceRow('১০ নভেম্বর ২০২৬', 'দেরি (১৫ মিনিট)', AppColors.late, isBn),
        ],
      ),
    );
  }

  Widget _buildPaymentsTab(StudentEntity student, bool isBn) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Status Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? 'নভেম্বর ২০২৬ এর বেতন' : 'November 2026 Fee',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isBn
                          ? BanglaUtils.toBanglaTaka(student.monthlyFee)
                          : '৳${student.monthlyFee.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isBn ? 'বকেয়া' : 'Unpaid',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isBn ? 'পেমেন্ট ইতিহাস' : 'Payment History',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildPaymentRecord('অক্টোবর ২০২৬', student.monthlyFee, 'নগদ (Cash)', 'পরিশোধিত', AppColors.success, isBn),
          _buildPaymentRecord('সেপ্টেম্বর ২০২৬', student.monthlyFee, 'বিকাশ (bKash)', 'পরিশোধিত', AppColors.success, isBn),
          _buildPaymentRecord('আগস্ট ২০২৬', student.monthlyFee, 'নগদ (Cash)', 'পরিশোধিত', AppColors.success, isBn),
        ],
      ),
    );
  }

  Widget _buildProgressTab(StudentEntity student, bool isBn) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildProgressCard(
          chapter: isBn ? 'অধ্যায় ৮: পরিমিতি' : 'Chapter 8: Mensuration',
          date: isBn ? '১৮ নভেম্বর ২০২৬' : '18 Nov 2026',
          rating: 4,
          comment: isBn
              ? 'সূত্রের প্রয়োগে বেশ ভালো দক্ষতা দেখিয়েছে। আগামী দিন অনুশীলনী সমাধান করা হবে।'
              : 'Showed good understanding of formula applications. Will solve exercises next class.',
          isBn: isBn,
        ),
        const SizedBox(height: 10),
        _buildProgressCard(
          chapter: isBn ? 'অধ্যায় ৭: ব্যবহারিক জ্যামিতি' : 'Chapter 7: Practical Geometry',
          date: isBn ? '১১ নভেম্বর ২০২৬' : '11 Nov 2026',
          rating: 5,
          comment: isBn
              ? 'চমৎকার পারফরম্যান্স! সম্পাদ্য নির্ভুলভাবে আঁকতে পেরেছে।'
              : 'Excellent performance! Drew all geometric constructions accurately.',
          isBn: isBn,
        ),
        const SizedBox(height: 10),
        _buildProgressCard(
          chapter: isBn ? 'অধ্যায় ৯: ত্রিকোণমিতি' : 'Chapter 9: Trigonometry',
          date: isBn ? '৪ নভেম্বর ২০২৬' : '4 Nov 2026',
          rating: 3,
          comment: isBn
              ? 'ত্রিকোণমিতিক অনুপাতে কিছুটা দুর্বলতা আছে। আরও কিছু বাড়তি প্র্যাকটিস করতে হবে।'
              : 'Needs more practice with trigonometric ratios. Assigned additional homework.',
          isBn: isBn,
        ),
      ],
    );
  }

  Widget _buildInfoTile({required IconData icon, required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(String date, String status, Color color, bool isBn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRecord(String month, double amount, String method, String status, Color color, bool isBn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(month, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(method, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isBn ? BanglaUtils.toBanglaTaka(amount) : '৳${amount.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String chapter,
    required String date,
    required int rating,
    required String comment,
    required bool isBn,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              Expanded(
                child: Text(chapter, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: AppColors.accent,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(comment, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: 8),
          Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

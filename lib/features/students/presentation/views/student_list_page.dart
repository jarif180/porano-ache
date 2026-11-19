import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bangla_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/student_entity.dart';
import '../controllers/student_notifier.dart';

class StudentListPage extends ConsumerStatefulWidget {
  const StudentListPage({super.key});

  @override
  ConsumerState<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends ConsumerState<StudentListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<StudentEntity> _filterStudents(List<StudentEntity> students, bool isActiveTab) {
    return students.where((student) {
      final matchesStatus = student.isActive == isActiveTab;
      final matchesQuery = _searchQuery.isEmpty ||
          student.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.fullNameBn.contains(_searchQuery) ||
          student.institution.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.subjects.any((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesStatus && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final studentState = ref.watch(studentListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.students),
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
            Tab(text: isBn ? 'সক্রিয় শিক্ষার্থী' : 'Active Students'),
            Tab(text: isBn ? 'আর্কাইভকৃত' : 'Archived'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: isBn ? 'শিক্ষার্থী খুঁজুন...' : 'Search student by name, subject...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                },
              ),
            ),

            // Tab Content
            Expanded(
              child: studentState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(isBn ? 'ডাটা লোড করতে সমস্যা হয়েছে' : 'Failed to load data'),
                ),
                data: (allStudents) {
                  final activeStudents = _filterStudents(allStudents, true);
                  final archivedStudents = _filterStudents(allStudents, false);

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildStudentList(activeStudents, isBn, isActiveTab: true),
                      _buildStudentList(archivedStudents, isBn, isActiveTab: false),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/students/add'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: Text(
          isBn ? 'নতুন শিক্ষার্থী' : 'Add Student',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStudentList(List<StudentEntity> students, bool isBn, {required bool isActiveTab}) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              isBn ? 'কোনো শিক্ষার্থী পাওয়া যায়নি' : 'No students found',
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: students.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final student = students[index];
        return _buildStudentCard(student, isBn, isActiveTab);
      },
    );
  }

  Widget _buildStudentCard(StudentEntity student, bool isBn, bool isActive) {
    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.push('/students/detail/${student.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: isActive
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.2),
                    child: Text(
                      student.fullName.isNotEmpty ? student.fullName[0].toUpperCase() : 'S',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isActive ? AppColors.primary : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBn ? student.fullNameBn : student.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${student.gradeLevel} • ${student.institution}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                    onSelected: (action) {
                      if (action == 'edit') {
                        context.push('/students/edit/${student.id}');
                      } else if (action == 'toggle') {
                        ref.read(studentListNotifierProvider.notifier).toggleStudentStatus(student.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isActive
                                  ? (isBn ? 'শিক্ষার্থীকে আর্কাইভ করা হয়েছে' : 'Student archived')
                                  : (isBn ? 'শিক্ষার্থী পুনরায় সক্রিয় করা হয়েছে' : 'Student activated'),
                            ),
                          ),
                        );
                      } else if (action == 'delete') {
                        _confirmDelete(student, isBn);
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 18, color: AppColors.info),
                            const SizedBox(width: 8),
                            Text(isBn ? 'সম্পাদনা' : 'Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Row(
                          children: [
                            Icon(
                              isActive ? Icons.archive_outlined : Icons.unarchive_outlined,
                              size: 18,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            Text(isActive ? (isBn ? 'আর্কাইভ করুন' : 'Archive') : (isBn ? 'পুনরুদ্ধার করুন' : 'Activate')),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            const SizedBox(width: 8),
                            Text(isBn ? 'মুছুন' : 'Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Subject tags
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: student.subjects.map((sub) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      sub,
                      style: const TextStyle(fontSize: 11, color: AppColors.primaryDark),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Footer: Monthly fee & Invite Code
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.payments_outlined, size: 16, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        isBn
                            ? BanglaUtils.toBanglaTaka(student.monthlyFee)
                            : '৳${student.monthlyFee.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        isBn ? ' /মাস' : ' /mo',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.key, size: 12, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          student.inviteCode,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(StudentEntity student, bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isBn ? 'শিক্ষার্থী মুছে ফেলবেন?' : 'Delete Student?'),
        content: Text(
          isBn
              ? '${student.fullNameBn}-কে মুছে ফেলতে চান? তার সকল তথ্য স্থায়ীভাবে মুছে যাবে।'
              : 'Are you sure you want to delete ${student.fullName}? All associated data will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isBn ? 'বাতিল' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              ref.read(studentListNotifierProvider.notifier).deleteStudent(student.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isBn ? 'শিক্ষার্থী মুছে ফেলা হয়েছে' : 'Student deleted')),
              );
            },
            child: Text(isBn ? 'মুছে ফেলুন' : 'Delete'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isBn = currentLocale.languageCode == 'bn';
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'সেটিংস ও প্রোফাইল' : 'Settings & Profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const Icon(Icons.person, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBn ? 'জারিফ হোসেন (শিক্ষক)' : 'Zarif Hossain (Tutor)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+880 1712-345678',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'zarif.tutor@gmail.com',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 1: Language
            Text(
              isBn ? 'ভাষা নির্বাচন (Language)' : 'Language Selection',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('বাংলা 🇧🇩 (Bangla)', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('অ্যাপের সব লেখা বাংলায় প্রদর্শিত হবে'),
                    value: 'bn',
                    groupValue: currentLocale.languageCode,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      ref.read(localeProvider.notifier).state = const Locale('bn');
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  RadioListTile<String>(
                    title: const Text('English 🇬🇧 (ইংরেজি)', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Displays all app content in English'),
                    value: 'en',
                    groupValue: currentLocale.languageCode,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      ref.read(localeProvider.notifier).state = const Locale('en');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 2: Appearance & Theme
            Text(
              isBn ? 'ডিসপ্লে ও থিম' : 'Appearance & Theme',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: SwitchListTile(
                secondary: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: isDark ? Colors.amber : AppColors.primary,
                ),
                title: Text(
                  isBn ? 'ডার্ক মোড (Dark Theme)' : 'Dark Theme',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  isBn ? 'রাতের ব্যবহারের জন্য চোখের স্বস্তিদায়ক' : 'Easier on the eyes in low light',
                  style: const TextStyle(fontSize: 12),
                ),
                value: isDark,
                onChanged: (val) {
                  ref.read(themeModeProvider.notifier).state =
                      val ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
            const SizedBox(height: 24),

            // Section 3: Navigation Shortcuts
            Text(
              isBn ? 'দ্রুত লিঙ্কসমূহ' : 'Quick Navigation Links',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.event_repeat, color: AppColors.accent),
                    title: Text(isBn ? 'বিকল্প ক্লাস তালিকা' : 'Makeup Classes List'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/makeup-classes'),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.note_alt_outlined, color: AppColors.primary),
                    title: Text(isBn ? 'শিক্ষার্থীর অগ্রগতি নোট' : 'Student Progress Notes'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/progress'),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.payment_outlined, color: AppColors.present),
                    title: Text(isBn ? 'পেমেন্ট ও বকেয়া হিসেব' : 'Payments & Tuition Fees'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/payments'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 4: About App
            Text(
              isBn ? 'অ্যাপ সম্পর্কে' : 'About App',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.school, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBn ? 'পড়ানো আছে (Porano Ache)' : 'Porano Ache',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Text(
                            'Version 1.0.0 (Build 2026.11)',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isBn
                        ? 'বাংলাদেশের গৃহশিক্ষক ও শিক্ষার্থীদের টিউশন ব্যবস্থাপনাকে সহজ ও আধুনিক করতে তৈরি। বাংলা ও ইংরেজি উভয় ভাষায় স্বাচ্ছন্দ্যে ব্যবহারযোগ্য।'
                        : 'Designed to streamline tuition management for tutors and students in Bangladesh. Full bilingual support in Bangla and English.',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout / Switch Role
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.go('/login');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.absent,
                  side: const BorderSide(color: AppColors.absent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout, size: 20),
                label: Text(
                  isBn ? 'লগআউট / রোল পরিবর্তন' : 'Logout / Switch Role',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

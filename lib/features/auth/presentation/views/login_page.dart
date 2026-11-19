import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../l10n/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.tutor;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRole == UserRole.tutor) {
        context.go('/tutor-dashboard');
      } else {
        context.go('/student-dashboard');
      }
    }
  }

  void _quickLogin(UserRole role) {
    if (role == UserRole.tutor) {
      context.go('/tutor-dashboard');
    } else {
      context.go('/student-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Branding / Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 44,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.welcomeMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Role Selector
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.divider.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Center(
                              child: Text(
                                isBn ? UserRole.tutor.displayNameBn : UserRole.tutor.displayNameEn,
                                style: TextStyle(
                                  fontWeight: _selectedRole == UserRole.tutor ? FontWeight.bold : FontWeight.normal,
                                  color: _selectedRole == UserRole.tutor ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            selected: _selectedRole == UserRole.tutor,
                            selectedColor: AppColors.primary,
                            showCheckmark: false,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedRole = UserRole.tutor);
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: ChoiceChip(
                            label: Center(
                              child: Text(
                                isBn ? UserRole.student.displayNameBn : UserRole.student.displayNameEn,
                                style: TextStyle(
                                  fontWeight: _selectedRole == UserRole.student ? FontWeight.bold : FontWeight.normal,
                                  color: _selectedRole == UserRole.student ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            selected: _selectedRole == UserRole.student,
                            selectedColor: AppColors.secondary,
                            showCheckmark: false,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedRole = UserRole.student);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email Input
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isBn ? 'ইমেইল দিন' : 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isBn ? 'পাসওয়ার্ড দিন' : 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: Text(
                      l10n.login,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Demo Quick-Access Section
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          isBn ? 'অথবা ডেমো দেখুন' : 'Or explore demo',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _quickLogin(UserRole.tutor),
                          icon: const Icon(Icons.person, size: 18),
                          label: Text(
                            isBn ? 'শিক্ষক মোড' : 'Tutor View',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _quickLogin(UserRole.student),
                          icon: const Icon(Icons.school, size: 18),
                          label: Text(
                            isBn ? 'শিক্ষার্থী মোড' : 'Student View',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

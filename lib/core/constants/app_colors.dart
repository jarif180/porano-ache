import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors (Teal & Emerald theme - modern educational feel)
  static const Color primary = Color(0xFF0D9488); // Teal 600
  static const Color primaryDark = Color(0xFF0F766E); // Teal 700
  static const Color primaryLight = Color(0xFF2DD4BF); // Teal 400
  static const Color secondary = Color(0xFF6366F1); // Indigo 500
  static const Color accent = Color(0xFFF59E0B); // Amber 500

  // Status colors
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color error = Color(0xFFEF4444); // Red
  static const Color warning = Color(0xFFF97316); // Orange
  static const Color info = Color(0xFF3B82F6); // Blue

  // Attendance colors
  static const Color present = Color(0xFF10B981);
  static const Color absent = Color(0xFFEF4444);
  static const Color late = Color(0xFFF59E0B);
  static const Color excused = Color(0xFF6366F1);

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;
  static const Color divider = Color(0xFFE2E8F0);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Dark Mode colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
}

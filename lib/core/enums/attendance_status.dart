import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AttendanceStatus {
  present,
  absent,
  late,
  excused;

  String get displayNameEn {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.excused:
        return 'Excused';
    }
  }

  String get displayNameBn {
    switch (this) {
      case AttendanceStatus.present:
        return 'উপস্থিত';
      case AttendanceStatus.absent:
        return 'অনুপস্থিত';
      case AttendanceStatus.late:
        return 'দেরি';
      case AttendanceStatus.excused:
        return 'ছুটি';
    }
  }

  Color get color {
    switch (this) {
      case AttendanceStatus.present:
        return AppColors.present;
      case AttendanceStatus.absent:
        return AppColors.absent;
      case AttendanceStatus.late:
        return AppColors.late;
      case AttendanceStatus.excused:
        return AppColors.excused;
    }
  }

  IconData get icon {
    switch (this) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.late:
        return Icons.access_time_filled;
      case AttendanceStatus.excused:
        return Icons.medical_services;
    }
  }
}

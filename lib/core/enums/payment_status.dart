import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum PaymentStatus {
  paid,
  unpaid,
  partial,
  overdue;

  String displayName(bool isBn) => isBn ? displayNameBn : displayNameEn;

  String get displayNameEn {
    switch (this) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.unpaid:
        return 'Unpaid';
      case PaymentStatus.partial:
        return 'Partial';
      case PaymentStatus.overdue:
        return 'Overdue';
    }
  }

  String get displayNameBn {
    switch (this) {
      case PaymentStatus.paid:
        return 'পরিশোধিত';
      case PaymentStatus.unpaid:
        return 'বকেয়া';
      case PaymentStatus.partial:
        return 'আংশিক';
      case PaymentStatus.overdue:
        return 'মেয়াদোত্তীর্ণ';
    }
  }

  Color get color {
    switch (this) {
      case PaymentStatus.paid:
        return AppColors.success;
      case PaymentStatus.unpaid:
        return AppColors.warning;
      case PaymentStatus.partial:
        return AppColors.info;
      case PaymentStatus.overdue:
        return AppColors.error;
    }
  }
}

enum PaymentMethod {
  cash,
  bkash,
  nagad,
  rocket,
  card,
  bank;

  String get displayNameEn {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash in Hand';
      case PaymentMethod.bkash:
        return 'bKash';
      case PaymentMethod.nagad:
        return 'Nagad';
      case PaymentMethod.rocket:
        return 'Rocket';
      case PaymentMethod.card:
        return 'Debit / Credit Card';
      case PaymentMethod.bank:
        return 'Bank Transfer';
    }
  }

  String get displayNameBn {
    switch (this) {
      case PaymentMethod.cash:
        return 'হাতে নগদ';
      case PaymentMethod.bkash:
        return 'বিকাশ';
      case PaymentMethod.nagad:
        return 'নগদ';
      case PaymentMethod.rocket:
        return 'রকেট';
      case PaymentMethod.card:
        return 'কার্ড / ভিসা';
      case PaymentMethod.bank:
        return 'ব্যাংক ট্রান্সফার';
    }
  }

  String displayName(bool isBn) => isBn ? displayNameBn : displayNameEn;
}

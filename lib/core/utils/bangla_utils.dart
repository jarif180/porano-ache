class BanglaUtils {
  static const List<String> _bnDigits = [
    '০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'
  ];

  static const List<String> _bnMonths = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  static const List<String> _bnWeekdays = [
    'সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার', 'শুক্রবার', 'শনিবার', 'রবিবার'
  ];

  /// Converts English numbers/digits to Bangla digits (e.g. 123 -> ১২৩)
  static String toBanglaNumber(dynamic number) {
    if (number == null) return '';
    return number.toString().split('').map((char) {
      final digit = int.tryParse(char);
      return digit != null ? _bnDigits[digit] : char;
    }).join();
  }

  /// Formats date to Bangla (e.g. ২০ নভেম্বর ২০২৬)
  static String toBanglaDate(DateTime date) {
    final day = toBanglaNumber(date.day);
    final month = _bnMonths[date.month - 1];
    final year = toBanglaNumber(date.year);
    return '$day $month $year';
  }

  /// Formats weekday to Bangla
  static String toBanglaWeekday(DateTime date) {
    return _bnWeekdays[date.weekday - 1];
  }

  /// Formats currency to Bangladeshi Taka (e.g. ৳৫,০০০)
  static String toBanglaTaka(num amount) {
    return '৳${toBanglaNumber(amount.toStringAsFixed(0))}';
  }

  /// Formats currency in English (e.g. ৳5,000)
  static String toEnglishTaka(num amount) {
    return '৳${amount.toStringAsFixed(0)}';
  }
}

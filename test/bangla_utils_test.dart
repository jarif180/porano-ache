import 'package:flutter_test/flutter_test.dart';
import 'package:porano_ache/core/utils/bangla_utils.dart';

void main() {
  group('BanglaUtils Tests', () {
    test('toBanglaNumber converts English digits to Bangla digits', () {
      expect(BanglaUtils.toBanglaNumber(0), '০');
      expect(BanglaUtils.toBanglaNumber(12345), '১২৩৪৫');
      expect(BanglaUtils.toBanglaNumber(67890), '৬৭৮৯০');
      expect(BanglaUtils.toBanglaNumber(null), '');
    });

    test('toBanglaDate formats date in Bangla', () {
      final date = DateTime(2026, 11, 20);
      expect(BanglaUtils.toBanglaDate(date), '২০ নভেম্বর ২০২৬');
    });

    test('toBanglaTaka formats currency in BDT', () {
      expect(BanglaUtils.toBanglaTaka(5000), '৳৫০০০');
      expect(BanglaUtils.toBanglaTaka(2500), '৳২৫০০');
    });

    test('toEnglishTaka formats currency in English BDT', () {
      expect(BanglaUtils.toEnglishTaka(5000), '৳5000');
    });
  });
}

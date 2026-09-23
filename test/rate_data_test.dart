import 'package:flutter_test/flutter_test.dart';
import 'package:kiraasistanim/rate_data.dart';

void main() {
  test('accepts a verified official source and flags old data', () {
    final rate = RateData.fromJson({
      'period': '2026-08',
      'publishedAt': '2026-09-03',
      'ratePercent': '31.79',
      'sourceUrl': 'https://veriportali.tuik.gov.tr/tr/press/58290',
    });
    expect(rate.rateHundredths, 3179);
    expect(rate.isStale(DateTime(2026, 10, 10)), isFalse);
    expect(rate.isStale(DateTime(2026, 10, 20)), isTrue);
  });

  test('rejects an unrelated source', () {
    expect(
      () => RateData.fromJson({
        'period': '2026-08',
        'publishedAt': '2026-09-03',
        'ratePercent': '31.79',
        'sourceUrl': 'https://example.com/rate',
      }),
      throwsFormatException,
    );
  });
}

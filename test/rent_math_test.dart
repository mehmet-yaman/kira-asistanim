import 'package:flutter_test/flutter_test.dart';
import 'package:kiraasistanim/rent_math.dart';

void main() {
  test('Turkish amount and official rate produce the expected rent', () {
    final rent = parseHundredths('15.000,00');
    final rate = parseHundredths('31.79');
    expect(rent, 1500000);
    expect(rate, 3179);
    final result = calculateIncrease(rent!, rate!);
    expect(result.differenceCents, 476850);
    expect(result.newRentCents, 1976850);
  });

  test('zero rate and cent rounding', () {
    expect(calculateIncrease(10001, 0).newRentCents, 10001);
    expect(calculateIncrease(10001, 50).differenceCents, 50);
  });

  test('invalid amounts do not parse', () {
    for (final value in ['', '-1', '1,234', '1.23,45', 'abc']) {
      expect(parseHundredths(value), isNull, reason: value);
    }
    expect(parseHundredths('1.234,5'), 123450);
  });
}

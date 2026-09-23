import 'package:flutter_test/flutter_test.dart';
import 'package:kiraasistanim/contract_age.dart';

void main() {
  test('contract anniversary determines completed years', () {
    final start = DateTime(2021, 9, 24);
    expect(completedContractYears(start, DateTime(2026, 9, 23)), 4);
    expect(completedContractYears(start, DateTime(2026, 9, 24)), 5);
    expect(completedContractYears(start, DateTime(2031, 9, 24)), 10);
  });
}

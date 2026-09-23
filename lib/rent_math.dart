class RentResult {
  const RentResult(this.newRentCents, this.differenceCents);
  final int newRentCents;
  final int differenceCents;
}

/// Turkish or plain decimal text to hundredths, without floating point.
int? parseHundredths(String input) {
  var value = input.trim().replaceAll(' ', '');
  if (value.isEmpty) return null;
  if (value.contains(',')) {
    final parts = value.split(',');
    if (parts.length != 2 ||
        !RegExp(r'^\d{1,3}(\.\d{3})*$|^\d+$').hasMatch(parts[0]) ||
        !RegExp(r'^\d{1,2}$').hasMatch(parts[1])) {
      return null;
    }
    final whole = int.tryParse(parts[0].replaceAll('.', ''));
    final fraction = int.tryParse(parts[1].padRight(2, '0'));
    return whole == null || fraction == null ? null : whole * 100 + fraction;
  }
  if (RegExp(r'^\d{1,3}(\.\d{3})+$').hasMatch(value)) {
    value = value.replaceAll('.', '');
  } else if (RegExp(r'^\d+\.\d{1,2}$').hasMatch(value)) {
    final parts = value.split('.');
    return int.parse(parts[0]) * 100 + int.parse(parts[1].padRight(2, '0'));
  }
  if (!RegExp(r'^\d+$').hasMatch(value)) return null;
  final whole = int.tryParse(value);
  return whole == null ? null : whole * 100;
}

String formatHundredths(int value) =>
    '${value ~/ 100},${(value % 100).toString().padLeft(2, '0')}';

RentResult calculateIncrease(int rentCents, int rateHundredths) {
  // A percent with two decimals has denominator 10,000.
  final difference = (rentCents * rateHundredths + 5000) ~/ 10000;
  return RentResult(rentCents + difference, difference);
}

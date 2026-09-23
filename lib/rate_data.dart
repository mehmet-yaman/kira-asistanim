import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'rent_math.dart';

class RateData {
  const RateData({
    required this.period,
    required this.publishedAt,
    required this.rateHundredths,
    required this.sourceUrl,
  });

  final DateTime period;
  final DateTime publishedAt;
  final int rateHundredths;
  final String sourceUrl;

  factory RateData.fromJson(Map<String, dynamic> json) {
    final period = DateTime.parse('${json['period']}-01');
    final publishedAt = DateTime.parse(json['publishedAt'] as String);
    final rate = parseHundredths(json['ratePercent'].toString());
    final sourceUrl = json['sourceUrl'] as String;
    final source = Uri.parse(sourceUrl);
    final now = DateTime.now();
    if (period.isAfter(now) ||
        publishedAt.isAfter(now) ||
        publishedAt.isBefore(period) ||
        rate == null ||
        rate < 0 ||
        rate > 10000 ||
        source.scheme != 'https' ||
        ![
          'veriportali.tuik.gov.tr',
          'data.tuik.gov.tr',
        ].contains(source.host)) {
      throw const FormatException('Geçersiz oran verisi');
    }
    return RateData(
      period: period,
      publishedAt: publishedAt,
      rateHundredths: rate,
      sourceUrl: sourceUrl,
    );
  }

  bool isStale(DateTime now) => now.difference(publishedAt).inDays > 45;
  String get periodLabel => DateFormat.yMMMM('tr_TR').format(period);
  String get publishedLabel =>
      DateFormat('d MMMM yyyy', 'tr_TR').format(publishedAt);
}

class RateRepository {
  static const rateUrl =
      'https://mehmet-yaman.github.io/kira-asistanim/data/rate.json';
  static const privacyUrl =
      'https://mehmet-yaman.github.io/kira-asistanim/privacy/';
  static const _cacheKey = 'last_verified_rate_json';

  Future<RateData> load() async {
    final preferences = await SharedPreferences.getInstance();
    final bundled = RateData.fromJson(
      jsonDecode(await rootBundle.loadString('assets/rate.json'))
          as Map<String, dynamic>,
    );
    var best = bundled;
    final cached = preferences.getString(_cacheKey);
    if (cached != null) {
      try {
        final parsed = RateData.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        if (!parsed.period.isBefore(best.period)) best = parsed;
      } catch (_) {
        /* Keep bundled data. */
      }
    }
    try {
      final response = await http
          .get(Uri.parse(rateUrl))
          .timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final parsed = RateData.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
        if (!parsed.period.isBefore(best.period)) {
          best = parsed;
          await preferences.setString(_cacheKey, response.body);
        }
      }
    } catch (_) {
      /* Continue with the last verified data. */
    }
    return best;
  }
}

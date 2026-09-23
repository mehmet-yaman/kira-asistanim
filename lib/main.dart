import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'rate_data.dart';
import 'rent_math.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KiraApp());
}

class KiraApp extends StatelessWidget {
  const KiraApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Kira Asistanım',
    debugShowCheckedModeBanner: false,
    locale: const Locale('tr', 'TR'),
    supportedLocales: const [Locale('tr', 'TR')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF473B83),
        primary: const Color(0xFF473B83),
        secondary: const Color(0xFFF18F59),
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F5F0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    home: const CalculatorPage(),
  );
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _rentController = TextEditingController();
  final _rateController = TextEditingController();
  final _repository = RateRepository();
  final _money = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
  );
  RateData? _rate;
  bool _manual = false;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _rentController.addListener(_refresh);
    _rateController.addListener(_refresh);
    _loadRate();
  }

  void _refresh() => setState(() {});

  Future<void> _loadRate() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rate = await _repository.load();
      if (mounted) {
        setState(() {
          _rate = rate;
          if (rate.isStale(DateTime.now())) _manual = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Oran alınamadı. Elle oran girebilirsiniz.';
          _manual = true;
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _open(String url) async {
    if (!await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        ) &&
        mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bağlantı açılamadı.')));
    }
  }

  @override
  void dispose() {
    _rentController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rent = parseHundredths(_rentController.text);
    final rate = _manual
        ? parseHundredths(_rateController.text)
        : _rate?.rateHundredths;
    final validRent = rent != null && rent > 0;
    final validRate = rate != null && rate >= 0;
    final result = validRent && validRate
        ? calculateIncrease(rent, rate)
        : null;
    final stale = _rate?.isStale(DateTime.now()) ?? true;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 34),
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF473B83),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 13),
                    const Text(
                      'Kira Asistanım',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Yeni kiranı\nkolayca hesapla.',
                  style: TextStyle(
                    fontSize: 36,
                    height: 1.13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF24213B),
                  ),
                ),
                const SizedBox(height: 11),
                const Text(
                  'Mevcut kiranı ve artış oranını gir; aylık farkı hemen gör.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Color(0xFF696577),
                  ),
                ),
                const SizedBox(height: 25),
                _rateCard(stale),
                const SizedBox(height: 24),
                const Text(
                  'Mevcut aylık kira',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 9),
                TextField(
                  controller: _rentController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'Örn. 15.000,00',
                    prefixIcon: Icon(Icons.payments_outlined),
                    suffixText: 'TL',
                  ),
                ),
                if (_rentController.text.isNotEmpty && !validRent)
                  const _InputError('Sıfırdan büyük, geçerli bir tutar girin.'),
                const SizedBox(height: 25),
                const Text(
                  'Artış oranı',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      label: Text('TÜİK oranı'),
                      icon: Icon(Icons.auto_awesome_outlined),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text('Kendi oranım'),
                      icon: Icon(Icons.edit_outlined),
                    ),
                  ],
                  selected: {_manual},
                  onSelectionChanged: (s) => setState(() => _manual = s.first),
                  showSelectedIcon: false,
                ),
                const SizedBox(height: 12),
                if (_manual)
                  TextField(
                    controller: _rateController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Örn. 31,12',
                      prefixIcon: Icon(Icons.percent_rounded),
                      suffixText: '%',
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _rate == null
                          ? 'Oran yükleniyor…'
                          : '%${formatHundredths(_rate!.rateHundredths)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF473B83),
                      ),
                    ),
                  ),
                if (_manual && _rateController.text.isNotEmpty && !validRate)
                  const _InputError(
                    'Sıfır veya daha büyük, geçerli bir oran girin.',
                  ),
                const SizedBox(height: 24),
                _resultCard(result),
                const SizedBox(height: 23),
                const Text(
                  'Bu araç yalnızca girdiğiniz tutar ve oranla matematiksel hesaplama yapar. '
                  'Sözleşmenize uygulanacak oran farklı olabilir; sonuç hukuki görüş değildir.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Color(0xFF696577),
                  ),
                ),
                const SizedBox(height: 19),
                TextButton.icon(
                  onPressed: () => _open(RateRepository.privacyUrl),
                  icon: const Icon(Icons.privacy_tip_outlined, size: 18),
                  label: const Text('Gizlilik politikası'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rateCard(bool stale) {
    final rate = _rate;
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEAF8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                stale ? Icons.info_outline : Icons.verified_outlined,
                size: 20,
                color: const Color(0xFF473B83),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  stale
                      ? 'Oran güncelliğini kontrol edin'
                      : 'Son yayımlanan TÜİK oranı',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF473B83),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Oranı yenile',
                onPressed: _loading ? null : _loadRate,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_loading && rate == null)
            const LinearProgressIndicator()
          else if (rate != null) ...[
            Text(
              '%${formatHundredths(rate.rateHundredths)}',
              style: const TextStyle(
                fontSize: 31,
                fontWeight: FontWeight.w800,
                color: Color(0xFF24213B),
              ),
            ),
            Text(
              '${rate.periodLabel} dönemi · ${rate.publishedLabel} yayımlandı',
              style: const TextStyle(fontSize: 13, color: Color(0xFF696577)),
            ),
            const SizedBox(height: 7),
            TextButton.icon(
              onPressed: () => _open(rate.sourceUrl),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('TÜİK bültenini aç'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
          ],
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Color(0xFFAF4039))),
          if (stale && rate != null)
            const Text(
              'Bu veri 45 günden eski. Güncel oranı TÜİK’ten doğrulayın veya elle girin.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
        ],
      ),
    );
  }

  Widget _resultCard(RentResult? result) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: const Color(0xFF473B83),
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(
          color: Color(0x22473B83),
          blurRadius: 22,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yeni aylık kira',
          style: TextStyle(color: Color(0xFFDCD7F2), fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          result == null ? '—' : _money.format(result.newRentCents / 100),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 17),
        const Divider(color: Color(0x55FFFFFF)),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.trending_up_rounded, color: Color(0xFFFFBC96)),
            const SizedBox(width: 8),
            const Text('Aylık fark', style: TextStyle(color: Colors.white)),
            const Spacer(),
            Text(
              result == null
                  ? '—'
                  : _money.format(result.differenceCents / 100),
              style: const TextStyle(
                color: Color(0xFFFFBC96),
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _InputError extends StatelessWidget {
  const _InputError(this.message);
  final String message;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 7),
    child: Text(message, style: const TextStyle(color: Color(0xFFAF4039))),
  );
}

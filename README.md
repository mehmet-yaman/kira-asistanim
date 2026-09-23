# Kira Asistanım

Türkçe, reklamsız Android kira artış hesaplayıcısı. Flutter ile geliştirilmiştir.

## Geliştirme

```sh
flutter pub get
flutter test
flutter analyze
flutter run
```

Uygulama kimliği `com.mehmetyaman.kiraasistanim`, hedef Android API 36'dır.

## Oran güncellemesi

Uygulama açılışta `https://mehmet-yaman.github.io/kira-asistanim/data/rate.json` dosyasını okur. Ağ yoksa son doğrulanmış oranı veya pakete gömülü `assets/rate.json` verisini kullanır. 45 günden eski veride kullanıcıya uyarı gösterir ve elle oran girişine geçer.

Her TÜİK TÜFE bülteni sonrası **genel endeksin on iki aylık ortalamalara göre değişim oranını** kontrol edin. Özel kapsamlı TÜFE satırını kullanmayın. Kullanıcı onayından sonra `docs/data/rate.json` dosyasında dönem, yayımlanma tarihi, oran ve resmi bülten bağlantısını güncelleyin. Bir sonraki uygulama sürümünde aynı veriyi `assets/rate.json` içine de taşıyın. Veri dosyasını yayımladıktan sonra herkese açık URL'den kontrol edin.

## Yayın

- `docs/` GitHub Pages kökü olarak yayımlanır; gizlilik sayfası `/privacy/` yolundadır.
- Play Console mağaza metni ve beyan notları `release/store-listing.md` içindedir.
- Gizli `android/key.properties` ve `.jks` dosyaları Git'e eklenmez. İmzalama anahtarını güvenli ve ayrı bir yerde yedekleyin.
- `flutter build appbundle --release` ile AAB oluşturulur. Google Play App Signing yapılandırmasında Google tarafından oluşturulan uygulama imzalama anahtarını seçin.

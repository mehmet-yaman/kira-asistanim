# Sonraki aşama: kira takibi

Bu aşama hesaplayıcı güncellemesinden ve kullanıcı denemesinden sonra ele alınacak.

## Kullanıcı akışı

1. Kullanıcı bir kira kaydı oluşturur: açıklama, ilk sözleşme tarihi, aylık ödeme günü, güncel kira tutarı ve isteğe bağlı not.
2. Uygulama gelecek ödeme tarihini ve sonraki ayların takvimini gösterir. Ayın 29–31'ine denk gelen ödeme günleri, daha kısa aylarda ayın son gününe taşınır.
3. Kullanıcı her dönemi “ödendi” olarak işaretler; ödeme tutarını ve gerçek ödeme tarihini düzeltebilir. Uygulama ödeme yapıldığını banka veya ev sahibi verisiyle doğruladığını iddia etmez.
4. Kullanıcı hesap açmadan cihazında takip yapabilir. Üyelik isteğe bağlı olur ve ancak hesaplı yedekleme veya cihazlar arası eşitleme gibi açık bir fayda hazırsa sunulur.

## Üyelik kararı öncesi gereksinimler

- Hesap açma yöntemi, veri saklama ve silme akışı, gizlilik politikası ve Play Veri Güvenliği beyanı birlikte tasarlanır.
- Kira tutarı, ödeme durumu ve sözleşme tarihi kişisel veridir; eşitleme açılana kadar cihazda tutulur.
- Bildirim istenirse açık kullanıcı izniyle etkinleştirilir; varsayılan olarak kapalıdır.
- Üyelik ücretli olacaksa kapsam, fiyat ve Play ödeme kuralları ayrıca kararlaştırılır.

## Bu sürümün sınırı

Bu aşamada kira kayıtları, ödeme takvimi, bildirim veya hesap sistemi eklenmez. Hesaplayıcı yalnızca ilk sözleşme tarihini geçici olarak kullanır; tarihi uygulama kapatıldıktan sonra saklamaz.

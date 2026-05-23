# Ateş & Su

Sakin, tek-dokunuşlu sonsuz kaçış oyunu. Bir alevsin; yukarıdan inen, çeperinde açıklıklar olan **su halkalarından** süzülerek geçersin. Suya değersen sönersin. Her geçilen halka **+1**.

Flutter + Flame ile yazıldı; tek kod tabanından iOS, Android ve Windows'a çıkar.

## Oyun

- Dokun = yüksel; bırakınca tüy gibi nazikçe düşersin.
- Su halkaları birer birer iner ve yavaşça döner; açıklık denk gelince geç.
- Suya (dolu yaya) değme = oyun biter (yumuşak sönme).
- Skor arttıkça iniş ve dönüş çok hafif hızlanır.
- En iyi skor cihazda kalıcı saklanır.

## Yapı

```
lib/
├─ main.dart                  # giriş, portrait, en iyi skor yükleme, overlay'ler
├─ config.dart                # TÜM ayarlar (fizik, halka, hız, renkler)
├─ services/high_score.dart   # en iyi skor (shared_preferences, korumalı)
├─ game/ates_su_game.dart     # ana oyun: durumlar, skor, zorluk, restart
├─ components/
│  ├─ player.dart             # alev: fizik + titreşim
│  ├─ trail.dart              # alevin ışık izi
│  ├─ water_ring.dart         # su halkası + ANALİTİK açıklık çarpışması
│  ├─ ring_spawner.dart       # halkaları birer birer üretir
│  ├─ bubbles.dart            # ambient yükselen baloncuklar
│  ├─ puff.dart               # buhar/parçacık (geçiş + sönme)
│  └─ death_fade.dart         # ölümde yumuşak karartı
└─ ui/
   ├─ start_overlay.dart      # başlangıç ekranı
   └─ game_over_overlay.dart  # bitiş + skor + rekor
```

Çarpışma notu: halka, Flame'in dolu daire hitbox'ı yerine analitik hesaplanır (uzaklık su bandında mı + açı açıklıkta mı). Yani görünen boşluk = gerçekten geçilebilir boşluk.

## Çalıştırma

```bash
flutter create .      # eksik platform klasörleri (android/ios/windows)
flutter pub get
flutter run
```

İnce ayar: his/zorluk için `lib/config.dart` (gravity, flapVelocity, baseDescent, baseRotation, openingDegrees, ringRadiusFactor...). Açıklık genişliği ve dönüş hızı oynanabilirliği en çok etkileyen iki değerdir; oynayarak dengele.

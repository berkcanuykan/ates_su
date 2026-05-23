import 'package:shared_preferences/shared_preferences.dart';

import '../models/skin.dart';

/// Oyuncunun kalıcı verisi: en iyi skor, istatistikler, seçili karakter,
/// ses/titreşim ayarları. Tüm disk erişimi korumalıdır (çökmez).
class Profile {
  Profile._();

  static int best = 0;
  static int games = 0;
  static int totalRings = 0;
  static String selectedSkinId = 'pofu';
  static bool soundOn = true;
  static bool hapticsOn = true;

  static Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      best = p.getInt('best') ?? 0;
      games = p.getInt('games') ?? 0;
      totalRings = p.getInt('totalRings') ?? 0;
      selectedSkinId = p.getString('skin') ?? 'pofu';
      soundOn = p.getBool('soundOn') ?? true;
      hapticsOn = p.getBool('hapticsOn') ?? true;
    } catch (_) {
      // varsayılanlarla devam.
    }
    // Seçili skin kilitliyse açık olan ilkine düş.
    if (!isUnlocked(Skins.byId(selectedSkinId))) {
      selectedSkinId = 'pofu';
    }
  }

  static Future<void> _save(void Function(SharedPreferences) writes) async {
    try {
      final p = await SharedPreferences.getInstance();
      writes(p);
    } catch (_) {}
  }

  static Skin get selectedSkin => Skins.byId(selectedSkinId);

  static bool isUnlocked(Skin s) => best >= s.unlockScore;

  /// Bir oyun bitti: istatistikleri güncelle. Rekorsa true döner.
  static bool recordGame(int score) {
    games++;
    totalRings += score;
    final bool isNewBest = score > best;
    if (isNewBest) best = score;
    _save((p) {
      p.setInt('games', games);
      p.setInt('totalRings', totalRings);
      if (isNewBest) p.setInt('best', best);
    });
    return isNewBest;
  }

  static void select(String skinId) {
    selectedSkinId = skinId;
    _save((p) => p.setString('skin', skinId));
  }

  static void setSound(bool v) {
    soundOn = v;
    _save((p) => p.setBool('soundOn', v));
  }

  static void setHaptics(bool v) {
    hapticsOn = v;
    _save((p) => p.setBool('hapticsOn', v));
  }

  /// Kaç skin açık (başarım göstergesi için).
  static int get unlockedCount =>
      Skins.all.where(isUnlocked).length;
}

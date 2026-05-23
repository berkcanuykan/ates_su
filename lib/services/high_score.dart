import 'package:shared_preferences/shared_preferences.dart';

/// En yüksek skoru cihazda kalıcı saklar. Tüm disk erişimi korunur:
/// depolama çalışmazsa oyun yine de oturum-içi skorla sorunsuz devam eder.
class HighScore {
  HighScore._();

  static const String _key = 'best_score';
  static int best = 0;

  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      best = prefs.getInt(_key) ?? 0;
    } catch (_) {
      best = 0;
    }
  }

  /// Rekorsa kaydeder ve true döner.
  static Future<bool> submit(int score) async {
    if (score <= best) return false;
    best = score;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, score);
    } catch (_) {}
    return true;
  }
}

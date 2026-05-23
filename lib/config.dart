import 'dart:ui';

/// Oyunun tüm ayarlanabilir değerleri. Zorluk, his ve renkleri
/// değiştirmek için SADECE burayı düzenle.
class GameConfig {
  GameConfig._();

  // --- Alev (oyuncu) ---
  /// Alevin yarıçapı (çarpışma için).
  static const double fireRadius = 16.0;

  /// Yatay konum (ekran genişliği oranı). Sabit, ortada.
  static const double fireXFactor = 0.5;

  /// Başlangıç dikey konumu (ekran yüksekliği oranı).
  static const double fireStartYFactor = 0.5;

  /// Yerçekimi (px/sn^2). Düşük = "tüy gibi", sakin.
  static const double gravity = 920.0;

  /// Dokununca uygulanan yukarı hız (negatif = yukarı).
  static const double flapVelocity = -330.0;

  /// Maksimum düşme hızı.
  static const double maxFallSpeed = 470.0;

  // --- Su halkası ---
  /// Halka yarıçapı (ekran genişliği oranı).
  static const double ringRadiusFactor = 0.40;

  /// Halka (su) kalınlığı.
  static const double ringThickness = 22.0;

  /// Çeperdeki açıklık sayısı.
  static const int openingCount = 3;

  /// Her açıklığın açısal genişliği (derece). Büyük = daha kolay.
  static const double openingDegrees = 85.0;

  /// Başlangıç iniş hızı (px/sn) — sakin.
  static const double baseDescent = 150.0;

  /// Her puanda inişe eklenen hız.
  static const double descentPerScore = 3.5;

  /// Maksimum iniş hızı.
  static const double maxDescent = 280.0;

  /// Başlangıç dönüş hızı (radyan/sn) — yavaş.
  static const double baseRotation = 0.85;

  /// Her puanda dönüşe eklenen hız.
  static const double rotationPerScore = 0.02;

  /// Maksimum dönüş hızı.
  static const double maxRotation = 1.15;

  /// Yeni halka, öncekinin merkezi bu y oranını (ekran yüksekliği) geçince üretilir.
  static const double spawnTriggerYFactor = 0.70;

  // --- Renkler (su/ateş sahnesi — koyu tema) ---
  static const Color background = Color(0xFF0E1E2E);
  static const Color backgroundDeep = Color(0xFF0A1622);
  static const Color bubble = Color(0x223FB6CE);
  static const Color water = Color(0xFF39C4DC);
  static const Color waterEdge = Color(0xFF1E7E93);
  static const Color fireOuter = Color(0xFFFF7A1A);
  static const Color fireInner = Color(0xFFFFC83A);
  static const Color fireCore = Color(0xFFFFE9A8);
  static const Color steam = Color(0xFFCDEFF6);
  static const Color hud = Color(0xFFEAF6FA);
  static const Color hudDim = Color(0xFF7FA8BC);
}

import 'dart:ui';

/// Karakter gövdesinin biçim çeşidi (küçük ayırt edici detaylar).
enum CreatureShape { round, ears, tuft, droplet, star }

/// Bir "kostüm paketi": karakter rengi/biçimi + engel (halka) rengi +
/// arka plan paleti + kilit eşiği. Tema seçimi = skin seçimi.
class Skin {
  const Skin({
    required this.id,
    required this.name,
    required this.shape,
    required this.body,
    required this.bodyDark,
    required this.accent,
    required this.obstacle,
    required this.obstacleEdge,
    required this.bg,
    required this.bgDeep,
    required this.bubble,
    required this.unlockScore,
  });

  final String id;
  final String name;
  final CreatureShape shape;

  final Color body;
  final Color bodyDark;
  final Color accent;

  final Color obstacle;
  final Color obstacleEdge;

  final Color bg;
  final Color bgDeep;
  final Color bubble;

  /// Bu skin'in açılması için gereken en iyi skor (0 = baştan açık).
  final int unlockScore;
}

/// Tüm skin'ler. Yeni karakter eklemek için buraya bir Skin eklemen yeterli.
class Skins {
  Skins._();

  static const List<Skin> all = [
    Skin(
      id: 'pofu',
      name: 'Pofu',
      shape: CreatureShape.round,
      body: Color(0xFFFF8FA3),
      bodyDark: Color(0xFFE86F86),
      accent: Color(0xFFFFD36E),
      obstacle: Color(0xFF5BC8E0),
      obstacleEdge: Color(0xFF2E8AA0),
      bg: Color(0xFF1C1B2E),
      bgDeep: Color(0xFF14131F),
      bubble: Color(0x223FB6CE),
      unlockScore: 0,
    ),
    Skin(
      id: 'yumo',
      name: 'Yumo',
      shape: CreatureShape.ears,
      body: Color(0xFF79E0C2),
      bodyDark: Color(0xFF54C2A2),
      accent: Color(0xFFFFD36E),
      obstacle: Color(0xFFFF9FB2),
      obstacleEdge: Color(0xFFC76C7E),
      bg: Color(0xFF14211E),
      bgDeep: Color(0xFF0E1916),
      bubble: Color(0x2270E0C0),
      unlockScore: 0,
    ),
    Skin(
      id: 'limon',
      name: 'Limon',
      shape: CreatureShape.tuft,
      body: Color(0xFFFFD36E),
      bodyDark: Color(0xFFE8B84E),
      accent: Color(0xFFFF8FA3),
      obstacle: Color(0xFF9F8FF0),
      obstacleEdge: Color(0xFF6E5DC2),
      bg: Color(0xFF20201A),
      bgDeep: Color(0xFF161610),
      bubble: Color(0x22FFD36E),
      unlockScore: 10,
    ),
    Skin(
      id: 'sucuk',
      name: 'Su',
      shape: CreatureShape.droplet,
      body: Color(0xFF6FC8FF),
      bodyDark: Color(0xFF4AA6E0),
      accent: Color(0xFFCFEFFF),
      obstacle: Color(0xFFFF8F6E),
      obstacleEdge: Color(0xFFC76040),
      bg: Color(0xFF121C2A),
      bgDeep: Color(0xFF0C1420),
      bubble: Color(0x226FC8FF),
      unlockScore: 25,
    ),
    Skin(
      id: 'yildo',
      name: 'Yıldo',
      shape: CreatureShape.star,
      body: Color(0xFFC9A8FF),
      bodyDark: Color(0xFFA77FE0),
      accent: Color(0xFFFFD36E),
      obstacle: Color(0xFF79E0C2),
      obstacleEdge: Color(0xFF3FB69A),
      bg: Color(0xFF1B1630),
      bgDeep: Color(0xFF120F22),
      bubble: Color(0x22C9A8FF),
      unlockScore: 50,
    ),
  ];

  static Skin byId(String id) =>
      all.firstWhere((s) => s.id == id, orElse: () => all.first);
}

import 'dart:math' as math;
import 'dart:ui';

import '../models/skin.dart';

const Color _white = Color(0xFFFFFFFF);
const Color _pupil = Color(0xFF2A2740);

/// Sevimli bir yaratığı çizer. Hem Flame (oyuncu) hem Flutter CustomPaint
/// (profil ızgarası) aynı dart:ui Canvas'ı kullandığı için tek fonksiyon
/// her iki yerde de çalışır.
///
/// [t] zaman (idle nefes animasyonu), [squashY] dikey ezilme/uzama (zıplama hissi).
void drawCreature(
  Canvas c,
  double cx,
  double cy,
  double r,
  Skin s, {
  double t = 0,
  double squashY = 1.0,
}) {
  final double sy = squashY * (1 + 0.04 * math.sin(t * 3));
  final double sx = 2 - sy;

  c.save();
  c.translate(cx, cy);
  c.scale(sx, sy);

  // Biçime özel üst detaylar (gövdenin arkasında kalanlar önce).
  if (s.shape == CreatureShape.ears) {
    c.drawCircle(Offset(-r * 0.55, -r * 0.82), r * 0.30, Paint()..color = s.body);
    c.drawCircle(Offset(r * 0.55, -r * 0.82), r * 0.30, Paint()..color = s.body);
  } else if (s.shape == CreatureShape.droplet) {
    final p = Path()
      ..moveTo(0, -r * 1.5)
      ..quadraticBezierTo(r * 0.9, -r * 0.55, 0, -r * 0.55)
      ..quadraticBezierTo(-r * 0.9, -r * 0.55, 0, -r * 1.5)
      ..close();
    c.drawPath(p, Paint()..color = s.body);
  }

  // Gölge taban + gövde.
  c.drawCircle(Offset(0, r * 0.12), r, Paint()..color = s.bodyDark);
  c.drawCircle(Offset.zero, r, Paint()..color = s.body);

  // Üstte kalan biçim detayları.
  if (s.shape == CreatureShape.tuft) {
    final p = Path()
      ..moveTo(-r * 0.16, -r * 0.92)
      ..lineTo(0, -r * 1.4)
      ..lineTo(r * 0.16, -r * 0.92)
      ..close();
    c.drawPath(p, Paint()..color = s.accent);
  } else if (s.shape == CreatureShape.star) {
    _drawStar(c, Offset(r * 0.72, -r * 0.72), r * 0.26, s.accent);
  }

  // Gözler.
  const double exF = 0.36;
  final double eo = r * exF;
  final double ey = -r * 0.12;
  c.drawCircle(Offset(-eo, ey), r * 0.2, Paint()..color = _white);
  c.drawCircle(Offset(eo, ey), r * 0.2, Paint()..color = _white);
  c.drawCircle(Offset(-eo + r * 0.03, ey + r * 0.03), r * 0.09, Paint()..color = _pupil);
  c.drawCircle(Offset(eo + r * 0.03, ey + r * 0.03), r * 0.09, Paint()..color = _pupil);

  // Gülümseme.
  final mouth = Paint()
    ..color = _pupil
    ..style = PaintingStyle.stroke
    ..strokeWidth = r * 0.08
    ..strokeCap = StrokeCap.round;
  final mp = Path()
    ..moveTo(-r * 0.22, r * 0.30)
    ..quadraticBezierTo(0, r * 0.52, r * 0.22, r * 0.30);
  c.drawPath(mp, mouth);

  // Yanak allığı.
  final blush = Paint()..color = s.accent.withValues(alpha: 0.5);
  c.drawCircle(Offset(-r * 0.52, r * 0.22), r * 0.12, blush);
  c.drawCircle(Offset(r * 0.52, r * 0.22), r * 0.12, blush);

  c.restore();
}

void _drawStar(Canvas c, Offset center, double r, Color color) {
  final Path path = Path();
  for (int i = 0; i < 5; i++) {
    final double outer = -math.pi / 2 + i * 2 * math.pi / 5;
    final double inner = outer + math.pi / 5;
    final ox = center.dx + math.cos(outer) * r;
    final oy = center.dy + math.sin(outer) * r;
    final ix = center.dx + math.cos(inner) * r * 0.45;
    final iy = center.dy + math.sin(inner) * r * 0.45;
    if (i == 0) {
      path.moveTo(ox, oy);
    } else {
      path.lineTo(ox, oy);
    }
    path.lineTo(ix, iy);
  }
  path.close();
  c.drawPath(path, Paint()..color = color);
}

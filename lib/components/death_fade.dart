import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/ates_su_game.dart';

/// Ölüm anında ekrana çok kısa, yumuşak bir karartı (sert flaş değil) bindirir.
/// Sakin hisse uygun, nazik bir geçiş.
class DeathFade extends PositionComponent with HasGameReference<AtesSuGame> {
  DeathFade() : super(priority: 80);

  static const double _dur = 0.5;
  double _t = 0;

  @override
  Future<void> onLoad() async {
    size = game.size;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    if (_t >= _dur) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final double k = (1 - _t / _dur).clamp(0.0, 1.0) * 0.4;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF0A1622).withValues(alpha: k),
    );
  }
}

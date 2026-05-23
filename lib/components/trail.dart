import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../game/ates_su_game.dart';

/// Karakterin arkasinda kalan yumusak iz. Son konumlari saklar ve giderek sonen
/// daireler olarak cizer. Renk secili skin'den gelir.
class Trail extends PositionComponent with HasGameReference<AtesSuGame> {
  Trail() : super(priority: 5);

  static const int _maxPoints = 14;
  final List<Vector2> _points = [];
  double _accum = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state == GameState.gameOver) return;

    _accum += dt;
    if (_accum >= 0.02) {
      _accum = 0;
      _points.add(game.player.position.clone());
      while (_points.length > _maxPoints) {
        _points.removeAt(0);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    for (int i = 0; i < _points.length; i++) {
      final double k = i / _maxPoints;
      final p = _points[i];
      canvas.drawCircle(
        Offset(p.x, p.y),
        GameConfig.fireRadius * (0.25 + 0.5 * k),
        Paint()..color = game.skin.body.withValues(alpha: 0.05 + 0.18 * k),
      );
    }
  }
}

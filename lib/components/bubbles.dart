import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../game/ates_su_game.dart';

/// Arka planda yavaşça yükselen soluk baloncuklar — su atmosferi ve derinlik.
/// Her şeyin arkasında çizilir.
class Bubbles extends PositionComponent with HasGameReference<AtesSuGame> {
  Bubbles() : super(priority: -10);

  final List<_Bubble> _bubbles = [];
  final Random _rng = Random();

  @override
  Future<void> onLoad() async {
    size = game.size;
    for (int i = 0; i < 18; i++) {
      _bubbles.add(_spawn(initial: true));
    }
  }

  _Bubble _spawn({bool initial = false}) {
    return _Bubble(
      Vector2(
        _rng.nextDouble() * size.x,
        initial ? _rng.nextDouble() * size.y : size.y + 20,
      ),
      4 + _rng.nextDouble() * 12,
      14 + _rng.nextDouble() * 30,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (int i = 0; i < _bubbles.length; i++) {
      final b = _bubbles[i];
      b.pos.y -= b.speed * dt; // baloncuklar yükselir
      if (b.pos.y + b.r < 0) {
        _bubbles[i] = _spawn();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final Paint paint = Paint()..color = GameConfig.bubble;
    for (final b in _bubbles) {
      canvas.drawCircle(Offset(b.pos.x, b.pos.y), b.r, paint);
    }
  }
}

class _Bubble {
  _Bubble(this.pos, this.r, this.speed);
  final Vector2 pos;
  final double r;
  final double speed;
}

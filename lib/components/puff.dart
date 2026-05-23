import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Bağımsız parçacık bulutu. Geçişte buhar, ölümde sönme hissi için kullanılır.
/// Sürede sönümlenip kendini siler.
class Puff extends PositionComponent {
  Puff({
    required Vector2 position,
    required this.color,
    this.count = 10,
    this.speed = 130,
    this.life = 0.5,
  }) : super(position: position, anchor: Anchor.center, priority: 60);

  final Color color;
  final int count;
  final double speed;
  final double life;

  final List<_P> _ps = [];
  final Random _rng = Random();
  double _t = 0;

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < count; i++) {
      final double a = _rng.nextDouble() * pi * 2;
      final double s = speed * (0.35 + _rng.nextDouble() * 0.65);
      _ps.add(_P(Vector2(cos(a) * s, sin(a) * s - 20), 3 + _rng.nextDouble() * 4));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    if (_t >= life) {
      removeFromParent();
      return;
    }
    for (final p in _ps) {
      p.pos.add(p.vel * dt);
      p.vel.scale(0.93);
    }
  }

  @override
  void render(Canvas canvas) {
    final double k = (1 - _t / life).clamp(0.0, 1.0);
    final Paint paint = Paint()..color = color.withValues(alpha: k * 0.9);
    for (final p in _ps) {
      canvas.drawCircle(Offset(p.pos.x, p.pos.y), p.r * k, paint);
    }
  }
}

class _P {
  _P(this.vel, this.r) : pos = Vector2.zero();
  final Vector2 pos;
  final Vector2 vel;
  final double r;
}

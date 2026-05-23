import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../game/ates_su_game.dart';
import 'trail.dart';

/// Oyuncunun kontrol ettiği alev.
///
/// Yatayda sabit (ortada) durur. Dokununca yükselir, bırakınca nazikçe düşer.
/// Suya değme kontrolü [WaterRing] içinde yapılır; burada sadece zemin/tavan
/// sınırları ve "tüy gibi" fizik vardır. Hafif titreşim (flicker) canlılık katar.
class Player extends PositionComponent with HasGameReference<AtesSuGame> {
  Player() : super(anchor: Anchor.center, priority: 10);

  double _vy = 0;
  double _t = 0; // titreşim/salınım zamanı

  /// Çarpışma için kullanılan etkin yarıçap (game tarafından okunur).
  double get radius => GameConfig.fireRadius;

  double get _startY => game.size.y * GameConfig.fireStartYFactor;

  @override
  Future<void> onLoad() async {
    size = Vector2.all(GameConfig.fireRadius * 2);
    reset();
    // Işık izini (arkada) ekle.
    game.add(Trail());
  }

  void reset() {
    _vy = 0;
    _t = 0;
    position = Vector2(game.size.x * GameConfig.fireXFactor, _startY);
  }

  void flap() {
    _vy = GameConfig.flapVelocity;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;

    if (game.state == GameState.ready) {
      position.y = _startY + math.sin(_t * 2.4) * 10;
      return;
    }
    if (game.state != GameState.playing) return;

    _vy += GameConfig.gravity * dt;
    if (_vy > GameConfig.maxFallSpeed) _vy = GameConfig.maxFallSpeed;
    position.y += _vy * dt;

    final double half = size.y / 2;
    if (position.y < half) {
      position.y = half;
      if (_vy < 0) _vy = 0;
    }
    if (position.y - half > game.size.y) {
      game.gameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    // Hafif titreşim: dikey ölçek küçük salınım yapar.
    final double flick = 1.0 + math.sin(_t * 18) * 0.06;
    final double cx = size.x / 2;
    final double cy = size.y / 2;
    const double r = GameConfig.fireRadius;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(1.0, flick);

    // Sıcak hale (yumuşak, düşük opaklık).
    canvas.drawCircle(Offset(0, r * 0.2), r * 1.5, Paint()
      ..color = GameConfig.fireOuter.withOpacity(0.18));

    // Dış alev (damla biçimi, sivri ucu yukarı).
    final outer = Path()
      ..moveTo(0, -r * 1.25)
      ..cubicTo(r * 1.2, -r * 0.2, r * 1.0, r * 0.9, 0, r * 1.15)
      ..cubicTo(-r * 1.0, r * 0.9, -r * 1.2, -r * 0.2, 0, -r * 1.25)
      ..close();
    canvas.drawPath(outer, Paint()..color = GameConfig.fireOuter);

    // İç alev.
    final inner = Path()
      ..moveTo(0, -r * 0.65)
      ..cubicTo(r * 0.7, r * 0.0, r * 0.6, r * 0.7, 0, r * 0.85)
      ..cubicTo(-r * 0.6, r * 0.7, -r * 0.7, r * 0.0, 0, -r * 0.65)
      ..close();
    canvas.drawPath(inner, Paint()..color = GameConfig.fireInner);

    // Çekirdek.
    canvas.drawCircle(Offset(0, r * 0.35), r * 0.32, Paint()..color = GameConfig.fireCore);

    canvas.restore();
  }
}

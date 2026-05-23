import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../art/creature.dart';
import '../config.dart';
import '../game/ates_su_game.dart';
import 'trail.dart';

/// Oyuncunun kontrol ettigi sevimli karakter (secili skin'e gore cizilir).
///
/// Yatayda sabit (ortada). Dokununca yukselir, birakinca nazikce duser.
/// Suya/engele degme kontrolu [WaterRing] icinde yapilir; burada zemin/tavan
/// sinirlari, "tuy gibi" fizik ve ziplama hissi (squash/stretch) vardir.
class Player extends PositionComponent with HasGameReference<AtesSuGame> {
  Player() : super(anchor: Anchor.center, priority: 10);

  double _vy = 0;
  double _t = 0;

  /// Carpisma icin etkin yaricap.
  double get radius => GameConfig.fireRadius;

  double get _startY => game.size.y * GameConfig.fireStartYFactor;

  @override
  Future<void> onLoad() async {
    size = Vector2.all(GameConfig.fireRadius * 2);
    reset();
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
    final double sq = game.state == GameState.playing
        ? (1 - _vy / 2600).clamp(0.82, 1.18)
        : 1.0;
    drawCreature(
      canvas,
      size.x / 2,
      size.y / 2,
      GameConfig.fireRadius,
      game.skin,
      t: _t,
      squashY: sq,
    );
  }
}

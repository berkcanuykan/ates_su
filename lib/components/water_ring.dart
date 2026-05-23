import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../game/ates_su_game.dart';

/// Yukarıdan inen, yavaşça dönen su halkası. Çeperinde [GameConfig.openingCount]
/// adet açıklık vardır. Alev SADECE açıklıklardan veya halkanın iç deliğinden
/// güvenle geçer; suya (dolu yaya) değerse oyun biter.
///
/// Çarpışma, Flame'in dolu daire hitbox'ı yerine ANALİTİK hesaplanır: alevin
/// halka merkezine uzaklığı su bandında mı + o andaki açı bir açıklığa mı denk
/// geliyor? Böylece görünen boşluk = gerçekten geçilebilir boşluk.
class WaterRing extends PositionComponent with HasGameReference<AtesSuGame> {
  WaterRing() : super(anchor: Anchor.center);

  late final double _radius;
  late final double _seg; // iki açıklık merkezi arası açı
  late final double _gapHalf; // açıklık yarı genişliği (radyan)
  bool _scored = false;

  final Paint _water = Paint()
    ..color = GameConfig.water
    ..style = PaintingStyle.stroke
    ..strokeWidth = GameConfig.ringThickness
    ..strokeCap = StrokeCap.round;

  final Paint _sheen = Paint()
    ..color = GameConfig.waterEdge
    ..style = PaintingStyle.stroke
    ..strokeWidth = GameConfig.ringThickness * 0.34
    ..strokeCap = StrokeCap.round;

  @override
  Future<void> onLoad() async {
    _radius = game.size.x * GameConfig.ringRadiusFactor;
    _seg = (2 * math.pi) / GameConfig.openingCount;
    _gapHalf = (GameConfig.openingDegrees * math.pi / 180) / 2;
    size = Vector2.all(_radius * 2);
    position = Vector2(game.size.x / 2, -_radius);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state == GameState.playing) {
      position.y += game.currentDescent * dt;
      angle += game.currentRotation * dt;

      final fire = game.player;
      if (_hits(fire.position, fire.radius)) {
        game.gameOver();
      } else if (!_scored && position.y - _radius > fire.position.y) {
        _scored = true;
        game.onRingPassed(fire.position);
      }
    }

    if (position.y - _radius > game.size.y) {
      removeFromParent();
    }
  }

  /// Alev su bandında VE açıklık dışındaysa çarpışma var.
  bool _hits(Vector2 firePos, double fireR) {
    final double dx = firePos.x - position.x;
    final double dy = firePos.y - position.y;
    final double dist = math.sqrt(dx * dx + dy * dy);

    final double inner = _radius - GameConfig.ringThickness / 2 - fireR;
    final double outer = _radius + GameConfig.ringThickness / 2 + fireR;
    if (dist < inner || dist > outer) return false; // delikte veya tamamen dışarıda

    final double localAngle = math.atan2(dy, dx) - angle;
    return !_isOpening(localAngle);
  }

  bool _isOpening(double a) {
    double n = a % (2 * math.pi);
    if (n < 0) n += 2 * math.pi;
    for (int i = 0; i < GameConfig.openingCount; i++) {
      final double center = i * _seg;
      double diff = (n - center).abs();
      if (diff > math.pi) diff = 2 * math.pi - diff;
      if (diff <= _gapHalf) return true;
    }
    return false;
  }

  @override
  void render(Canvas canvas) {
    final Rect rect = Rect.fromCircle(
      center: Offset(_radius, _radius),
      radius: _radius,
    );
    final double sweep = _seg - 2 * _gapHalf;
    for (int i = 0; i < GameConfig.openingCount; i++) {
      final double start = i * _seg + _gapHalf;
      canvas.drawArc(rect, start, sweep, false, _water);
      canvas.drawArc(rect, start, sweep, false, _sheen);
    }
  }
}

import 'dart:ui' show Color;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart' show TextStyle, FontWeight;
import 'package:flutter/services.dart' show HapticFeedback;

import '../components/bubbles.dart';
import '../components/death_fade.dart';
import '../components/player.dart';
import '../components/puff.dart';
import '../components/ring_spawner.dart';
import '../components/water_ring.dart';
import '../config.dart';
import '../models/skin.dart';
import '../services/profile.dart';

enum GameState { ready, playing, gameOver }

/// Ana oyun: bilesenleri kurar, durumu yonetir, dokunusu iletir,
/// skor/zorluk, oyun bitisi, yeniden baslatma ve menuye donusu yonetir.
class AtesSuGame extends FlameGame with TapCallbacks {
  static const String homeOverlay = 'Home';
  static const String gameOverOverlay = 'GameOver';

  late final Player player;
  late final RingSpawner spawner;
  late final TextComponent _scoreText;

  GameState state = GameState.ready;
  int score = 0;
  bool isNewBest = false;

  /// O an secili kostum (renk + arka plan + engel rengi).
  Skin get skin => Profile.selectedSkin;

  double get currentDescent => (GameConfig.baseDescent + score * GameConfig.descentPerScore)
      .clamp(GameConfig.baseDescent, GameConfig.maxDescent);

  double get currentRotation => (GameConfig.baseRotation + score * GameConfig.rotationPerScore)
      .clamp(GameConfig.baseRotation, GameConfig.maxRotation);

  @override
  Future<void> onLoad() async {
    await add(Bubbles());

    spawner = RingSpawner();
    player = Player();

    final double shortest = size.x < size.y ? size.x : size.y;
    final double fontSize = (shortest * 0.16).clamp(34.0, 72.0);
    _scoreText = TextComponent(
      text: '0',
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y * 0.08),
      priority: 100,
      textRenderer: TextPaint(
        style: TextStyle(
          color: const Color(0xFFF2EEF8),
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    await addAll([spawner, player]);
    overlays.add(homeOverlay);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (state == GameState.playing) {
      player.flap();
      _haptic(_Haptic.light);
    }
  }

  void startGame() {
    if (state != GameState.ready) return;
    score = 0;
    isNewBest = false;
    _scoreText.text = '0';
    player.reset();
    spawner.reset();
    overlays.remove(homeOverlay);
    if (!_scoreText.isMounted) add(_scoreText);
    state = GameState.playing;
    player.flap();
  }

  void onRingPassed(Vector2 at) {
    score++;
    _scoreText.text = '$score';
    _scoreText.add(ScaleEffect.to(
      Vector2.all(1.3),
      EffectController(duration: 0.1, alternate: true),
    ));
    add(Puff(position: at.clone(), color: skin.body, count: 9, speed: 120, life: 0.5));
    _haptic(_Haptic.select);
  }

  void gameOver() {
    if (state != GameState.playing) return;
    state = GameState.gameOver;

    add(Puff(position: player.position.clone(), color: skin.body, count: 16, speed: 170, life: 0.7));
    add(DeathFade());
    _haptic(_Haptic.medium);

    isNewBest = Profile.recordGame(score);
    overlays.add(gameOverOverlay);
  }

  void restart() {
    _clearField();
    score = 0;
    isNewBest = false;
    _scoreText.text = '0';
    player.reset();
    spawner.reset();
    overlays.remove(gameOverOverlay);
    if (!_scoreText.isMounted) add(_scoreText);
    state = GameState.playing;
    player.flap();
  }

  /// Oyun bitis ekranindan ana menuye (profil) don.
  void goHome() {
    _clearField();
    player.reset();
    if (_scoreText.isMounted) _scoreText.removeFromParent();
    overlays.remove(gameOverOverlay);
    state = GameState.ready;
    overlays.add(homeOverlay);
  }

  void _clearField() {
    children.whereType<WaterRing>().toList().forEach((r) => r.removeFromParent());
    children.whereType<Puff>().toList().forEach((p) => p.removeFromParent());
  }

  void _haptic(_Haptic type) {
    if (!Profile.hapticsOn) return;
    switch (type) {
      case _Haptic.light:
        HapticFeedback.lightImpact();
        break;
      case _Haptic.select:
        HapticFeedback.selectionClick();
        break;
      case _Haptic.medium:
        HapticFeedback.mediumImpact();
        break;
    }
  }

  @override
  Color backgroundColor() => skin.bg;
}

enum _Haptic { light, select, medium }

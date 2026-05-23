import 'dart:ui' show Color;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart' show TextStyle, FontWeight;

import '../components/bubbles.dart';
import '../components/death_fade.dart';
import '../components/player.dart';
import '../components/puff.dart';
import '../components/ring_spawner.dart';
import '../components/water_ring.dart';
import '../config.dart';
import '../services/high_score.dart';

enum GameState { ready, playing, gameOver }

/// Ana oyun: bileşenleri kurar, durumu yönetir, dokunuşu iletir,
/// skor/zorluk ve oyun bitişi/yeniden başlatmayı yönetir.
class AtesSuGame extends FlameGame with TapCallbacks {
  static const String startOverlay = 'Start';
  static const String gameOverOverlay = 'GameOver';

  late final Player player;
  late final RingSpawner spawner;
  late final TextComponent _scoreText;

  GameState state = GameState.ready;
  int score = 0;
  bool isNewBest = false;

  double get currentDescent => (GameConfig.baseDescent + score * GameConfig.descentPerScore)
      .clamp(GameConfig.baseDescent, GameConfig.maxDescent);

  double get currentRotation => (GameConfig.baseRotation + score * GameConfig.rotationPerScore)
      .clamp(GameConfig.baseRotation, GameConfig.maxRotation);

  @override
  Future<void> onLoad() async {
    await add(Bubbles());

    spawner = RingSpawner();
    player = Player();

    _scoreText = TextComponent(
      text: '0',
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 64),
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: GameConfig.hud,
          fontSize: 52,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    await addAll([spawner, player]);
    overlays.add(startOverlay);
  }

  @override
  void onTapDown(TapDownEvent event) {
    switch (state) {
      case GameState.ready:
        startGame();
        break;
      case GameState.playing:
        player.flap();
        break;
      case GameState.gameOver:
        break;
    }
  }

  void startGame() {
    if (state != GameState.ready) return;
    state = GameState.playing;
    overlays.remove(startOverlay);
    if (!_scoreText.isMounted) add(_scoreText);
    player.flap();
  }

  /// Bir halka geçildiğinde.
  void onRingPassed(Vector2 at) {
    score++;
    _scoreText.text = '$score';
    _scoreText.add(
      ScaleEffect.to(
        Vector2.all(1.3),
        EffectController(duration: 0.1, alternate: true),
      ),
    );
    // Geçişte nazik buhar.
    add(Puff(
      position: at.clone(),
      color: GameConfig.steam,
      count: 9,
      speed: 120,
      life: 0.5,
    ));
  }

  /// Alev suya değdi / dışarı düştü.
  void gameOver() {
    if (state != GameState.playing) return;
    state = GameState.gameOver;

    // Nazik sönme: buhar + yumuşak karartı.
    add(Puff(
      position: player.position.clone(),
      color: GameConfig.steam,
      count: 16,
      speed: 170,
      life: 0.7,
    ));
    add(DeathFade());

    HighScore.submit(score).then((value) {
      isNewBest = value;
      overlays.add(gameOverOverlay);
    });
  }

  void restart() {
    children.whereType<WaterRing>().toList().forEach((r) => r.removeFromParent());
    children.whereType<Puff>().toList().forEach((p) => p.removeFromParent());

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

  @override
  Color backgroundColor() => GameConfig.background;
}

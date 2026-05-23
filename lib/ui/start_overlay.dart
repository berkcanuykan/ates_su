import 'package:flutter/material.dart';

import '../game/ates_su_game.dart';
import '../services/high_score.dart';

/// Başlangıç ekranı. Herhangi bir yere dokununca oyun başlar.
class StartOverlay extends StatelessWidget {
  const StartOverlay({super.key, required this.game});

  final AtesSuGame game;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: game.startGame,
      child: Container(
        color: Colors.black.withOpacity(0.30),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ateş & Su',
                style: TextStyle(
                  color: Color(0xFFFFC83A),
                  fontSize: 46,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'En iyi: ${HighScore.best}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Başlamak için dokun',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Dokun = yüksel · açıklıktan süzül',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

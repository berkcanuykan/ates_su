import 'package:flutter/material.dart';

import '../game/ates_su_game.dart';
import '../services/high_score.dart';

/// Oyun bitiş ekranı: skor, en iyi skor, rekor rozeti ve tekrar başlat.
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});

  final AtesSuGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Söndün',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 18),
            if (game.isNewBest)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC83A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Yeni rekor!',
                  style: TextStyle(
                    color: Color(0xFF3A2A05),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (game.isNewBest) const SizedBox(height: 16),
            Text(
              '${game.score}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'En iyi: ${HighScore.best}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: game.restart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC83A),
                foregroundColor: const Color(0xFF3A2A05),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              child: const Text('Tekrar Oyna'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../game/ates_su_game.dart';
import '../services/profile.dart';

/// Oyun bitis ekrani: skor, en iyi skor, rekor rozeti, tekrar oyna ve menu.
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});

  final AtesSuGame game;

  @override
  Widget build(BuildContext context) {
    final theme = Profile.selectedSkin;
    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bitti',
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
                  color: theme.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Yeni rekor!',
                  style: TextStyle(
                    color: Color(0xFF2A2740),
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
              'En iyi: ${Profile.best}',
              style: const TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: game.goHome,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Menu', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 14),
                ElevatedButton(
                  onPressed: game.restart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.body,
                    foregroundColor: const Color(0xFF2A2740),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Tekrar Oyna'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

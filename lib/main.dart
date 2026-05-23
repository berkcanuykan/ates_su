import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/ates_su_game.dart';
import 'services/high_score.dart';
import 'ui/game_over_overlay.dart';
import 'ui/start_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HighScore.load();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const AtesSuApp());
}

class AtesSuApp extends StatelessWidget {
  const AtesSuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AtesSuGame game = AtesSuGame();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget<AtesSuGame>(
          game: game,
          overlayBuilderMap: {
            AtesSuGame.startOverlay: (context, game) => StartOverlay(game: game),
            AtesSuGame.gameOverOverlay: (context, game) =>
                GameOverOverlay(game: game),
          },
        ),
      ),
    );
  }
}

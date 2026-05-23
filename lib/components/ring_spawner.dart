import 'package:flame/components.dart';

import '../config.dart';
import '../game/ates_su_game.dart';
import 'water_ring.dart';

/// Su halkalarını birer birer üretir. En son üretilen halka ekranın belli bir
/// noktasını geçince yenisini gönderir; böylece halkalar rahat aralıklarla,
/// üst üste binmeden iner.
class RingSpawner extends Component with HasGameReference<AtesSuGame> {
  WaterRing? _last;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state != GameState.playing) return;

    final double triggerY = game.size.y * GameConfig.spawnTriggerYFactor;

    final bool needNew =
        _last == null || _last!.isRemoved || _last!.position.y >= triggerY;

    if (needNew) {
      final ring = WaterRing();
      _last = ring;
      game.add(ring);
    }
  }

  /// Yeniden başlatmada referansı sıfırla (oyun halkaları zaten temizliyor).
  void reset() {
    _last = null;
  }
}

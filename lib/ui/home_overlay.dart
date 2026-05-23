import 'package:flutter/material.dart';

import '../art/creature.dart';
import '../game/ates_su_game.dart';
import '../models/skin.dart';
import '../services/profile.dart';

/// Ana/profil ekranı: istatistikler, karakter (tema) seçimi, ses/titreşim
/// ayarları, başarım göstergesi ve Oyna butonu. Mobil için kaydırılabilir.
class HomeOverlay extends StatefulWidget {
  const HomeOverlay({super.key, required this.game});

  final AtesSuGame game;

  @override
  State<HomeOverlay> createState() => _HomeOverlayState();
}

class _HomeOverlayState extends State<HomeOverlay> {
  @override
  Widget build(BuildContext context) {
    final Skin theme = Profile.selectedSkin;
    return Material(
      color: theme.bg,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Ateş & Su',
                  style: TextStyle(
                    color: theme.body,
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _stat('En iyi', '${Profile.best}', theme),
                  const SizedBox(width: 10),
                  _stat('Oyun', '${Profile.games}', theme),
                  const SizedBox(width: 10),
                  _stat('Halka', '${Profile.totalRings}', theme),
                ],
              ),
              const SizedBox(height: 22),
              _label('Karakterler'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: Skins.all.map(_tile).toList(),
              ),
              const SizedBox(height: 22),
              _label('Ayarlar'),
              _toggle('Ses', Icons.volume_up, Profile.soundOn, (v) {
                setState(() => Profile.setSound(v));
              }, theme),
              _toggle('Titreşim', Icons.vibration, Profile.hapticsOn, (v) {
                setState(() => Profile.setHaptics(v));
              }, theme),
              const SizedBox(height: 18),
              _label('Başarımlar'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.emoji_events, color: theme.accent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    '${Profile.unlockedCount}/${Skins.all.length} karakter açıldı',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: widget.game.startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.body,
                    foregroundColor: const Color(0xFF2A2740),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Oyna'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Skin theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: theme.bgDeep,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: const TextStyle(
                color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500)),
      );

  Widget _tile(Skin s) {
    final bool unlocked = Profile.isUnlocked(s);
    final bool selected = Profile.selectedSkinId == s.id;
    return GestureDetector(
      onTap: unlocked
          ? () => setState(() => Profile.select(s.id))
          : null,
      child: Container(
        width: 88,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: s.bgDeep,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? s.accent : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(size: const Size(64, 64), painter: _CreaturePainter(s)),
                  if (!unlocked)
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.lock, color: Colors.white, size: 24),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              unlocked ? s.name : '${s.unlockScore} skor',
              style: TextStyle(
                color: unlocked ? Colors.white : Colors.white54,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggle(String label, IconData icon, bool value,
      ValueChanged<bool> onChanged, Skin theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: theme.body,
          ),
        ],
      ),
    );
  }
}

class _CreaturePainter extends CustomPainter {
  _CreaturePainter(this.skin);
  final Skin skin;

  @override
  void paint(Canvas canvas, Size size) {
    drawCreature(canvas, size.width / 2, size.height / 2, size.width * 0.32, skin);
  }

  @override
  bool shouldRepaint(covariant _CreaturePainter old) => old.skin.id != skin.id;
}

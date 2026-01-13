import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static AudioManager? _instance;
  bool _enabled = true;

  AudioManager._();

  static AudioManager get instance {
    _instance ??= AudioManager._();
    return _instance!;
  }

  bool get enabled => _enabled;

  set enabled(bool value) {
    _enabled = value;
    if (!value) {
      FlameAudio.bgm.stop();
    }
  }

  Future<void> preload() async {
    // Preload will be called when audio files are available
  }

  void playFlip() {
    if (!_enabled) return;
    // FlameAudio.play('flip.mp3', volume: 0.5);
  }

  void playMatch() {
    if (!_enabled) return;
    // FlameAudio.play('match.mp3', volume: 0.7);
  }

  void playMismatch() {
    if (!_enabled) return;
    // FlameAudio.play('wrong.mp3', volume: 0.5);
  }

  void playCombo() {
    if (!_enabled) return;
    // FlameAudio.play('combo.mp3', volume: 0.8);
  }

  void playWin() {
    if (!_enabled) return;
    // FlameAudio.play('win.mp3', volume: 1.0);
  }

  void playCheer() {
    if (!_enabled) return;
    // FlameAudio.play('cheer.mp3', volume: 0.8);
  }

  void playStarCollect() {
    if (!_enabled) return;
    // FlameAudio.play('star_collect.mp3', volume: 0.6);
  }

  void playButton() {
    if (!_enabled) return;
    // FlameAudio.play('button.mp3', volume: 0.4);
  }

  void dispose() {
    FlameAudio.bgm.stop();
  }
}

import 'package:alippe/src/components/AlphabetsComponents/media_names.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SoundService {
  SoundService._();

  static SoundService? _instance;

  static SoundService get instance {
    _instance ??= SoundService._();
    return _instance!;
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  final Set<String> _available = {};
  final Set<String> _missing = {};

  Future<void> welcomeSound() async {
    await _play('audio/welcome.mp4');
  }

  Future<void> stopSound() async {
    await audioPlayer.stop();
  }

  Future<void> playTapDownSound(String sound) async {
    await _play(audioAssetFor(sound));
  }

  Future<void> _play(String assetPath) async {
    if (assetPath.isEmpty || _missing.contains(assetPath)) return;
    if (!_available.contains(assetPath)) {
      try {
        await rootBundle.load('assets/$assetPath');
        _available.add(assetPath);
      } catch (_) {
        _missing.add(assetPath);
        if (kDebugMode) {
          debugPrint('Нет аудио: $assetPath');
        }
        return;
      }
    }
    await audioPlayer.stop();
    await audioPlayer.play(AssetSource(assetPath));
  }
}

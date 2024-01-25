import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  // private constructor
  SoundService._();

  /// Cached instance of [SoundService]
  static SoundService? _instance;

  /// return an instance of [SoundService]
  static SoundService get instance {
    // set the instance if it's null
    _instance ??= SoundService._();
    // return the instance
    return _instance!;
  }

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> loadSounds() async {
    await _play('audio/alma.wav');
  }

  Future<void> welcomeSound() async {
    await _play('audio/welcome.mp4');
  }

  Future<void> stopSound() async {
    if (kDebugMode) {
      print("не смог остановить");
    }
    audioPlayer.stop();
  }

  Future<void> playTapDownSound(String sound) async {
    await _play('audio/$sound.wav');
  }

  Future<void> _play(String assetPath) async {
    await audioPlayer.play(AssetSource(assetPath));
  }
}

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

  final AudioCache _player = AudioCache(
    prefix: 'assets/audio/',
  );
  Future<void> loadSounds() async {
    await _player.load(
      'alma.mp4',
    );
  }

  Future<void> welcomeSound() async {
    await _player.play(
      'welcome.mp4',
    );
  }

  Future<void> stopSound() async {
    if (kDebugMode) {
      print("не смог остановить");
    }
  }

  Future<void> playTapDownSound(sound) async {
    print('sasa');
    await _player.play(
      '$sound.mp4',
    );
  }
}

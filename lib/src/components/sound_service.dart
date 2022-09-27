import 'package:audioplayers/audioplayers.dart';

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
      'alma.mp3',
    );
  }

  Future<void> welcomeSound() async {
    await _player.play(
      'welcome.mp3',
    );
  }

  Future<void> playTapDownSound(sound) async {
    await _player.play(
      '$sound.mp3',
      mode: PlayerMode.LOW_LATENCY,
    );
  }
}

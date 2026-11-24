import 'package:alippe/src/components/AlphabetsComponents/media_names.dart';
import 'package:alippe/src/locale/strings_of_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('alphabet has 42 unique letters and І sits between Ы and Ь', () {
    final names = alphabets.map((letter) => letter.name).toList();
    expect(names.length, 42);
    expect(names.toSet().length, 42);
    expect(names, contains('І'));
    expect(
      names.indexOf('Ы') < names.indexOf('І') &&
          names.indexOf('І') < names.indexOf('Ь'),
      isTrue,
    );
  });

  test('every letter has a name, a small form and a sound', () {
    for (final letter in alphabets) {
      expect(letter.name, isNotEmpty);
      expect(letter.smallName, isNotEmpty);
      expect(letter.sound, isNotEmpty);
    }
  });

  test('Ч and Щ do not share a sound, and В uses the recorded file', () {
    String soundOf(String name) =>
        alphabets.firstWhere((letter) => letter.name == name).sound;

    expect(soundOf('Ч'), 'ch');
    expect(soundOf('В'), 'v');
    expect(soundOf('Щ'), isNot(soundOf('Ч')));
  });

  test('known title typos are corrected and empty slots are dropped', () {
    final titles = alphabets.expand((letter) => letter.words.map((word) => word.title));
    expect(titles, isNot(contains('Ащщы')));
    expect(titles, isNot(contains('Тұщщы')));
    expect(titles, isNot(contains('Экскалатор')));
    expect(titles, contains('Ащы'));
    expect(titles, contains('Тұщы'));
    expect(titles, contains('Эскалатор'));

    final hardSign = alphabets.firstWhere((letter) => letter.name == 'Ъ');
    expect(hardSign.words, isEmpty);
    final a = alphabets.firstWhere((letter) => letter.name == 'А');
    expect(a.words, hasLength(4));
  });

  test('audio and image ids map onto the files that exist', () {
    expect(audioAssetFor('zhailau'), 'audio/jailau.wav');
    expect(audioAssetFor('football'), 'audio/futbol.wav');
    expect(audioAssetFor('han'), 'audio/xan.wav');
    expect(audioAssetFor('dombyra'), 'audio/dombyra.wav');
    expect(audioAssetFor(''), '');
    expect(imageCandidates('dombyra'), ['dombyra', 'dombyrea']);
    expect(imageCandidates(''), isEmpty);
  });
}

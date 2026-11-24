import 'package:alippe/src/screens/FairyTalesScreen/tale_highlight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('words keep their spaces and Kazakh letters', () {
    final pieces = splitTale('Түлкі тырнаны');

    expect(pieces.map((piece) => piece.text), ['Түлкі', ' ', 'тырнаны']);
    expect(pieces.map((piece) => piece.isWord), [true, false, true]);
    expect(pieces[0].weight, 5);
    expect(pieces[2].weight, 7);
  });

  test('a sentence end holds longer than a comma', () {
    final pieces = splitTale('Түлкі, тырна.');

    expect(pieces[0].weight, 7);
    expect(pieces[2].weight, 11);
  });

  test('the lit word follows the share of time', () {
    const weights = [5, 7];
    const duration = 1200;

    expect(
      wordIndexAt(elapsedMs: 0, durationMs: duration, weights: weights),
      0,
    );
    expect(
      wordIndexAt(elapsedMs: 400, durationMs: duration, weights: weights),
      0,
    );
    expect(
      wordIndexAt(elapsedMs: 700, durationMs: duration, weights: weights),
      1,
    );
    expect(
      wordIndexAt(elapsedMs: 1200, durationMs: duration, weights: weights),
      1,
    );
  });

  test('an empty line does not invent a word', () {
    expect(wordIndexAt(elapsedMs: 10, durationMs: 100, weights: const []), -1);
    expect(taleReadingDurationMs(const []), 0);
  });
}

class TalePiece {
  final String text;
  final int weight;

  const TalePiece(this.text, this.weight);

  bool get isWord => weight > 0;
}

final RegExp _tokens = RegExp(r'\s+|\S+');
final RegExp _letters = RegExp(r'\p{L}', unicode: true);
final RegExp _sentenceEnd = RegExp(r'[.!?…]');
final RegExp _pause = RegExp(r'[,:;–—]');

/// How fast a tale is read when it has no recording.
/// The duck story lands near this pace.
const int taleLettersPerSecond = 5;

List<TalePiece> splitTale(String text) {
  return [
    for (final match in _tokens.allMatches(text))
      TalePiece(match.group(0)!, _weight(match.group(0)!)),
  ];
}

int _weight(String token) {
  if (token.trim().isEmpty) return 0;
  final letters = _letters.allMatches(token).length;
  if (letters == 0) return 0;
  if (_sentenceEnd.hasMatch(token)) return letters + 6;
  if (_pause.hasMatch(token)) return letters + 2;
  return letters;
}

/// Word whose share of [durationMs] contains [elapsedMs].
/// Weights are letter counts, so a longer word stays lit longer.
int wordIndexAt({
  required int elapsedMs,
  required int durationMs,
  required List<int> weights,
}) {
  if (weights.isEmpty) return -1;
  if (durationMs <= 0 || elapsedMs <= 0) return 0;
  final total = weights.fold<int>(0, (sum, weight) => sum + weight);
  if (elapsedMs >= durationMs) return weights.length - 1;
  final cursor = elapsedMs / durationMs * total;
  var covered = 0;
  for (var i = 0; i < weights.length; i++) {
    covered += weights[i];
    if (cursor < covered) return i;
  }
  return weights.length - 1;
}

int taleReadingDurationMs(List<int> weights) {
  final total = weights.fold<int>(0, (sum, weight) => sum + weight);
  if (total <= 0) return 0;
  return (total * 1000 / taleLettersPerSecond).ceil();
}

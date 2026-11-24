import 'package:alippe/src/screens/AlphabetsScreen/letter_cone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a resting letter snaps to the nearest index', () {
    expect(
      coneSnapTarget(position: 3.2, velocityItems: 0, count: 42),
      3,
    );
    expect(
      coneSnapTarget(position: 3.6, velocityItems: 0, count: 42),
      4,
    );
  });

  test('a flick keeps traveling, then lands on a letter', () {
    final forward = coneSnapTarget(position: 2, velocityItems: 8, count: 42);
    final back = coneSnapTarget(position: 10, velocityItems: -8, count: 42);

    expect(forward, greaterThan(2));
    expect(back, lessThan(10));
    expect(forward, forward.roundToDouble());
    expect(back, back.roundToDouble());
  });

  test('the strip does not run past the first or last letter', () {
    expect(
      coneSnapTarget(position: 0.2, velocityItems: -12, count: 42),
      0,
    );
    expect(
      coneSnapTarget(position: 40.8, velocityItems: 12, count: 42),
      41,
    );
  });
}

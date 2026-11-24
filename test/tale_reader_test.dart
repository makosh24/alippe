import 'package:alippe/src/screens/FairyTalesScreen/tale_reader_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the spoken word is painted while reading', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TaleReaderScreen(
          title: 'Сынақ',
          text: 'Түлкі тырнаны көрді',
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.play_circle));
    await tester.pump();

    final word = tester.widget<Text>(find.text('Түлкі'));
    expect(word.style?.backgroundColor, const Color(0xFFFFD54F));
    expect(
      tester.widget<Text>(find.text('тырнаны')).style?.backgroundColor,
      isNull,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}

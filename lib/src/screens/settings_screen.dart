import 'package:alippe/src/parent/parent_gate.dart';
import 'package:alippe/src/parent/parent_session.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = ParentScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Баптаулар'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.isParent ? 'Қазір: ата-ана' : 'Қазір: бала',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              session.isParent
                  ? 'Суретті, дауысты және ертегіні өзгертуге болады. Қолданбаны жапқанда қайта бала режимі болады.'
                  : 'Өзгерту үшін ата-ана режиміне өтіңіз. Көбейту мысалын шешу керек.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                if (session.isParent) {
                  session.leave();
                  return;
                }
                final passed = await askParentGate(context);
                if (passed) session.enter();
              },
              child: Text(
                session.isParent ? 'Балаға оралу' : 'Ата-анаға өту',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

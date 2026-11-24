import 'dart:io';

import 'package:alippe/src/parent/media_override_store.dart';
import 'package:alippe/src/parent/parent_gate.dart';
import 'package:alippe/src/parent/parent_session.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(24),
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
            if (session.isParent) ...[
              const SizedBox(height: 28),
              const Text(
                'Әріптердің суреті мен дауысы',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ауыстырған сурет пен дауысты архивке салып, басқа құрылғыға көшіруге болады.',
              ),
              const SizedBox(height: 12),
              Builder(
                builder: (buttonContext) {
                  return OutlinedButton.icon(
                    onPressed: () => _exportLetters(buttonContext),
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Әріптерді экспорттау'),
                  );
                },
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _importLetters(context),
                icon: const Icon(Icons.file_download_outlined),
                label: const Text('Әріптерді импорттау'),
              ),
            ],
        ],
      ),
    );
  }
}

Future<void> _exportLetters(BuildContext context) async {
  final store = MediaOverrideStore.instance;
  await store.ensureLoaded();
  if (!context.mounted) return;
  if (!store.hasAny) {
    _message(context, 'Алдымен сурет немесе дауыс ауыстырыңыз');
    return;
  }
  try {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    final temp = await getTemporaryDirectory();
    final zip = await store.exportZip(temp);
    await Share.shareXFiles(
      [XFile(zip.path)],
      sharePositionOrigin: origin,
    );
  } catch (_) {
    if (!context.mounted) return;
    _message(context, 'Экспорт сәтсіз аяқталды');
  }
}

Future<void> _importLetters(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['zip'],
  );
  final path = result?.files.single.path;
  if (path == null || !context.mounted) return;
  try {
    final count = await MediaOverrideStore.instance.importZip(File(path));
    if (!context.mounted) return;
    _message(
      context,
      count == 0 ? 'Файлда әріп жоқ' : '$count әріп қосылды',
    );
  } catch (_) {
    if (!context.mounted) return;
    _message(context, 'Бұл файлды ашу мүмкін болмады');
  }
}

void _message(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

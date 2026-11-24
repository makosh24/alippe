import 'dart:io';

import 'package:alippe/src/parent/parent_session.dart';
import 'package:alippe/src/screens/FairyTalesScreen/builtin_tales.dart';
import 'package:alippe/src/screens/FairyTalesScreen/tale_editor_screen.dart';
import 'package:alippe/src/screens/FairyTalesScreen/tale_models.dart';
import 'package:alippe/src/screens/FairyTalesScreen/tale_reader_screen.dart';
import 'package:alippe/src/screens/FairyTalesScreen/tale_store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FairyTalesScreen extends StatefulWidget {
  static const String routeName = '/fairyTales';

  const FairyTalesScreen({Key? key}) : super(key: key);

  @override
  State<FairyTalesScreen> createState() => _FairyTalesScreenState();
}

class _FairyTalesScreenState extends State<FairyTalesScreen> {
  final TaleStore _store = TaleStore();
  List<CustomTale> _custom = [];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    try {
      final tales = await _store.load();
      if (!mounted) return;
      setState(() {
        _custom = tales;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _openEditor([CustomTale? existing]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TaleEditorScreen(store: _store, existing: existing),
      ),
    );
    if (saved == true) await _reload();
  }

  Future<void> _export(Rect? origin) async {
    if (_custom.isEmpty) {
      _message('Алдымен өз ертегіңді қос');
      return;
    }
    try {
      final temp = await getTemporaryDirectory();
      final zip = await _store.exportZip(temp);
      await Share.shareXFiles(
        [XFile(zip.path)],
        sharePositionOrigin: origin,
      );
    } catch (_) {
      if (!mounted) return;
      _message('Экспорт сәтсіз аяқталды');
    }
  }

  Future<void> _import() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    final path = result?.files.single.path;
    if (path == null) return;
    try {
      final count = await _store.importZip(File(path));
      await _reload();
      if (!mounted) return;
      _message(count == 0 ? 'Файлда ертегі жоқ' : '$count ертегі қосылды');
    } catch (_) {
      if (!mounted) return;
      _message('Бұл файлды ашу мүмкін болмады');
    }
  }

  Future<void> _delete(CustomTale tale) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ертегіні өшіру'),
          content: Text('«${tale.title}» өшсін бе?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Жоқ'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Өшіру'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    await _store.delete(tale.id);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final parent = ParentScope.of(context).isParent;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ертегілер'),
        backgroundColor: Colors.deepPurple,
        actions: [
          if (parent) ...[
            IconButton(
              tooltip: 'Ертегі қосу',
              onPressed: () => _openEditor(),
              icon: const Icon(Icons.add),
            ),
            Builder(
              builder: (buttonContext) {
                return IconButton(
                  tooltip: 'Экспорт',
                  onPressed: () {
                    final box = buttonContext.findRenderObject() as RenderBox?;
                    final origin = box == null
                        ? null
                        : box.localToGlobal(Offset.zero) & box.size;
                    _export(origin);
                  },
                  icon: const Icon(Icons.ios_share),
                );
              },
            ),
            IconButton(
              tooltip: 'Импорт',
              onPressed: _import,
              icon: const Icon(Icons.file_download_outlined),
            ),
          ],
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ертегіні таңда балақай!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  for (final tale in builtinTales)
                    _tile(
                      title: tale.title,
                      subtitle: tale.audioAsset == null
                          ? 'Дайын ертегі'
                          : 'Дайын ертегі, дыбысы бар',
                      onTap: () => _openBuiltin(tale),
                    ),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  for (final tale in _custom)
                    _tile(
                      title: tale.title,
                      subtitle: 'Өз ертегім',
                      onTap: () => _openCustom(tale),
                      onEdit: parent ? () => _openEditor(tale) : null,
                      onDelete: parent ? () => _delete(tale) : null,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Card(
      elevation: 5,
      color: Colors.white70,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        onTap: onTap,
        trailing: onDelete == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Өзгерту',
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: Colors.deepPurple),
                  ),
                  IconButton(
                    tooltip: 'Өшіру',
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
      ),
    );
  }

  void _openBuiltin(BuiltinTale tale) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaleReaderScreen(
          title: tale.title,
          text: tale.text,
          audioAsset: tale.audioAsset,
        ),
      ),
    );
  }

  Future<void> _openCustom(CustomTale tale) async {
    final path = await _store.audioPathFor(tale);
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaleReaderScreen(
          title: tale.title,
          text: tale.text,
          audioFile: path,
        ),
      ),
    );
  }
}

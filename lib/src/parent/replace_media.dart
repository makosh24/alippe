import 'dart:io';

import 'package:alippe/src/parent/media_override_store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<void> replaceWordMedia(BuildContext context, String id) async {
  final choice = await showModalBottomSheet<String>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Суретті ауыстыру'),
              onTap: () => Navigator.pop(sheetContext, 'image'),
            ),
            ListTile(
              leading: const Icon(Icons.mic),
              title: const Text('Дауысты ауыстыру'),
              onTap: () => Navigator.pop(sheetContext, 'audio'),
            ),
          ],
        ),
      );
    },
  );
  if (choice == null || !context.mounted) return;
  if (choice == 'image') {
    await _pick(context, id, image: true);
  } else {
    await _pick(context, id, image: false);
  }
}

Future<void> replaceAudio(BuildContext context, String id) {
  return _pick(context, id, image: false);
}

Future<void> _pick(
  BuildContext context,
  String id, {
  required bool image,
}) async {
  final result = await FilePicker.platform.pickFiles(
    type: image ? FileType.image : FileType.audio,
  );
  final path = result?.files.single.path;
  if (path == null) return;
  final copy = File(
    '${Directory.systemTemp.path}/alippe-media-${DateTime.now().microsecondsSinceEpoch}${_extension(path)}',
  );
  await File(path).copy(copy.path);
  if (image) {
    await MediaOverrideStore.instance.setImage(id, copy.path);
  } else {
    await MediaOverrideStore.instance.setAudio(id, copy.path);
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(image ? 'Сурет сақталды' : 'Дауыс сақталды')),
  );
}

String _extension(String path) {
  final name = path.split(Platform.pathSeparator).last;
  final dot = name.lastIndexOf('.');
  if (dot < 0) return '';
  return name.substring(dot);
}

import 'dart:convert';
import 'dart:io';

import 'package:alippe/src/screens/FairyTalesScreen/builtin_tales.dart';
import 'package:alippe/src/screens/FairyTalesScreen/tale_store.dart';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('built-in tales include the duck story and several more', () {
    expect(builtinTales.length, greaterThanOrEqualTo(5));
    expect(
      builtinTales.map((tale) => tale.title),
      contains('Үйрек туралы ертегі'),
    );
    expect(builtinTales.first.audioAsset, 'audio/uirekFairy.wav');
  });

  test('custom tales survive export and import', () async {
    final sourceDir = await Directory.systemTemp.createTemp('alippe-src');
    final otherDir = await Directory.systemTemp.createTemp('alippe-dst');
    final exportDir = await Directory.systemTemp.createTemp('alippe-zip');
    final audio = File('${sourceDir.path}/voice.wav')
      ..writeAsStringSync('not-a-real-wav');

    final source = TaleStore(directory: sourceDir);
    final saved = await source.save(
      title: 'Менің ертегім',
      text: 'Баяғыда...',
      newAudioPath: audio.path,
    );
    expect(saved.audioFileName, endsWith('.wav'));

    final zip = await source.exportZip(exportDir);
    final importedCount = await TaleStore(directory: otherDir).importZip(zip);
    expect(importedCount, 1);

    final restored = await TaleStore(directory: otherDir).load();
    expect(restored, hasLength(1));
    expect(restored.single.title, 'Менің ертегім');
    expect(restored.single.text, 'Баяғыда...');
    final restoredAudio = File(
      '${otherDir.path}/audio/${restored.single.audioFileName}',
    );
    expect(restoredAudio.readAsStringSync(), 'not-a-real-wav');
  });

  test('import ignores audio names that leave the folder', () async {
    final dir = await Directory.systemTemp.createTemp('alippe-bad');
    final store = TaleStore(directory: dir);
    final zip = File('${dir.path}/bad.zip');
    final archiveBytes = _zipWithTraversal();
    await zip.writeAsBytes(archiveBytes);

    final count = await store.importZip(zip);
    expect(count, 0);
    expect(await store.load(), isEmpty);
    expect(File('${dir.path}/secret.wav').existsSync(), isFalse);
  });
}

List<int> _zipWithTraversal() {
  final archive = Archive();
  final index = utf8.encode(jsonEncode({
    'version': 1,
    'tales': [
      {
        'id': 'bad',
        'title': 'Жаман',
        'text': 'жоқ',
        'audioFileName': '../secret.wav',
      }
    ],
  }));
  archive.addFile(ArchiveFile('tales.json', index.length, index));
  const audio = [1, 2, 3];
  archive.addFile(ArchiveFile('audio/../secret.wav', audio.length, audio));
  return ZipEncoder().encode(archive)!;
}

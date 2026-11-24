import 'dart:io';

import 'package:alippe/src/parent/media_override_store.dart';
import 'package:alippe/src/parent/parent_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parent mode starts off and resets only when asked', () {
    final session = ParentSession();
    expect(session.isParent, isFalse);
    session.enter();
    expect(session.isParent, isTrue);
    session.enter();
    expect(session.isParent, isTrue);
    session.leave();
    expect(session.isParent, isFalse);
  });

  test('multiplication gate accepts only the product', () {
    expect(isRightProduct(7, 8, '56'), isTrue);
    expect(isRightProduct(7, 8, ' 56 '), isTrue);
    expect(isRightProduct(7, 8, '55'), isFalse);
    expect(isRightProduct(7, 8, 'жеті'), isFalse);
    expect(isRightProduct(6, 9, ''), isFalse);
  });

  test('saved picture and voice replace the originals', () async {
    final dir = await Directory.systemTemp.createTemp('alippe-media');
    final store = MediaOverrideStore(directory: dir);
    final image = File('${dir.path}/new.png')..writeAsStringSync('picture');
    final audio = File('${dir.path}/new.wav')..writeAsStringSync('voice');

    await store.setImage('alma', image.path);
    await store.setAudio('a', audio.path);

    expect(File(store.imagePath('alma')!).readAsStringSync(), 'picture');
    expect(File(store.audioPath('a')!).readAsStringSync(), 'voice');

    final reloaded = MediaOverrideStore(directory: dir);
    await reloaded.ensureLoaded();
    expect(File(reloaded.imagePath('alma')!).readAsStringSync(), 'picture');
    expect(reloaded.audioPath('zhailau'), isNull);
  });

  test('letter picture and voice survive export and import', () async {
    final sourceDir = await Directory.systemTemp.createTemp('alippe-src');
    final otherDir = await Directory.systemTemp.createTemp('alippe-dst');
    final exportDir = await Directory.systemTemp.createTemp('alippe-zip');
    final image = File('${sourceDir.path}/new.png')..writeAsStringSync('picture');
    final audio = File('${sourceDir.path}/new.wav')..writeAsStringSync('voice');

    final source = MediaOverrideStore(directory: sourceDir);
    await source.setImage('alma', image.path);
    await source.setAudio('a', audio.path);
    final zip = await source.exportZip(exportDir);

    final imported = await MediaOverrideStore(directory: otherDir).importZip(zip);
    expect(imported, 2);
    final restored = MediaOverrideStore(directory: otherDir);
    await restored.ensureLoaded();
    expect(File(restored.imagePath('alma')!).readAsStringSync(), 'picture');
    expect(File(restored.audioPath('a')!).readAsStringSync(), 'voice');
  });
}

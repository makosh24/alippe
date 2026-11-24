import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:alippe/src/screens/FairyTalesScreen/tale_models.dart';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

class TaleStore {
  TaleStore({this.directory});

  final Directory? directory;

  Future<Directory> _root() async {
    final Directory base;
    if (directory != null) {
      base = directory!;
    } else {
      final docs = await getApplicationDocumentsDirectory();
      base = Directory('${docs.path}/fairy_tales');
    }
    final audio = Directory('${base.path}/audio');
    if (!audio.existsSync()) {
      audio.createSync(recursive: true);
    }
    return base;
  }

  File _indexFile(Directory root) => File('${root.path}/tales.json');

  Future<List<CustomTale>> load() async {
    final root = await _root();
    final file = _indexFile(root);
    if (!file.existsSync()) return [];
    final decoded = jsonDecode(await file.readAsString());
    return _readTales(decoded);
  }

  Future<CustomTale> save({
    String? id,
    required String title,
    required String text,
    String? newAudioPath,
    String? previousAudioFileName,
  }) async {
    final root = await _root();
    final tales = await load();
    final taleId = id ?? _newId();
    var audioName = previousAudioFileName;
    if (newAudioPath != null && newAudioPath.isNotEmpty) {
      audioName = await _copyAudio(root, taleId, newAudioPath);
      if (previousAudioFileName != null &&
          previousAudioFileName != audioName) {
        _deleteAudio(root, previousAudioFileName);
      }
    }
    final tale = CustomTale(
      id: taleId,
      title: title.trim(),
      text: text.trim(),
      audioFileName: audioName,
    );
    final index = tales.indexWhere((item) => item.id == taleId);
    if (index >= 0) {
      tales[index] = tale;
    } else {
      tales.add(tale);
    }
    await _write(root, tales);
    return tale;
  }

  Future<void> delete(String id) async {
    final root = await _root();
    final tales = await load();
    CustomTale? removed;
    for (final tale in tales) {
      if (tale.id == id) removed = tale;
    }
    tales.removeWhere((tale) => tale.id == id);
    if (removed?.audioFileName != null) {
      _deleteAudio(root, removed!.audioFileName!);
    }
    await _write(root, tales);
  }

  Future<String?> audioPathFor(CustomTale tale) async {
    final name = tale.audioFileName;
    if (name == null || !_safeAudioName(name)) return null;
    final root = await _root();
    final file = File('${root.path}/audio/$name');
    if (!file.existsSync()) return null;
    return file.path;
  }

  Future<File> exportZip(Directory destination) async {
    final root = await _root();
    final tales = await load();
    final archive = Archive();
    final indexBytes = utf8.encode(jsonEncode({
      'version': 1,
      'tales': tales.map((tale) => tale.toJson()).toList(),
    }));
    archive.addFile(ArchiveFile('tales.json', indexBytes.length, indexBytes));
    for (final tale in tales) {
      final name = tale.audioFileName;
      if (name == null || !_safeAudioName(name)) continue;
      final file = File('${root.path}/audio/$name');
      if (!file.existsSync()) continue;
      final bytes = await file.readAsBytes();
      archive.addFile(ArchiveFile('audio/$name', bytes.length, bytes));
    }
    final encoded = ZipEncoder().encode(archive);
    if (encoded == null) {
      throw const FormatException('Мұрағат жасалмады');
    }
    if (!destination.existsSync()) {
      destination.createSync(recursive: true);
    }
    final out = File('${destination.path}/alippe-tales.zip');
    await out.writeAsBytes(encoded, flush: true);
    return out;
  }

  Future<int> importZip(File zipFile) async {
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    ArchiveFile? index;
    for (final file in archive) {
      final name = file.name.replaceAll('\\', '/');
      if (name == 'tales.json') index = file;
    }
    if (index == null) {
      throw const FormatException('Бұл Alippe ертегілерінің файлы емес');
    }
    final content = index.content;
    if (content is! List<int>) {
      throw const FormatException('Бұл Alippe ертегілерінің файлы емес');
    }
    final decoded = jsonDecode(utf8.decode(content));
    final incoming = _readTales(decoded);
    if (incoming.isEmpty) return 0;

    final root = await _root();
    final tales = await load();
    var added = 0;
    for (final tale in incoming) {
      final audioName = tale.audioFileName;
      if (audioName != null && !_safeAudioName(audioName)) continue;
      if (audioName != null) {
        final packed = _audioInArchive(archive, audioName);
        if (packed == null) continue;
        final packedBytes = packed.content;
        if (packedBytes is! List<int>) continue;
        await File('${root.path}/audio/$audioName').writeAsBytes(packedBytes);
      }
      final indexOfExisting = tales.indexWhere((item) => item.id == tale.id);
      if (indexOfExisting >= 0) {
        tales[indexOfExisting] = tale;
      } else {
        tales.add(tale);
      }
      added++;
    }
    await _write(root, tales);
    return added;
  }

  List<CustomTale> _readTales(Object? decoded) {
    final Object? rawTales;
    if (decoded is List) {
      rawTales = decoded;
    } else if (decoded is Map && decoded['tales'] is List) {
      rawTales = decoded['tales'];
    } else {
      return [];
    }
    return [
      for (final item in rawTales as List)
        if (CustomTale.fromJson(item) != null) CustomTale.fromJson(item)!,
    ];
  }

  ArchiveFile? _audioInArchive(Archive archive, String audioName) {
    for (final file in archive) {
      final name = file.name.replaceAll('\\', '/');
      if (name == 'audio/$audioName') return file;
    }
    return null;
  }

  Future<void> _write(Directory root, List<CustomTale> tales) async {
    final payload = jsonEncode({
      'version': 1,
      'tales': tales.map((tale) => tale.toJson()).toList(),
    });
    await _indexFile(root).writeAsString(payload);
  }

  Future<String> _copyAudio(Directory root, String id, String sourcePath) async {
    final ext = _extension(sourcePath);
    final name = '$id$ext';
    if (!_safeAudioName(name)) {
      throw const FormatException('Аудио файлының аты жарамсыз');
    }
    await File(sourcePath).copy('${root.path}/audio/$name');
    return name;
  }

  void _deleteAudio(Directory root, String name) {
    if (!_safeAudioName(name)) return;
    final file = File('${root.path}/audio/$name');
    if (file.existsSync()) file.deleteSync();
  }

  String _extension(String path) {
    final name = path.split(Platform.pathSeparator).last;
    final dot = name.lastIndexOf('.');
    if (dot < 0) return '.m4a';
    final ext = name.substring(dot).toLowerCase();
    const allowed = ['.mp3', '.wav', '.m4a', '.aac', '.mp4', '.caf'];
    return allowed.contains(ext) ? ext : '.m4a';
  }

  bool _safeAudioName(String name) {
    return !name.contains('/') &&
        !name.contains('\\') &&
        !name.contains('..') &&
        name.isNotEmpty;
  }

  String _newId() {
    final random = Random().nextInt(1 << 32);
    return '${DateTime.now().microsecondsSinceEpoch}-$random';
  }
}

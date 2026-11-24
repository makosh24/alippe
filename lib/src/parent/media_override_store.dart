import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class MediaOverride {
  final String? imageFile;
  final String? audioFile;

  const MediaOverride({this.imageFile, this.audioFile});

  MediaOverride copyWith({String? imageFile, String? audioFile}) {
    return MediaOverride(
      imageFile: imageFile ?? this.imageFile,
      audioFile: audioFile ?? this.audioFile,
    );
  }
}

class MediaOverrideStore extends ChangeNotifier {
  MediaOverrideStore({this.directory});

  static final MediaOverrideStore instance = MediaOverrideStore();

  final Directory? directory;
  final Map<String, MediaOverride> _items = {};
  Directory? _resolved;
  Future<void>? _loading;

  Future<void> ensureLoaded() {
    return _loading ??= _read();
  }

  String? imagePath(String id) => _absolute(_items[id]?.imageFile);

  String? audioPath(String id) => _absolute(_items[id]?.audioFile);

  Future<void> setImage(String id, String sourcePath) async {
    await _save(id, sourcePath, image: true);
  }

  Future<void> setAudio(String id, String sourcePath) async {
    await _save(id, sourcePath, image: false);
  }

  Future<void> _save(String id, String sourcePath, {required bool image}) async {
    await ensureLoaded();
    final root = await _root();
    final ext = _extension(sourcePath, image: image);
    final name = '${_safe(id)}-${image ? 'image' : 'audio'}$ext';
    final previous = image ? _items[id]?.imageFile : _items[id]?.audioFile;
    await File(sourcePath).copy('${root.path}/$name');
    if (previous != null && previous != name) {
      final old = File('${root.path}/$previous');
      if (old.existsSync()) old.deleteSync();
    }
    final current = _items[id] ?? const MediaOverride();
    _items[id] = image
        ? current.copyWith(imageFile: name)
        : current.copyWith(audioFile: name);
    await _write(root);
    notifyListeners();
  }

  Future<void> _read() async {
    final root = await _root();
    final file = File('${root.path}/overrides.json');
    if (!file.existsSync()) return;
    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map) return;
    decoded.forEach((key, value) {
      if (key is! String || value is! Map) return;
      final image = value['image'];
      final audio = value['audio'];
      _items[key] = MediaOverride(
        imageFile: image is String && image.isNotEmpty ? image : null,
        audioFile: audio is String && audio.isNotEmpty ? audio : null,
      );
    });
  }

  Future<void> _write(Directory root) async {
    final payload = {
      for (final entry in _items.entries)
        entry.key: {
          'image': entry.value.imageFile,
          'audio': entry.value.audioFile,
        },
    };
    await File('${root.path}/overrides.json').writeAsString(jsonEncode(payload));
  }

  Future<Directory> _root() async {
    final cached = _resolved;
    if (cached != null) return cached;
    final Directory base;
    if (directory != null) {
      base = directory!;
    } else {
      final docs = await getApplicationDocumentsDirectory();
      base = Directory('${docs.path}/media_overrides');
    }
    if (!base.existsSync()) base.createSync(recursive: true);
    _resolved = base;
    return base;
  }

  String? _absolute(String? name) {
    if (name == null || name.contains('/') || name.contains('\\') || name.contains('..')) {
      return null;
    }
    final root = _resolved;
    if (root == null) return null;
    final file = File('${root.path}/$name');
    return file.existsSync() ? file.path : null;
  }

  String _extension(String path, {required bool image}) {
    final name = path.split(Platform.pathSeparator).last;
    final dot = name.lastIndexOf('.');
    final ext = dot < 0 ? '' : name.substring(dot).toLowerCase();
    const images = ['.png', '.jpg', '.jpeg', '.webp', '.gif'];
    const audios = ['.mp3', '.wav', '.m4a', '.aac', '.mp4', '.caf'];
    final allowed = image ? images : audios;
    if (allowed.contains(ext)) return ext;
    return image ? '.png' : '.m4a';
  }

  String _safe(String id) => id.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
}

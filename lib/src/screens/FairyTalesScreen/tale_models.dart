class BuiltinTale {
  final String title;
  final String text;
  final String? audioAsset;

  const BuiltinTale({
    required this.title,
    required this.text,
    this.audioAsset,
  });
}

class CustomTale {
  final String id;
  final String title;
  final String text;
  final String? audioFileName;

  const CustomTale({
    required this.id,
    required this.title,
    required this.text,
    this.audioFileName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'audioFileName': audioFileName,
    };
  }

  static CustomTale? fromJson(Object? value) {
    if (value is! Map) return null;
    final id = value['id'];
    final title = value['title'];
    final text = value['text'];
    final audio = value['audioFileName'];
    if (id is! String || title is! String || text is! String) return null;
    if (id.isEmpty || title.trim().isEmpty) return null;
    if (audio != null && audio is! String) return null;
    return CustomTale(
      id: id,
      title: title.trim(),
      text: text,
      audioFileName: audio == null || audio.isEmpty ? null : audio,
    );
  }
}

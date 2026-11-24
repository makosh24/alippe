import 'dart:io';

import 'package:alippe/src/screens/FairyTalesScreen/tale_models.dart';
import 'package:alippe/src/screens/FairyTalesScreen/tale_store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TaleEditorScreen extends StatefulWidget {
  final TaleStore store;
  final CustomTale? existing;

  const TaleEditorScreen({
    Key? key,
    required this.store,
    this.existing,
  }) : super(key: key);

  @override
  State<TaleEditorScreen> createState() => _TaleEditorScreenState();
}

class _TaleEditorScreenState extends State<TaleEditorScreen> {
  late final TextEditingController _title;
  late final TextEditingController _text;
  String? _pickedAudioPath;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.existing?.title ?? '');
    _text = TextEditingController(text: widget.existing?.text ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _text.dispose();
    super.dispose();
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    final path = result?.files.single.path;
    if (path == null) return;
    final source = File(path);
    final copy = File(
      '${Directory.systemTemp.path}/alippe-pick-${DateTime.now().microsecondsSinceEpoch}${_extension(path)}',
    );
    await source.copy(copy.path);
    if (!mounted) return;
    setState(() => _pickedAudioPath = copy.path);
  }

  String _extension(String path) {
    final name = path.split(Platform.pathSeparator).last;
    final dot = name.lastIndexOf('.');
    if (dot < 0) return '.m4a';
    return name.substring(dot);
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    final text = _text.text.trim();
    final hasAudio =
        _pickedAudioPath != null || widget.existing?.audioFileName != null;
    if (title.isEmpty || text.isEmpty || !hasAudio) {
      _showMessage('Атын, мәтінін және аудионы толтыр');
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.store.save(
        id: widget.existing?.id,
        title: title,
        text: text,
        newAudioPath: _pickedAudioPath,
        previousAudioFileName: widget.existing?.audioFileName,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showMessage('Сақтау сәтсіз аяқталды');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final audioLabel = _pickedAudioPath != null
        ? _pickedAudioPath!.split(Platform.pathSeparator).last
        : (widget.existing?.audioFileName ?? 'Аудио таңдалмаған');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Жаңа ертегі' : 'Ертегіні өзгерту'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7E57C2), Color(0xFF3949AB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _title,
                decoration: _field('Аты'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _text,
                minLines: 5,
                maxLines: 8,
                decoration: _field('Мәтіні'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      audioLabel,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  FilledButton(
                    onPressed: _saving ? null : _pickAudio,
                    child: const Text('Аудио таңдау'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Сақталуда...' : 'Сақтау'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _field(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

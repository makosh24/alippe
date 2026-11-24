import 'dart:async';

import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:alippe/src/screens/FairyTalesScreen/tale_highlight.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Full-screen tale. The current word is lit while the voice, or a
/// steady reading pace, moves through the text.
class TaleReaderScreen extends StatefulWidget {
  final String title;
  final String text;
  final String? audioAsset;
  final String? audioFile;

  const TaleReaderScreen({
    super.key,
    required this.title,
    required this.text,
    this.audioAsset,
    this.audioFile,
  });

  @override
  State<TaleReaderScreen> createState() => _TaleReaderScreenState();
}

class _TaleReaderScreenState extends State<TaleReaderScreen> {
  final AudioPlayer _player = AudioPlayer();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final Stopwatch _readClock = Stopwatch();
  late final List<TalePiece> _pieces;
  late final List<int> _weights;
  Timer? _clock;
  var _playing = false;
  var _active = -1;
  var _durationMs = 0;
  var _elapsedMs = 0;
  var _readBaseMs = 0;

  Source? get _audio {
    final asset = widget.audioAsset;
    if (asset != null) return AssetSource(asset);
    final file = widget.audioFile;
    if (file != null) return DeviceFileSource(file);
    return null;
  }

  @override
  void initState() {
    super.initState();
    _pieces = splitTale(widget.text);
    _weights = [for (final piece in _pieces) if (piece.isWord) piece.weight];
    _subscriptions.add(_player.onDurationChanged.listen((duration) {
      _durationMs = duration.inMilliseconds;
      if (_playing || _player.state == PlayerState.playing) {
        _showAt(_elapsedMs, _durationMs);
      }
    }));
    _subscriptions.add(_player.onPositionChanged.listen((position) {
      _elapsedMs = position.inMilliseconds;
      if (!_playing && _player.state != PlayerState.playing) return;
      _showAt(_elapsedMs, _durationMs);
    }));
    _subscriptions.add(_player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      _showAt(_durationMs, _durationMs);
      setState(() => _playing = false);
    }));
    if (_audio != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  Future<void> _start() async {
    await SoundService.instance.stopSound();
    if (!mounted) return;
    final audio = _audio;
    if (audio == null) return;
    await _player.play(audio);
    if (!mounted) return;
    _markPlaying();
  }

  @override
  void dispose() {
    _clock?.cancel();
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  void _showAt(int elapsedMs, int durationMs) {
    final next = wordIndexAt(
      elapsedMs: elapsedMs,
      durationMs: durationMs,
      weights: _weights,
    );
    if (next == _active) return;
    if (!mounted) return;
    setState(() => _active = next);
  }

  void _markPlaying() {
    setState(() {
      _playing = true;
      if (_active < 0 && _weights.isNotEmpty) _active = 0;
    });
  }

  void _tickReading() {
    final duration = taleReadingDurationMs(_weights);
    final elapsed = _readBaseMs + _readClock.elapsedMilliseconds;
    if (duration <= 0 || elapsed >= duration) {
      _clock?.cancel();
      _readClock.stop();
      _readBaseMs = duration;
      _showAt(duration, duration);
      if (!mounted) return;
      setState(() => _playing = false);
      return;
    }
    _showAt(elapsed, duration);
  }

  void _pauseReading() {
    _readBaseMs += _readClock.elapsedMilliseconds;
    _readClock
      ..stop()
      ..reset();
    _clock?.cancel();
    setState(() => _playing = false);
  }

  void _resumeReading() {
    final duration = taleReadingDurationMs(_weights);
    if (_readBaseMs >= duration) {
      _readBaseMs = 0;
      _active = -1;
    }
    _readClock
      ..reset()
      ..start();
    _clock?.cancel();
    _clock = Timer.periodic(
      const Duration(milliseconds: 80),
      (_) => _tickReading(),
    );
    _markPlaying();
    _tickReading();
  }

  Future<void> _toggle() async {
    final audio = _audio;
    if (audio == null) {
      if (_playing) {
        _pauseReading();
      } else {
        _resumeReading();
      }
      return;
    }
    if (_playing) {
      await _player.pause();
      if (!mounted) return;
      setState(() => _playing = false);
      return;
    }
    if (_player.state == PlayerState.paused) {
      await _player.resume();
    } else {
      await _player.play(audio);
    }
    if (!mounted) return;
    _markPlaying();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: Color(0xFF311B92),
      fontSize: 22,
      height: 1.45,
    );
    var word = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            tooltip: _playing ? 'Тоқтату' : 'Оқу',
            onPressed: _toggle,
            icon: Icon(_playing ? Icons.pause_circle : Icons.play_circle),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6E8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Text.rich(
                    TextSpan(
                      style: style,
                      children: [
                        for (final piece in _pieces)
                          if (!piece.isWord)
                            TextSpan(text: piece.text)
                          else
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: _TaleWord(
                                text: piece.text,
                                active: word++ == _active,
                                style: style,
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaleWord extends StatefulWidget {
  final String text;
  final bool active;
  final TextStyle style;

  const _TaleWord({
    required this.text,
    required this.active,
    required this.style,
  });

  @override
  State<_TaleWord> createState() => _TaleWordState();
}

class _TaleWordState extends State<_TaleWord> {
  @override
  void initState() {
    super.initState();
    if (widget.active) _reveal();
  }

  @override
  void didUpdateWidget(covariant _TaleWord oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) _reveal();
  }

  void _reveal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = context.findRenderObject();
      final viewport = Scrollable.maybeOf(context)?.context.findRenderObject();
      if (box is RenderBox &&
          box.hasSize &&
          viewport is RenderBox &&
          viewport.hasSize) {
        final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
        final bottom = top + box.size.height;
        const margin = 12.0;
        if (top >= margin && bottom <= viewport.size.height - margin) return;
      }
      Scrollable.ensureVisible(
        context,
        alignment: 0.3,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: widget.active
          ? widget.style.copyWith(
              backgroundColor: const Color(0xFFFFD54F),
              fontWeight: FontWeight.w800,
            )
          : widget.style,
    );
  }
}

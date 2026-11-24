import 'dart:io';

import 'package:alippe/src/components/AlphabetsComponents/media_names.dart';
import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:alippe/src/parent/media_override_store.dart';
import 'package:alippe/src/parent/parent_session.dart';
import 'package:alippe/src/parent/replace_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class IconButtonImageShow extends StatefulWidget {
  final String imageAsset;
  final String imageText;
  final Color accent;

  const IconButtonImageShow({
    Key? key,
    required this.imageAsset,
    required this.imageText,
    required this.accent,
  }) : super(key: key);

  @override
  State<IconButtonImageShow> createState() => _IconButtonImageShowState();
}

class _IconButtonImageShowState extends State<IconButtonImageShow> {
  String? _pngId;
  String? _lottieId;
  String? _overrideImage;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<bool> _exists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _resolve() async {
    await MediaOverrideStore.instance.ensureLoaded();
    final override = MediaOverrideStore.instance.imagePath(widget.imageAsset);
    String? pngId;
    String? lottieId;
    for (final candidate in imageCandidates(widget.imageAsset)) {
      if (pngId == null &&
          await _exists('assets/images/predmets/$candidate.png')) {
        pngId = candidate;
      }
      if (lottieId == null &&
          await _exists('assets/images/predmets/$candidate.json')) {
        lottieId = candidate;
      }
    }
    if (!mounted) return;
    setState(() {
      _overrideImage = override;
      _pngId = pngId;
      _lottieId = lottieId;
      _ready = true;
    });
  }

  Future<void> _play() async {
    await SoundService.instance.playTapDownSound(widget.imageAsset);
  }

  Widget _picture({required bool enlarged}) {
    final override = _overrideImage;
    if (override != null) {
      return Image.file(
        File(override),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _titleFallback(),
      );
    }
    final pngId = _pngId;
    final lottieId = _lottieId;
    if (pngId != null) {
      return Image.asset(
        'assets/images/predmets/$pngId.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _titleFallback(),
      );
    }
    if (lottieId != null) {
      return Lottie.asset(
        'assets/images/predmets/$lottieId.json',
        fit: BoxFit.contain,
        repeat: enlarged,
      );
    }
    return _titleFallback();
  }

  Widget _titleFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.imageText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: widget.accent,
            ),
          ),
        ),
      ),
    );
  }

  void _open() {
    _play();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;
        return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            width: size.width * 0.62,
            height: size.height * 0.86,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.redAccent,
                    iconSize: 48,
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ),
                if (widget.imageText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.imageText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: widget.accent,
                      ),
                    ),
                  ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: _play,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: _picture(enlarged: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Material(
            color: const Color(0xFFFFF8E8),
            elevation: 8,
            shadowColor: widget.accent.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: _ready ? _open : null,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: widget.accent, width: 4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _ready
                      ? _picture(enlarged: false)
                      : const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    widget.imageText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF16324F),
                    ),
                  ),
                ),
              ),
            ),
            if (ParentScope.of(context).isParent)
              IconButton(
                tooltip: 'Өзгерту',
                onPressed: () async {
                  await replaceWordMedia(context, widget.imageAsset);
                  if (mounted) await _resolve();
                },
                icon: const Icon(Icons.edit, color: Colors.white),
              ),
          ],
        ),
      ],
    );
  }
}

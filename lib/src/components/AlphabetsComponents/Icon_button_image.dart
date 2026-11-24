import 'package:alippe/src/components/AlphabetsComponents/media_names.dart';
import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class IconButtonImageShow extends StatefulWidget {
  final String imageAsset;
  final String imageText;

  const IconButtonImageShow({
    Key? key,
    required this.imageAsset,
    required this.imageText,
  }) : super(key: key);

  @override
  State<IconButtonImageShow> createState() => _IconButtonImageShowState();
}

class _IconButtonImageShowState extends State<IconButtonImageShow> {
  String? _resolvedId;
  bool _isLottie = false;
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
    for (final candidate in imageCandidates(widget.imageAsset)) {
      final jsonPath = 'assets/images/predmets/$candidate.json';
      final pngPath = 'assets/images/predmets/$candidate.png';
      if (await _exists(jsonPath)) {
        if (!mounted) return;
        setState(() {
          _resolvedId = candidate;
          _isLottie = true;
          _ready = true;
        });
        return;
      }
      if (await _exists(pngPath)) {
        if (!mounted) return;
        setState(() {
          _resolvedId = candidate;
          _isLottie = false;
          _ready = true;
        });
        return;
      }
    }
    if (!mounted) return;
    setState(() => _ready = true);
  }

  Future<void> _play() async {
    await SoundService.instance.playTapDownSound(widget.imageAsset);
  }

  Widget _picture({required BoxFit fit}) {
    final id = _resolvedId;
    if (id == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.imageText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
    if (_isLottie) {
      return Lottie.asset(
        'assets/images/predmets/$id.json',
        fit: fit,
      );
    }
    return Image.asset(
      'assets/images/predmets/$id.png',
      fit: fit,
    );
  }

  void _open() {
    _play();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(dialogContext).size.width * 0.7,
            height: MediaQuery.of(dialogContext).size.height * 0.8,
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
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        widget.imageText,
                        textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: const [
                          Colors.red,
                          Colors.blue,
                          Colors.yellow,
                          Colors.green,
                        ],
                        speed: const Duration(milliseconds: 500),
                      ),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: _play,
                    child: _picture(fit: BoxFit.contain),
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
    return Container(
      width: 140,
      height: 140,
      decoration: const BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.circle,
      ),
      child: _ready
          ? InkWell(
              customBorder: const CircleBorder(),
              onTap: _open,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _picture(fit: BoxFit.contain),
              ),
            )
          : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

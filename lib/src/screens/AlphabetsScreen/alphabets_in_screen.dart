import 'package:alippe/src/components/AlphabetsComponents/Icon_button_image.dart';
import 'package:alippe/src/components/AlphabetsComponents/aquarium_background.dart';
import 'package:alippe/src/components/AlphabetsComponents/ccard.dart';
import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:alippe/src/locale/strings_of_app.dart';
import 'package:alippe/src/screens/AlphabetsScreen/alphabets.dart';
import 'package:flutter/material.dart';

class AlphabetsInScreen extends StatefulWidget {
  static const routeName = '/extractArgument';

  const AlphabetsInScreen({Key? key}) : super(key: key);

  @override
  State<AlphabetsInScreen> createState() => _AlphabetsInScreenState();
}

class _AlphabetsInScreenState extends State<AlphabetsInScreen> {
  @override
  void dispose() {
    SoundService.instance.stopSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Alphabets) {
      return Scaffold(
        body: Center(
          child: IconButton(
            iconSize: 72,
            color: Colors.red,
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      );
    }

    final colorIndex = alphabets.indexWhere((letter) => letter.name == args.name);
    final color = Colors.primaries[
        (colorIndex < 0 ? 0 : colorIndex) % Colors.primaries.length];

    return Scaffold(
      body: AquariumBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _wordSlot(args, 0),
                    Center(
                      child: CCard(
                        letter: args.name,
                        smallLetter: '',
                        color: color,
                        filled: false,
                        callback: () {
                          SoundService.instance.playTapDownSound(args.sound);
                        },
                      ),
                    ),
                    _wordSlot(args, 1),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    _wordSlot(args, 2),
                    _letterBadge(
                      IconButton(
                        icon: const Icon(Icons.exit_to_app_outlined),
                        iconSize: 72,
                        color: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    _wordSlot(args, 3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _letterBadge(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _wordSlot(Alphabets letter, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        child: index >= letter.words.length
            ? const SizedBox.shrink()
            : IconButtonImageShow(
                imageAsset: letter.words[index].id,
                imageText: letter.words[index].title,
                accent: Colors.primaries[index % Colors.primaries.length],
              ),
      ),
    );
  }
}

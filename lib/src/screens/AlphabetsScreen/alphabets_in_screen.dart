import 'package:alippe/src/components/AlphabetsComponents/Icon_button_image.dart';
import 'package:alippe/src/components/AlphabetsComponents/ccard.dart';
import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:alippe/src/locale/strings_of_app.dart';
import 'package:alippe/src/screens/AlphabetsScreen/alphabets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: FractionalTranslation(
                translation: const Offset(0, -0.6),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Lottie.asset(
                    "assets/images/blue-aquarium.json",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _wordSlot(args, 0),
                        CCard(
                          letter: args.name,
                          smallLetter: '',
                          color: color,
                          callback: () {
                            SoundService.instance.playTapDownSound(args.sound);
                          },
                        ),
                        _wordSlot(args, 1),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _wordSlot(args, 2),
                        IconButton(
                          icon: const Icon(Icons.exit_to_app_outlined),
                          iconSize: 72,
                          color: Colors.red,
                          onPressed: () => Navigator.pop(context),
                        ),
                        _wordSlot(args, 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wordSlot(Alphabets letter, int index) {
    if (index >= letter.words.length) {
      return const SizedBox(width: 140, height: 140);
    }
    final word = letter.words[index];
    return IconButtonImageShow(
      imageAsset: word.id,
      imageText: word.title,
    );
  }
}

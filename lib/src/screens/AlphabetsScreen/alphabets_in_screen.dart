import 'package:alippe/src/components/AlphabetsComponents/Icon_button_image.dart';
import 'package:alippe/src/components/AlphabetsComponents/ccard.dart';
import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'alphabet_arguments.dart';

class AlphabetsInScreen extends StatefulWidget {
  static const routeName = '/extractArgument';

  const AlphabetsInScreen({Key? key}) : super(key: key);
  @override
  State<AlphabetsInScreen> createState() => _AlphabetsInScreenState();
}

class _AlphabetsInScreenState extends State<AlphabetsInScreen> {
  @override
  void initState() {
    SoundService.instance.loadSounds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as AlphabetArguments;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage("assets/images/backgroundTree.jpeg"),
            //     fit: BoxFit.cover)
            color: Colors.white),
        child: Stack(
          children: [
            Container(
              color: Colors.amber,
              child: Align(
                alignment: Alignment.topCenter,
                // heightFactor: 0.5,
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
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButtonImageShow(
                      imageAsset: args.image1,
                      isJson: true,
                    ),
                    CCard(
                      letter: args.title,
                      smallLetter: '',
                      callback: () async {
                        await SoundService.instance
                            .playTapDownSound(args.soundLetter);
                      },
                      soundLetter: '',
                    ),
                    IconButtonImageShow(
                      imageAsset: args.image2,
                      isJson: true,
                    )
                  ],
                ),
                // Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButtonImageShow(
                      imageAsset: args.image3,
                      isJson: false,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.exit_to_app_outlined,
                      ),
                      iconSize: 100,
                      color: Colors.red,
                      onPressed: () {
                        SoundService.instance.stopSound();
                        Navigator.pop(context);
                      },
                    ),
                    IconButtonImageShow(
                      imageAsset: args.image4,
                      isJson: false,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

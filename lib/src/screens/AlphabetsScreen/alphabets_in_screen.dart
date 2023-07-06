import 'package:alippe/src/components/AlphabetsComponents/Icon_button_image.dart';
import 'package:alippe/src/components/AlphabetsComponents/ccard.dart';
import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:flutter/material.dart';

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
            image: DecorationImage(
                image: AssetImage("assets/images/alphabet.jpeg"),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtonImageShow(
                    imageAsset: args.image1,
                  ),
                  CCard(
                    margin: const EdgeInsets.only(bottom: 1),
                    width: 150,
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
                  )
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtonImageShow(
                    imageAsset: args.image3,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

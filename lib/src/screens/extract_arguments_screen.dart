import 'package:alippe/src/components/IconButtonImage.dart';
import 'package:alippe/src/components/ccard.dart';
import 'package:alippe/src/screens/screen_arguments.dart';
import 'package:alippe/src/components/sound_service.dart';
import 'package:flutter/material.dart';

import 'alphabets_screen.dart';

// A Widget that extracts the necessary arguments from
// the ModalRoute.
class ExtractArgumentsScreen extends StatefulWidget {
  static const routeName = '/extractArgument';

  const ExtractArgumentsScreen({Key? key}) : super(key: key);
  @override
  State<ExtractArgumentsScreen> createState() => _ExtractArgumentsScreenState();
}

class _ExtractArgumentsScreenState extends State<ExtractArgumentsScreen> {
  @override
  void initState() {
    SoundService.instance.loadSounds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/nurimbagim.jpeg"),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtonImage(
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
                  IconButtonImage(
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
                  IconButtonImage(
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
                  IconButtonImage(
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

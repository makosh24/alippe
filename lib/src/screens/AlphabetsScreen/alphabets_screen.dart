import 'dart:math';

import 'package:alippe/src/components/AlphabetsComponents/ccard.dart';
import 'package:alippe/src/components/AlphabetsComponents/ccardsmall.dart';
import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:alippe/src/locale/strings_of_app.dart';
import 'package:alippe/src/screens/AlphabetsScreen/alphabet_arguments.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'alphabets_in_screen.dart';

class AlphabetsScreen extends StatefulWidget {
  const AlphabetsScreen({Key? key}) : super(key: key);

  @override
  State<AlphabetsScreen> createState() => _AlphabetsScreenState();
}

class _AlphabetsScreenState extends State<AlphabetsScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();
    playWelcomeSound();
  }

  playWelcomeSound() async {
    await SoundService.instance.welcomeSound();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.deepOrangeAccent[100],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Gap(8),
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () async {
                          await playWelcomeSound();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          color: Colors.black12,
                          child: Center(
                            child: Text(
                              alphabetsTitile,
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.primaries[Random()
                                      .nextInt(Colors.primaries.length)],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: alphabets
                        .map((letter) => CCard(
                            letter: letter.name,
                            smallLetter: letter.smallName,
                            soundLetter: letter.sound,
                            callback: () => {
                                  SoundService.instance
                                      .playTapDownSound(letter.sound),
                                  Navigator.pushNamed(
                                      context, AlphabetsInScreen.routeName,
                                      arguments: AlphabetArguments(
                                          letter.name,
                                          letter.smallName,
                                          letter.sound,
                                          letter.image1,
                                          letter.image2,
                                          letter.image3,
                                          letter.image4))
                                }))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 20,
          thickness: 1,
          indent: 20,
          endIndent: 0,
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.deepOrangeAccent[100],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                  // width: 20,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const <Widget>[
                      CCardSmall(),
                      CCardSmall(),
                      CCardSmall(),
                      CCardSmall(),
                      CCardSmall(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

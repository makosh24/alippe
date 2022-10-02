import 'dart:math';

import 'package:alippe/src/components/ccard.dart';
import 'package:alippe/src/components/ccardsmall.dart';
import 'package:alippe/src/screens/screen_arguments.dart';
import 'package:alippe/src/components/sound_service.dart';
import 'package:flutter/material.dart';

import 'alphabets.dart';
import 'extract_arguments_screen.dart';

class AlphabetsScreen extends StatefulWidget {
  const AlphabetsScreen({Key? key}) : super(key: key);

  @override
  State<AlphabetsScreen> createState() => _AlphabetsScreenState();
}

class _AlphabetsScreenState extends State<AlphabetsScreen> {
  List<Alphabets> alphabets = [
    Alphabets(
      name: "A",
      smallName: "a",
      sound: 'a',
      image1: 'alma',
      image2: 'agash',
      image3: 'asik',
      image4: 'astau',
    ),
    Alphabets(
      name: "Ә",
      smallName: "ә",
      sound: 'a1',
      image1: 'alma',
      image2: 'alma',
      image3: 'alma',
      image4: 'alma',
    ),
  ];
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
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/fantastic.jpeg"),
              fit: BoxFit.cover)),
      child: Column(
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
                  InkWell(
                    onTap: () async {
                      await playWelcomeSound();
                    },
                    child: ClipOval(
                      child: Container(
                        color: Colors.white54,
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Әріптер әлеміне қош келдің балақай!!!",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: alphabets
                          .map((letter) => CCard(
                              width: 100,
                              height: 100,
                              letter: letter.name,
                              smallLetter: letter.smallName,
                              soundLetter: letter.sound,
                              callback: () => {
                                    SoundService.instance
                                        .playTapDownSound(letter.sound),
                                    Navigator.pushNamed(context,
                                        ExtractArgumentsScreen.routeName,
                                        arguments: ScreenArguments(
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
      ),
    );
  }
}

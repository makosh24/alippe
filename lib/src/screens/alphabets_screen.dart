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
      image1: 'atesh',
      image2: 'ake',
      image3: 'asker',
      image4: 'anshi',
    ),
    Alphabets(
      name: "Б",
      smallName: "б",
      sound: 'b',
      image1: 'buzau',
      image2: 'besik',
      image3: 'bagdarsham',
      image4: 'balik',
    ),
    Alphabets(
      name: "В",
      smallName: "в",
      sound: 'b1',
      image1: 'vanna',
      image2: 'vagon',
      image3: 'vaza',
      image4: 'velosiped',
    ),
    Alphabets(
      name: "Г",
      smallName: "г",
      sound: 'g',
      image1: 'galaktika',
      image2: 'gimalai',
      image3: 'globus',
      image4: 'gul',
    ),
    Alphabets(
      name: "Ғ",
      smallName: "ғ",
      sound: 'g1',
      image1: 'galamtor',
      image2: 'gimarat',
      image3: 'garish',
      image4: 'galim',
    ),
    Alphabets(
      name: "Д",
      smallName: "д",
      sound: 'd',
      image1: 'dariger',
      image2: 'dauilpaz',
      image3: 'dombyrea',
      image4: 'dop',
    ),
    Alphabets(
      name: "Е",
      smallName: "е",
      sound: 'e',
      image1: 'eltanba',
      image2: 'ertokim',
      image3: 'etik',
      image4: 'esik',
    ),
    Alphabets(
      name: "Ё",
      smallName: "ё",
      sound: 'e1',
      image1: 'elka',
      image2: 'monter',
      image3: 'shahter',
      image4: '',
    ),
    Alphabets(
      name: "Ж",
      smallName: "ж",
      sound: 'zh',
      image1: 'zhailau',
      image2: 'zhalau',
      image3: 'zhastik',
      image4: 'zheide',
    ),
    Alphabets(
      name: "З",
      smallName: "з",
      sound: 'z',
      image1: 'zimiran',
      image2: 'zerger',
      image3: 'zebra',
      image4: 'zaisan',
    ),
    Alphabets(
      name: "И",
      smallName: "и",
      sound: 'i',
      image1: 'ine',
      image2: 'inelik',
      image3: 'it',
      image4: 'itmurin',
    ),
    Alphabets(
      name: "Й",
      smallName: "й",
      sound: 'i1',
      image1: 'ai',
      image2: 'aina',
      image3: 'i1od',
      image4: 'tuie',
    ),
    Alphabets(
      name: "К",
      smallName: "к",
      sound: 'k',
      image1: 'kitap',
      image2: 'kobelek',
      image3: 'kerege',
      image4: 'korpeshe',
    ),
    Alphabets(
      name: "Қ",
      smallName: "қ",
      sound: 'k1',
      image1: 'kalam',
      image2: 'koian',
      image3: 'kobiz',
      image4: 'kayik',
    ),
    Alphabets(
      name: "Л",
      smallName: "л",
      sound: 'l',
      image1: 'lai',
      image2: 'lak',
      image3: 'lashik',
      image4: 'london',
    ),
    Alphabets(
      name: "М",
      smallName: "м",
      sound: 'm',
      image1: 'mashina',
      image2: 'misik',
      image3: 'mugalim',
      image4: 'munara',
    ),
    Alphabets(
      name: "Н",
      smallName: "н",
      sound: 'n',
      image1: 'naiza',
      image2: 'nar',
      image3: 'nan',
      image4: 'nauat',
    ),
    Alphabets(
      name: "Ң",
      smallName: "ң",
      sound: 'n1',
      image1: 'shangi',
      image2: 'an1shi',
      image3: 'zhanalik',
      image4: 'tanerten',
    ),
    Alphabets(
      name: "О",
      smallName: "о",
      sound: 'o',
      image1: 'otan',
      image2: 'oshak',
      image3: 'orman',
      image4: 'orindik',
    ),
    Alphabets(
      name: "Ө",
      smallName: "ө",
      sound: 'o1',
      image1: 'ormekshi',
      image2: 'oshirgish',
      image3: 'otkel',
      image4: 'ozen',
    ),
    Alphabets(
      name: "П",
      smallName: "п",
      sound: 'p',
      image1: 'palto',
      image2: 'parizh',
      image3: 'parta',
      image4: 'perde',
    ),
    Alphabets(
      name: "Р",
      smallName: "р",
      sound: 'r',
      image1: 'radio',
      image2: 'raushan',
      image3: 'rebus',
      image4: 'robot',
    ),
    Alphabets(
      name: "С",
      smallName: "с",
      sound: 's',
      image1: 'sabin',
      image2: 'sagat',
      image3: 'sandik',
      image4: 'su',
    ),
    Alphabets(
      name: "Т",
      smallName: "т",
      sound: 't',
      image1: 'takia',
      image2: 'tanerten',
      image3: 'tankurai',
      image4: 'tas',
    ),
    Alphabets(
      name: "У",
      smallName: "у",
      sound: 'u',
      image1: 'uik',
      image2: 'tu',
      image3: 'tau',
      image4: 'su',
    ),
    Alphabets(
      name: "Ұ",
      smallName: "ұ",
      sound: 'u1',
      image1: 'ulu',
      image2: 'usta',
      image3: 'un',
      image4: 'ushak',
    ),
    Alphabets(
      name: "Ү",
      smallName: "ү",
      sound: 'u2',
      image1: 'ui',
      image2: 'ungir',
      image3: 'ustel',
      image4: 'uzengi',
    ),
    Alphabets(
      name: "Ф",
      smallName: "ф",
      sound: 'feldsher',
      image1: 'fermer',
      image2: 'fishka',
      image3: 'football',
      image4: 'foto',
    ),
    Alphabets(
      name: "Х",
      smallName: "х",
      sound: 'h',
      image1: 'han',
      image2: 'hat',
      image3: '',
      image4: '',
    ),
    Alphabets(
      name: "Һ",
      smallName: "һ",
      sound: 'h1',
      image1: 'kaharman',
      image2: '',
      image3: '',
      image4: '',
    ),
    Alphabets(
      name: "Ц",
      smallName: "ц",
      sound: 'c1',
      image1: 'cement',
      image2: 'cilindr',
      image3: 'cirk',
      image4: 'cirkul',
    ),
    Alphabets(
      name: "Ч",
      smallName: "ч",
      sound: 'sh1',
      image1: 'chempion',
      image2: 'check',
      image3: 'chemodan',
      image4: 'chip',
    ),
    Alphabets(
      name: "Ш",
      smallName: "ш",
      sound: 'sh',
      image1: 'shahmat',
      image2: 'shahta',
      image3: 'shahter',
      image4: 'shuzhik',
    ),
    Alphabets(
      name: "Щ",
      smallName: "щ",
      sound: 'sh1',
      image1: 'shetka',
      image2: 'ashshi',
      image3: 'tushshi',
      image4: 'anshi',
    ),
    Alphabets(
      name: "Ъ",
      smallName: "ъ",
      sound: 'juan_belgisi',
      image1: 'atesh',
      image2: 'ake',
      image3: 'asker',
      image4: 'anshi',
    ),
    Alphabets(
      name: "Ы",
      smallName: "ы",
      sound: 'i3',
      image1: 'alfa',
      image2: 'ake',
      image3: 'asker',
      image4: 'anshi',
    ),
    Alphabets(
      name: "Ь",
      smallName: "ь",
      sound: 'jiniwke_belgisi',
      image1: 'albom',
      image2: 'palto',
      image3: 'alfa',
      image4: '',
    ),
    Alphabets(
      name: "Э",
      smallName: "э",
      sound: 'e2',
      image1: 'ekvator',
      image2: 'ekskalator',
      image3: 'ekskavator',
      image4: 'elevator',
    ),
    Alphabets(
      name: "Ю",
      smallName: "ю",
      sound: 'iu',
      image1: 'oiu',
      image2: 'aiu',
      image3: 'iupiter',
      image4: 'anshi',
    ),
    Alphabets(
      name: "Я",
      smallName: "я",
      sound: 'ia',
      image1: 'takia',
      image2: 'boiau',
      image3: 'aiak',
      image4: 'koian',
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
                              // height: 100,
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

import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class IconButtonImageShow extends StatelessWidget {
  final String imageAsset;
  final String imageText;
  final bool isJson;

  const IconButtonImageShow(
      {Key? key,
      required this.imageAsset,
      required this.imageText,
      required this.isJson})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white70, // Set your desired background color here
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: isJson
            ? Lottie.asset('assets/images/predmets/$imageAsset.json',
                fit: BoxFit.contain)
            : Image.asset('assets/images/predmets/$imageAsset.png'),
        tooltip: imageAsset,
        iconSize: 130,
        splashRadius: 100,
        onPressed: () async {
          SoundService.instance.playTapDownSound(imageAsset);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white10,
                  content: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            color: Colors.redAccent,
                            iconSize: 50,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              imageText,
                              textStyle: const TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                              colors: [
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
                      ),
                      Expanded(
                          child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          SoundService.instance.playTapDownSound(imageAsset);
                          // print("as");
                        },
                        child: isJson
                            ? Lottie.asset(
                                'assets/images/predmets/$imageAsset.json',
                                fit: BoxFit.cover)
                            : Image.asset(
                                'assets/images/predmets/$imageAsset.png'),
                      )),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}

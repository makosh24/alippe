import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:flutter/material.dart';

class IconButtonImageShow extends StatelessWidget {
  final String imageAsset;

  const IconButtonImageShow({Key? key, required this.imageAsset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/images/predmets/$imageAsset.png',
        width: 300,
        height: 300,
      ),
      tooltip: imageAsset,
      iconSize: 130,
      splashRadius: 100,
      onPressed: () async {
        SoundService.instance.playTapDownSound(imageAsset);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                // title: Text("Alert Dialog"),
                content: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image(
                    image: AssetImage('assets/images/predmets/$imageAsset.png'),
                    width: 400,
                    height: 400,
                  ),
                ),
                elevation: 24.0,
                shape: const CircleBorder(),
              );
            });
      },
    );
  }
}

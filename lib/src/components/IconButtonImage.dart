import 'package:alippe/src/components/sound_service.dart';
import 'package:flutter/material.dart';

class IconButtonImage extends StatelessWidget {
  String imageAsset;

  IconButtonImage({Key? key, required this.imageAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/images/predmets/$imageAsset.png'),
      tooltip: imageAsset,
      iconSize: 110,
      onPressed: () async {
        print('sds');
        SoundService.instance.playTapDownSound(imageAsset);
      },
    );
  }
}

import 'dart:typed_data';

import 'package:alippe/src/screens/screen_arguments.dart';
import 'package:alippe/src/screens/sound_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      appBar:
          AppBar(title: Text(args.title), backgroundColor: Colors.redAccent),
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: ElevatedButton(
          child: Text('play button tap sound ${args.message}'),
          onPressed: () async {
            await SoundService.instance.playTapDownSound(args.message);
          },
        ),
      ),
    );
  }
}

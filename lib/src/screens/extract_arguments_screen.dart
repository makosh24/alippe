import 'package:alippe/src/components/ccard.dart';
import 'package:alippe/src/screens/screen_arguments.dart';
import 'package:alippe/src/screens/sound_service.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('play button tap sound ${args.message}'),
                  onPressed: () async {
                    await SoundService.instance.playTapDownSound(args.message);
                  },
                ),
                ElevatedButton(
                  child: Text('play button tap sound ${args.message}'),
                  onPressed: () async {
                    await SoundService.instance.playTapDownSound('arbuz');
                  },
                ),
              ],
            ),
            CCard(
              width: 100,
              letter: args.title,
              smallLetter: '',
              callback: () async {
                await SoundService.instance.playTapDownSound(args.message);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('play button tap sound ${args.message}'),
                  onPressed: () async {
                    await SoundService.instance.playTapDownSound('arbuz');
                  },
                ),
                ElevatedButton(
                  child: Text('back'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text('play button tap sound ${args.message}'),
                  onPressed: () async {
                    await SoundService.instance.playTapDownSound('arbuz');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

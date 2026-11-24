import 'package:alippe/src/components/AlphabetsComponents/ccard.dart';
import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:alippe/src/locale/strings_of_app.dart';
import 'package:alippe/src/screens/AlphabetsScreen/alphabets.dart';
import 'package:alippe/src/screens/AlphabetsScreen/alphabets_in_screen.dart';
import 'package:alippe/src/screens/FairyTalesScreen/fairy_tales_screen.dart';
import 'package:alippe/src/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AlphabetsScreen extends StatefulWidget {
  const AlphabetsScreen({Key? key}) : super(key: key);

  @override
  State<AlphabetsScreen> createState() => _AlphabetsScreenState();
}

class _AlphabetsScreenState extends State<AlphabetsScreen> {
  var _welcomePending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_welcomePending) return;
      SoundService.instance.welcomeSound();
    });
  }

  void _leaveHome() {
    _welcomePending = false;
    SoundService.instance.stopSound();
  }

  @override
  Widget build(BuildContext context) {
    final mid = (alphabets.length / 2).ceil();
    final topLetters = alphabets.sublist(0, mid);
    final bottomLetters = alphabets.sublist(mid);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bookAlphabet.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  tooltip: 'Баптаулар',
                  onPressed: () {
                    _leaveHome();
                    Navigator.pushNamed(context, SettingsScreen.routeName);
                  },
                  icon: const Icon(Icons.settings, size: 32, color: Color(0xFF16324F)),
                ),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: InkWell(
                  onTap: () => SoundService.instance.welcomeSound(),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 3,
                    ),
                    color: Colors.black12,
                    child: Text(
                      alphabetsTitile,
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.primaries.first,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _leaveHome();
                Navigator.pushNamed(context, FairyTalesScreen.routeName);
              },
              child: const Text(
                faityTalesTitle,
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 230, 86, 24),
                ),
              ),
            ),
            Expanded(child: _letterRow(topLetters, 0)),
            const Divider(
              color: Colors.grey,
              height: 12,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(child: _letterRow(bottomLetters, topLetters.length)),
            const Gap(8),
          ],
        ),
      ),
    );
  }

  Widget _letterRow(List<Alphabets> letters, int offset) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: letters.length,
      itemBuilder: (context, index) {
        final letter = letters[index];
        final colorIndex = offset + index;
        return CCard(
          letter: letter.name,
          smallLetter: letter.smallName,
          color: Colors.primaries[colorIndex % Colors.primaries.length],
          callback: () {
            _welcomePending = false;
            SoundService.instance.playTapDownSound(letter.sound);
            Navigator.pushNamed(
              context,
              AlphabetsInScreen.routeName,
              arguments: letter,
            );
          },
        );
      },
    );
  }
}

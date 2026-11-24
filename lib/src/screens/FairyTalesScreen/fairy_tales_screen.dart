import 'package:alippe/src/components/AlphabetsComponents/sound_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class FairyTale {
  final String title;
  final String audioPath;
  final String text;

  const FairyTale({
    required this.title,
    required this.audioPath,
    required this.text,
  });
}

class FairyTalesScreen extends StatefulWidget {
  static const String routeName = '/fairyTales';

  const FairyTalesScreen({Key? key}) : super(key: key);

  @override
  State<FairyTalesScreen> createState() => _FairyTalesScreenState();
}

class _FairyTalesScreenState extends State<FairyTalesScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  static const List<FairyTale> fairyTales = [
    FairyTale(
      title: "Үйрек туралы ертегі",
      audioPath: "audio/uirekFairy.wav",
      text:
          '''Баяғыда бір сүңгуір үйрек болыпты. Ол көлдегі екі аққуды көре алмапты. «Бұлар менен неге сәнді, неге әдемі? Жұрт оларды жақсы көреді, тимейді. Аққу неткен бақытты құс?!», — деп қызғаныпты.
Аққуды көре алмаған сүңгуір үйрек бір күні түлкіні көріп:
— Түлкі, түлкі, сен неге мына семіз аққуларды жемейсің? — дейді.
— Олардың ұйықтайтын жерін маған көрсетші, — деді түлкі.
Уәде бойынша, сүңгуір үйрек аққулар ұйқыға кеткен кезде түлкіні ертіп келді. Мұны сезген екі аққу оянып кетіп, суға жүзе жөнелді.
Іс сәтсіз болып, қарны ашқан түлкі сүңгуір үйректің өзін бас салып жеп қойды. «Біреуге ор қазсаң, өзің түсесің» деген осы.''',
    ),
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _audioPlayer.stop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ертегілер"),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.indigo],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ертегіні таңда балақай!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: fairyTales.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(
                          fairyTales[index].title,
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => _playFairyTale(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _playFairyTale(int index) async {
    await SoundService.instance.stopSound();
    final tale = fairyTales[index];
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(tale.audioPath));
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            tale.title,
            style: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(dialogContext).size.width * 0.7,
            child: SingleChildScrollView(
              child: Text(
                tale.text,
                style: const TextStyle(color: Colors.deepPurple, fontSize: 18),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Шығу"),
            ),
          ],
        );
      },
    );
    await _audioPlayer.stop();
  }
}

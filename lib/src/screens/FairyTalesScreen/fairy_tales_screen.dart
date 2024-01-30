import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FairyTale {
  final String title;
  final String audioPath;
  final String text;

  FairyTale({
    required this.title,
    required this.audioPath,
    required this.text,
  });
}

class FairyTalesScreen extends StatefulWidget {
  static const String routeName = '/fairyTales';

  @override
  _FairyTalesScreenState createState() => _FairyTalesScreenState();
}

class _FairyTalesScreenState extends State<FairyTalesScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<FairyTale> fairyTales = [
    FairyTale(
      title: "Үйрек туралы ертегі",
      audioPath: "audio/uirekFairy.wav",
      text:
          '''Баяғыда бір сүңгуір үйрек болыпты. Ол көлдегі екі аққуды көре алмапты. <Бұлар менен неге сəнді, неге əдемі? Жұрт оларды жақсы көреді, тимейді. Аққу неткен бақытты құс?!>,-деп қызғаныпты.
Аққуды көре алмаған сүңгуір үйрек бір күні түлкіні көріп:
-Түлкі, түлкі, сен неге мына семіз аққуларды жемейсің?- дейді.
-Олардың ұйықтайтын жерін маған көрсетші,-деді түлкі.
Уәде бойынша, сүңгуір үйрек
аққулар ұйқыға кеткен кезде түлкіні ертіп келді. Мұны сезген екі аққу оянып кетіп, суға жүзе жөнелді.
Іс сəтсіз болып, қарны ашқан түлкі сүңгуір үйректің өзін бас салып жеп қойды. <Біреуге ор қазсаң, өзің түсесің> деген осы.''',
    ),
    // Add more fairy tales as needed
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ертегілер"),
        backgroundColor:
            Colors.deepPurple, // Измените цвет фона шапки по вашему вкусу
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ертегіні таңда балақай!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
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
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        _playFairyTale(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playFairyTale(int index) {
    String audioPath = fairyTales[index].audioPath;
    String text = fairyTales[index].text;

    _audioPlayer.play(AssetSource(audioPath));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            fairyTales[index].title,
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            children: [
              Text(
                text,
                style: TextStyle(color: Colors.deepPurple),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _audioPlayer.pause();
                  Navigator.of(context).pop();
                },
                child: Text("Шығу"),
              ),
            ],
          ),
        );
      },
    );
  }
}

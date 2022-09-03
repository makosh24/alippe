import 'package:alippe/main.dart';
import 'package:alippe/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../azbuka.dart';
// import '../screens/extract_arguments_screen.dart';

class LetterWhere extends StatelessWidget {
  const LetterWhere({Key? key}) : super(key: key);

  static const routeName = '/letterWhere';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eazy Azbuka',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const QuizPage(title: 'Eazy Azbuka'),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late AzbukaItem correct;
  bool answered = false;
  late List answers;
  late Azbuka azbuka;
  int correctAnswersCounter = 0;
  int incorrectAnswersCounter = 0;

  _QuizPageState() {
    azbuka = new Azbuka();
    _initAzbukaQuestions();
  }

  void _initAzbukaQuestions() {
    answered = false;
    correct = azbuka.getRandom();
    answers = <String>[
      correct.latin,
      azbuka.getRandom().latin,
      azbuka.getRandom().latin
    ];
    answers.shuffle();
  }

  void _checkAnswerAndLoadNewQuestions(String clickedAnswer) {
    if (!answered) {
      setState(() {
        if (clickedAnswer == correct.latin) {
          correctAnswersCounter++;
        } else {
          incorrectAnswersCounter++;
        }

        answered = true;
      });

      new Timer(const Duration(milliseconds: 2000), () {
        setState(() {
          _initAzbukaQuestions();
        });
      });
    }
  }

  MaterialColor _highlightAnswer(String answer) {
    if (!answered) {
      return Colors.lime;
    } else if (answered && answer == correct.latin) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backwardsCompatibility: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Correct: " + correctAnswersCounter.toString(),
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(
                      "Incorrect: " + incorrectAnswersCounter.toString(),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            Text(
              correct.azbuka,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 160.0,
                fontFamily: 'Roboto',
              ),
            ),
            Padding(padding: new EdgeInsets.all(20.0)),
            Row(
              children: <Widget>[
                Padding(padding: new EdgeInsets.all(5.0)),
                Expanded(
                  child: RaisedButton(
                    color: _highlightAnswer(answers[0]),
                    onPressed: () =>
                        _checkAnswerAndLoadNewQuestions(answers[0]),
                    child: new Text(
                      answers[0],
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
                Padding(padding: new EdgeInsets.all(5.0)),
                Expanded(
                  child: new RaisedButton(
                    color: _highlightAnswer(answers[1]),
                    onPressed: () =>
                        _checkAnswerAndLoadNewQuestions(answers[1]),
                    child: new Text(
                      answers[1],
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
                Padding(padding: new EdgeInsets.all(5.0)),
                Expanded(
                  child: new RaisedButton(
                    color: _highlightAnswer(answers[2]),
                    onPressed: () =>
                        _checkAnswerAndLoadNewQuestions(answers[2]),
                    child: new Text(
                      answers[2],
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
                Padding(padding: new EdgeInsets.all(5.0)),
                FloatingActionButton(onPressed: () {
                  Navigator.pop(context);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

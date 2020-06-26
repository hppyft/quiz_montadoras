import 'package:flutter/material.dart';
import 'package:flutterquiz/AnswerCard.dart';
import 'package:flutterquiz/Model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _step = 0; //TODO tirar isso daqui?
  bool isEnabled = true;
  bool isAnswered = false;
  Question question;

  Question question1 = Question("BMW", [
    Answer("Inglaterra", false),
    Answer("USA", false),
    Answer("Alemanha", true),
    Answer("Japão", false)
  ]);

  Question question2 = Question("Toyota", [
    Answer("england", false),
    Answer("usa", false),
    Answer("germany", false),
    Answer("japan", true)
  ]);

  final answersKey = GlobalKey<AnswersWidgetState>();

  void _onAnswerCallback() {
    setState(() {
      isAnswered = true;
    });
  }

  void _goToNextStep() {
    setState(() {
      if (_step == 0 && isAnswered) {
        isEnabled = false;
        _step++;
      } else if (_step == 1) {
        isEnabled = true;
        isAnswered = true;
        question = question2;
        answersKey.currentState.selectedIndex = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (question == null) {
      question = question1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Qual o país de origem da seguinte montadora:',
                  style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnswersWidget(
                  key: answersKey,
                  question: question,
                  areEnabled: isEnabled,
                  onAnswerCallback: _onAnswerCallback),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToNextStep,
        tooltip: 'Next',
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}

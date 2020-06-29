import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterquiz/QuestionWidget.dart';
import 'package:flutterquiz/Model.dart';
import 'package:flutterquiz/Service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ResultScreen.dart';
import 'StepsUtil.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz das Montadoras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Quiz das Montadoras'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _step = StepsUtil.OPEN_QUESTION_STEP;
  bool _isEnabled = true;
  bool _isAnswered = false;
  Future<List<Question>> questions;
  int _currentQuestion = 0;
  int _numberOfQuestions = -1;
  int _correctAnswers = 0;
  bool _isCorrectAnswer = false;

  final _answersKey = GlobalKey<AnswersWidgetState>();

  void _onAnswerCallback(bool isCorrectAnswer) {
    setState(() {
      _isCorrectAnswer = isCorrectAnswer;
      _isAnswered = true;
    });
  }

  bool hasNextQuestion() {
    return _currentQuestion < (_numberOfQuestions - 1);
  }

  void _goToNextStep() {
    setState(() {
      if (_step == StepsUtil.OPEN_QUESTION_STEP && _isAnswered) {
        _isEnabled = false;
        if (_isCorrectAnswer) {
          _correctAnswers++;
        }
        _isCorrectAnswer = false;
        _step = StepsUtil.SHOW_ANSWER_STEP;
      } else if (_step == StepsUtil.OPEN_QUESTION_STEP && !_isAnswered) {
        Fluttertoast.showToast(
            msg: "Você deve selecionar uma alternativa antes de seguir o quiz",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (_step == StepsUtil.SHOW_ANSWER_STEP && hasNextQuestion()) {
        _isEnabled = true;
        _isAnswered = true;
        _answersKey.currentState.selectedIndex = -1;
        _currentQuestion++;
        _step = StepsUtil.OPEN_QUESTION_STEP;
      } else if (_step == StepsUtil.SHOW_ANSWER_STEP && !hasNextQuestion()) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ResultScreen(
                    correctAnswers: _correctAnswers,
                    totalQuestions: _numberOfQuestions,
                  )),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    questions = Service.fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Qual o país de origem da seguinte montadora:',
                style: TextStyle(fontSize: 32, color: Colors.black),
              ),
            ),
            FutureBuilder<List<Question>>(
              future: questions,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _numberOfQuestions = snapshot.data.length;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnswersWidget(
                        key: _answersKey,
                        question: snapshot.data[_currentQuestion],
                        areEnabled: _isEnabled,
                        onAnswerCallback: _onAnswerCallback),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
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

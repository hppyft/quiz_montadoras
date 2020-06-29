import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key key, this.totalQuestions, this.correctAnswers})
      : super(key: key);
  final int totalQuestions;
  final int correctAnswers;

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  String _percentageText;

  @override
  void initState() {
    super.initState();
    _percentageText = "${(widget.correctAnswers * 100 / widget.totalQuestions).toString()}%";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                Text("Parabéns por concluir o quiz!",
                    style: TextStyle(color: Colors.black, fontSize: 32)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Você acertou ${widget.correctAnswers} questões de um total de ${widget.totalQuestions}",
                      style: TextStyle(color: Colors.green[900], fontSize: 32)),
                ),
                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 13.0,
                  animation: true,
                  percent: widget.correctAnswers / widget.totalQuestions,
                  center: new Text(
                    _percentageText,
                    style:
                        new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.green[900],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutterquiz/Model.dart';

class AnswersWidget extends StatefulWidget {
  AnswersWidget(
      {Key key,
      @required this.question,
      @required this.areEnabled,
      @required this.onAnswerCallback})
      : super(key: key);

  final Question question;
  final bool areEnabled;
  final void Function() onAnswerCallback;

  @override
  AnswersWidgetState createState() => AnswersWidgetState();
}

class AnswersWidgetState extends State<AnswersWidget> {
  num selectedIndex = -1;

  void _onChangedCallback(num value) {
    widget.onAnswerCallback();
    setState(() {
      selectedIndex = value;
    });
  }

  Widget build(BuildContext context) {
    ListView listView = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.question.answers.length,
        itemBuilder: (context, position) {
          return SingleAnswerWidget(
              index: position,
              selectedIndex: selectedIndex,
              answer: widget.question.answers[position],
              isEnabled: widget.areEnabled,
              onChangedCallback: _onChangedCallback);
        });

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.question.text),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: SizedBox(child: listView),
        )
      ],
    );
  }
}

class SingleAnswerWidget extends StatefulWidget {
  SingleAnswerWidget(
      {Key key,
      @required this.index,
      @required this.selectedIndex,
      @required this.answer,
      @required this.isEnabled,
      @required this.onChangedCallback})
      : super(key: key);

  final Answer answer;
  final num index;
  final num selectedIndex;
  final bool isEnabled;
  final void Function(num) onChangedCallback;

  @override
  _SingleAnswerWidgetState createState() => _SingleAnswerWidgetState();
}

class _SingleAnswerWidgetState extends State<SingleAnswerWidget> {
  String _getText() {
    if (widget.isEnabled) {
      return widget.answer.text;
    } else if (widget.index == widget.selectedIndex) {
      if (widget.answer.isCorrect) {
        return widget.answer.text + " - PARABÉNS, VOCÊ ACERTOU";
      } else {
        return widget.answer.text + " - QUE PENA, VOCÊ ERROU";
      }
    } else if (widget.answer.isCorrect) {
      return widget.answer.text + " - ESTA ERA A RESPOSTA CERTA";
    } else {
      return widget.answer.text;
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          _getText(),
          style: TextStyle(color: Colors.black),
        ),
        leading: Radio(
          value: widget.index,
          groupValue: widget.selectedIndex,
          onChanged: (num value) {
            if (widget.isEnabled) {
              widget.onChangedCallback(value);
            }
          },
        ),
      ),
    );
  }
}

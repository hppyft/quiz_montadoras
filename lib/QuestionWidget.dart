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
  final void Function(bool) onAnswerCallback;

  @override
  AnswersWidgetState createState() => AnswersWidgetState();
}

class AnswersWidgetState extends State<AnswersWidget> {
  num selectedIndex = -1;

  @override
  void initState() {
    super.initState();

  }

  void _onChangedCallback(num value) {
    setState(() {
      int correctIndex = widget.question.answers.indexWhere((o) => o.isCorrect);
      widget.onAnswerCallback(correctIndex == value);
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
          child: Text(widget.question.text, style: TextStyle(
            color: Colors.black,
            fontSize: 32
          ),),
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

  Color _getBackgroundColor() {
    if (widget.isEnabled) {
      return Colors.white;
    } else if (widget.index == widget.selectedIndex) {
      if (widget.answer.isCorrect) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } else if (widget.answer.isCorrect) {
      return Colors.yellow;
    } else {
      return Colors.white;
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: _getBackgroundColor(),
        child: ListTile(
          title: Text(
            widget.answer.text,
            style: TextStyle(color: Colors.black, fontSize: 20),
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
      ),
    );
  }
}

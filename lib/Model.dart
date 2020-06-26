class Answer {
  Answer(this.text, this.isCorrect);

  String text;
  bool isCorrect;
}

class Question {
  Question(this.text, this.answers);

  String text;
  List<Answer> answers;
}

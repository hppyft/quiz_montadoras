class Answer {
  Answer(this.text, this.isCorrect);

  final String text;
  final bool isCorrect;

  factory Answer.fromJson(Map<String, dynamic> json){
    return new Answer(json['text'], json['isCorrect']);
  }
}

class Question {
  Question(this.text, this.answers);

  String text;
  List<Answer> answers;

  factory Question.fromJson(Map<String, dynamic> json){
    List<Answer> answers = new List();
    List<dynamic> list = json['answers'];
    list.forEach((dynamic f) => {
      answers.add(Answer.fromJson(f))
    });
    return new Question(json['text'], answers);
  }
}

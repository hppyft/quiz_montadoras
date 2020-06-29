import 'dart:convert';
import 'package:flutterquiz/Model.dart';
import 'package:http/http.dart' as http;

class Service {
  static Future<List<Question>> fetchQuestions() async {
    final response = await http.get('https://localhost:44380/api/Default');
    if (response.statusCode == 200) {
      List<Question> questions = (json.decode(response.body) as List)
          .map((i) => Question.fromJson(i))
          .toList();
      return questions;
    } else {
      throw Exception("Failed to load questions\n${response.statusCode}\n${response.body}");
    }
  }
}

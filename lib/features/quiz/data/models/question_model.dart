// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:quiz/features/quiz/data/models/answer_model.dart';

class Question {
  String question;
  int questionId;
  List<Answer> answers;
  Question(
    this.question,
    this.questionId,
    this.answers,
  );
}

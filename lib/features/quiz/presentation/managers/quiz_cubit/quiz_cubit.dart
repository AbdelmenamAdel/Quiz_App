import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/features/quiz/data/models/answer_model.dart';
import 'package:quiz/features/quiz/data/models/question_model.dart';
import 'package:quiz/features/quiz/presentation/screens/result_screen/result_screen.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(InitialState());

  // Variables
  String name = '';
  bool _isPressed = false;
  double _numberOfQuestion = 1;
  int? _selectedAnswer;
  int? _correctAnswer;
  Timer? _timer;
  final int maxSec = 15;
  List<Question> list = [];
  PageController pageController = PageController(initialPage: 0);

  double get numberOfQuestion => _numberOfQuestion;
  int? get selectedAnswer => _selectedAnswer;

  int _countOfCorrectAnswers = 0;

  int get countOfCorrectAnswers => _countOfCorrectAnswers;

  List<Question> get questionsList {
    if (list.isEmpty) {
      list.addAll([
        Question('Who invented Flutter?', 1, [
          Answer(answer: 'Google', isCorrect: true),
          Answer(answer: 'Samsung'),
          Answer(answer: 'Apple'),
          Answer(answer: 'Microsoft'),
        ]),
        Question('When was Flutter invented?', 2, [
          Answer(answer: '2014'),
          Answer(answer: '2009'),
          Answer(answer: '2013'),
          Answer(answer: '2017', isCorrect: true),
        ]),
        Question(
          'What is the name of the widget used to create a button in Flutter?',
          3,
          [
            Answer(answer: 'Animated Button'),
            Answer(answer: 'Material Button', isCorrect: true),
            Answer(answer: 'Elevated Button'),
            Answer(answer: 'All of the above'),
          ],
        ),
      ]);
    }
    return list;
  }

  double get scoreResult {
    return _countOfCorrectAnswers * 100 / questionsList.length;
  }

  // Get color for an answer
  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green.shade700;
      } else if (answerIndex == _selectedAnswer &&
          _correctAnswer != _selectedAnswer) {
        return Colors.red.shade700;
      }
    }
    return Colors.white;
  }

  // Get icon for an answer
  IconData getIcon(int questionId, int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectedAnswer &&
          _correctAnswer != _selectedAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }

  // Check the selected answer
  void checkAnswer(
      Question questionModel, int selectedAnswer, BuildContext context) {
    _isPressed = true;
    _selectedAnswer = selectedAnswer;
    _correctAnswer =
        questionModel.answers.indexWhere((answer) => answer.isCorrect);
    if (_correctAnswer == _selectedAnswer) {
      _countOfCorrectAnswers++;
    }
    stopTimer();
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      if (pageController.hasClients) {
        nextQuestion(context);
      }
    });
  }

  // Go to the next question
  void nextQuestion(BuildContext context) {
    log('Next question triggered!');

    if (_timer != null && _timer!.isActive) {
      stopTimer();
    }

    if ((pageController.page ?? 0) == questionsList.length - 1) {
      Navigator.pushNamed(context, ResultScreen.routeName);
      resetState();
    } else {
      _isPressed = false;
      _selectedAnswer = null;

      if (pageController.hasClients) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      }

      startTimer(context);
    }

    _numberOfQuestion = (pageController.page ?? 0) + 2;
  }

  // Start the timer
  void startTimer(BuildContext context) {
    emit(TimerRunning(maxSec));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is TimerRunning) {
        final secondsRemaining = (state as TimerRunning).secondsRemaining;
        if (secondsRemaining > 0) {
          emit(TimerRunning(secondsRemaining - 1));
        } else {
          stopTimer();
          emit(TimerStopped());
          nextQuestion(context);
        }
      }
    });
  }

  // Stop the timer
  void stopTimer() {
    _timer?.cancel();
    if (state is TimerRunning) {
      emit(TimerStopped());
    }
  }

  // Reset the state of the quiz
  void resetState() {
    _isPressed = false;
    _selectedAnswer = null;
    _numberOfQuestion = 1;

    if (pageController.hasClients) {
      pageController.jumpToPage(0); // Reset to the first page
    }

    emit(InitialState()); // Reset state to the initial one
  }

  @override
  Future<void> close() {
    stopTimer();
    pageController.dispose();
    return super.close();
  }
}

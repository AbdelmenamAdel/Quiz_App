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
        // Question 1
        Question('What does Flutter primarily target?', 1, [
          Answer(answer: 'Web applications'),
          Answer(answer: 'Mobile applications', isCorrect: true),
          Answer(answer: 'Desktop applications'),
          Answer(answer: 'Server-side apps'),
        ]),

        // Question 2
        Question('What does `build()` do?', 2, [
          Answer(answer: 'Creates widget tree', isCorrect: true),
          Answer(answer: 'Renders widget UI'),
          Answer(answer: 'Handles state changes'),
          Answer(answer: 'Sets widget properties'),
        ]),

        // Question 3
        Question('Which widget is scrollable?', 3, [
          Answer(answer: 'Column'),
          Answer(answer: 'ListView', isCorrect: true),
          Answer(answer: 'Container'),
          Answer(answer: 'TextField'),
        ]),

        // Question 4
        Question('What does `setState()` do?', 4, [
          Answer(answer: 'Rebuilds app'),
          Answer(answer: 'Changes global state'),
          Answer(answer: 'Sets widget layout'),
          Answer(answer: 'Triggers UI update', isCorrect: true),
        ]),

        // Question 5
        Question('Who invented Flutter?', 5, [
          Answer(answer: 'Google', isCorrect: true),
          Answer(answer: 'Samsung'),
          Answer(answer: 'Apple'),
          Answer(answer: 'Microsoft'),
        ]),

        // Question 6
        Question('When was Flutter invented?', 6, [
          Answer(answer: '2014'),
          Answer(answer: '2009'),
          Answer(answer: '2013'),
          Answer(answer: '2017', isCorrect: true),
        ]),
        // Question 7
        Question('Why use `FutureBuilder`?', 7, [
          Answer(answer: 'Handles async data', isCorrect: true),
          Answer(answer: 'Simplifies layouts'),
          Answer(answer: 'Handles UI updates'),
          Answer(answer: 'Updates app state'),
        ]),

        // Question 8
        Question('Which Flutter widget is used for layout in a layer?', 8, [
          Answer(answer: 'Column'),
          Answer(answer: 'Stack', isCorrect: true),
          Answer(answer: 'Row'),
          Answer(answer: 'ListView'),
        ]),

        // Question 9
        Question('What does `async` keyword do?', 9, [
          Answer(answer: 'Pauses function exe'),
          Answer(answer: 'Defines synchronous'),
          Answer(answer: 'Handles errors'),
          Answer(answer: 'Runs asynchronously', isCorrect: true),
        ]),

        // Question 10
        Question('Which package for state management is the best?', 10, [
          Answer(answer: 'provider'),
          Answer(answer: 'flutter_bloc', isCorrect: true),
          Answer(answer: 'riverpod'),
          Answer(answer: 'get_it'),
        ]),
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

    // Added check to ensure pageController is valid and mounted
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      if (pageController.hasClients) {
        nextQuestion(context);
      }
    });
  }

  // Go to the next question
  void nextQuestion(BuildContext context) {
    log('Next question triggered!');

    // Ensure no active timer before starting a new one
    if (_timer?.isActive ?? false) {
      stopTimer();
    }

    final currentPage = pageController.page?.toInt() ?? 0;

    // Check if the last question has been reached
    if (currentPage == questionsList.length - 1) {
      stopTimer();
      log('Quiz completed!');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ResultScreen()));
      Future.delayed(const Duration(milliseconds: 300)).then((_) {
        resetState();
      });
      return;
    }

    // Reset answer state before showing the next question
    _isPressed = false;
    _selectedAnswer = null;

    // Ensure pageController is valid before navigating
    if (pageController.hasClients) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }

    _numberOfQuestion = currentPage + 2;
    startTimer(context);
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
    _correctAnswer = null;
    _numberOfQuestion = 1;
    _countOfCorrectAnswers = 0;

    if (pageController.hasClients) {
      pageController.dispose();
    }
    emit(InitialState());
    pageController = PageController(initialPage: 4);
  }

  @override
  Future<void> close() {
    stopTimer();
    pageController.dispose();
    return super.close();
  }
}

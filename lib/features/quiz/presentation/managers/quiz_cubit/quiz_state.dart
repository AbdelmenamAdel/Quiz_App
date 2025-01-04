part of 'quiz_cubit.dart';

@immutable
sealed class QuizState {}

class InitialState extends QuizState {}

class StartedState extends QuizState {}

class FinishedState extends QuizState {}

class QuestionUpdatedState extends QuizState {
  double progressValue;
  QuestionUpdatedState(this.progressValue);
}

class TimerInitial extends QuizState {
  final int secondsRemaining;
  TimerInitial(this.secondsRemaining);
}

class TimerRunning extends QuizState {
  final int secondsRemaining;
  TimerRunning(this.secondsRemaining);
}

// class TimerCompleted extends QuizState {}

class TimerStopped extends QuizState {}

part of 'quiz_cubit.dart';

@immutable
sealed class QuizState {}

class InitialState extends QuizState {}

class TimerRunning extends QuizState {
  final int secondsRemaining;
  TimerRunning(this.secondsRemaining);
}

class TimerStopped extends QuizState {}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_cubit.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_state.dart';
import '../../constants.dart';

class ProgressTimer extends StatelessWidget {
  const ProgressTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      builder: (context, state) {
        int secondsRemaining = 0;
        double progressValue = 1.0;

        if (state is TimerInitial || state is TimerStopped) {
          secondsRemaining = 0; // Safe cast
        } else if (state is TimerRunning) {
          secondsRemaining = state.secondsRemaining;
          progressValue = 1 - (secondsRemaining / 15);
        } else if (state is TimerStopped) {
          progressValue = 0; // Timer is complete
        }
        return SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progressValue,
                color: KPrimaryColor,
                backgroundColor: Colors.grey,
                strokeWidth: 8,
              ),
              Center(
                child: Text(
                  '$secondsRemaining',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: KPrimaryColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

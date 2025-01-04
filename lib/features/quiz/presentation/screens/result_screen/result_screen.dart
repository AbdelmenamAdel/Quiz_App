import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/constants.dart';
import 'package:quiz/features/quiz/presentation/screens/welcome_screen.dart';
import 'package:quiz/core/widgets/custom_button.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_cubit.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});
  static const routeName = '/result_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/back.jpg'), fit: BoxFit.cover),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Congratulation',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                context.read<QuizCubit>().name,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: KPrimaryColor,
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Your Score is',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                '${context.read<QuizCubit>().scoreResult.round()}%',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: KPrimaryColor,
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, WelcomeScreen.routeName);
                    // context.read<QuizCubit>().countOfCorrectAnswers = 0;
                  },
                  text: 'Start Again'),
            ],
          ),
        ),
      ],
    ));
  }
}

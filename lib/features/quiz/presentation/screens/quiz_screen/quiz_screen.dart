import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/core/widgets/custom_button.dart';
import 'package:quiz/core/widgets/progress_timer.dart';
import 'package:quiz/core/widgets/question_card.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_cubit.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  static const routeName = '/quiz_screen';

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    context.read<QuizCubit>().startTimer(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   elevation: 0,
      //   leading: BackButton(
      //     color: Colors.white,
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   backgroundColor: Colors.transparent,
      // ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
                // image: DecorationImage(
                //     image: AssetImage('assets/images/here.jpg'),
                //     fit: BoxFit.cover),
                color: Colors.black87),
          ),
          BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              final cubit = context.read<QuizCubit>();

              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Question ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: Colors.white),
                              children: [
                                TextSpan(
                                  text:
                                      cubit.numberOfQuestion.toInt().toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: Colors.white),
                                ),
                                TextSpan(
                                    text: '/',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(color: Colors.white)),
                                TextSpan(
                                    text: cubit.questionsList.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                          const ProgressTimer(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 450,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => QuestionCard(
                          questionModel: cubit.questionsList[index],
                        ),
                        controller: cubit.pageController,
                        itemCount: cubit.questionsList.length,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Image.asset(
                      "assets/images/shf.png",
                      height: 200,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: CustomButton(
          onPressed: () {
            context.read<QuizCubit>().nextQuestion(context);
          },
          text: 'Next'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/features/quiz/data/models/question_model.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_cubit.dart';
import 'answer_option.dart';

class QuestionCard extends StatelessWidget {
  final Question questionModel;

  const QuestionCard({
    super.key,
    required this.questionModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          height: 350,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionModel.question,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Spacer(
                  flex: 1,
                ),
                ...List.generate(
                    questionModel.answers.length,
                    (index) => Column(
                          children: [
                            AnswerOption(
                              answerModel: questionModel.answers[index],
                              index: index,
                              questionId: questionModel.questionId,
                              onPressed: () {
                                context
                                    .read<QuizCubit>()
                                    .checkAnswer(questionModel, index, context);
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        )),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/features/quiz/data/models/answer_model.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_cubit.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_state.dart';

class AnswerOption extends StatelessWidget {
  const AnswerOption({
    super.key,
    required this.index,
    required this.questionId,
    required this.onPressed,
    required this.answerModel,
  });

  final int index;
  final int questionId;
  final Answer answerModel;
  final Function() onPressed;
//هنا الويدجت بتاععت الاجابات
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      builder: (BuildContext context, QuizState state) {
        final QuizCubit controller = BlocProvider.of<QuizCubit>(context);
        return InkWell(
            onTap: onPressed,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border:
                      Border.all(width: 3, color: controller.getColor(index))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: '${index + 1}. ',
                          style: Theme.of(context).textTheme.titleLarge,
                          children: [
                            TextSpan(
                              text: answerModel.answer,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ]),
                    ),
                    if (controller.selectedAnswer == index)
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: controller.getColor(index),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            shape: BoxShape.circle),
                        child: Icon(
                          controller.getIcon(questionId, index),
                          color: Colors.white,
                        ),
                      )
                  ],
                ),
              ),
            ));
      },
    );
  }
}

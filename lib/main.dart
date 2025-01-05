import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/core/widgets/error_widget.dart';
import 'package:quiz/features/quiz/presentation/screens/welcome_screen.dart';
import 'package:quiz/core/bloc/bloc_observer.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  flutterErrorWidget();
  Bloc.observer = MyBlocObserver();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      BlocProvider(
        create: (context) => QuizCubit(),
        child: const QuizApp(),
      ),
    );
  });
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

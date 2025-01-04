import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/features/quiz/presentation/screens/quiz_screen/quiz_screen.dart';
import 'package:quiz/features/quiz/presentation/screens/result_screen/result_screen.dart';
import 'package:quiz/features/quiz/presentation/screens/welcome_screen.dart';
import 'package:quiz/core/bloc/bloc_observer.dart';
import 'package:quiz/features/quiz/presentation/managers/quiz_cubit/quiz_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(
    DevicePreview(
      builder: (context) => const QuizApp(),
    ),
  );
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizCubit(),
      child: MaterialApp(
        initialRoute: WelcomeScreen.routeName,
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalKey<NavigatorState>(),
        routes: {
          WelcomeScreen.routeName: (context) => const WelcomeScreen(),
          ResultScreen.routeName: (context) => const ResultScreen(),
          QuizScreen.routeName: (context) => const QuizScreen(),
        },
      ),
    );
  }
}

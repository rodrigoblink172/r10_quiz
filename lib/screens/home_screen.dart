// lib/screens/home.dart
import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/app_shell.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';
import 'package:r10_quiz/screens/quiz_wheel_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      backgroundAsset: 'assets/images/background_ronaldinho.png',
      topRight: const scoreHeader(),
      bottomCenter: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuizWheelScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F378A),
          foregroundColor: Colors.white,
          minimumSize: const Size(188, 50),
        ),
        child: const Text(
          'COMEÇAR QUIZ',
          style: TextStyle(fontSize: 20),
        ),
      ),
      // Se não tiver conteúdo no meio, coloque um SizedBox.shrink()
      child: const SizedBox.shrink(),
    );
  }
}

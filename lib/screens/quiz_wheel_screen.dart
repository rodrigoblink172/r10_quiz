import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/app_shell.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';
import 'package:r10_quiz/components/roulette_wheel.dart';
import 'package:r10_quiz/screens/questions_screen.dart'; // <— importe a tela de perguntas

class QuizWheelScreen extends StatelessWidget {
  const QuizWheelScreen({Key? key}) : super(key: key);

  void _themeSelected(BuildContext context, String theme) {
    // (Opcional) você pode validar/normalizar o tema aqui se precisar.
    // Ex.: garantir que veio exatamente "História", "Jogadores", etc.

    // Navegar para a tela de perguntas passando a categoria
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionScreen(category: theme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      backgroundAsset: 'assets/images/background.png',
      topRight: const scoreHeader(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SizedBox(height: 50),
            Expanded(
              child: RouletteWheel(
                onFinish: (theme) => _themeSelected(context, theme),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

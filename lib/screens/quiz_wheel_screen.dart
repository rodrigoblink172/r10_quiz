import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/app_shell.dart';       // <— novo
import 'package:r10_quiz/widgets/scoreHeader.dart';
import 'package:r10_quiz/components/roulette_wheel.dart';

class QuizWheelScreen extends StatelessWidget {
  const QuizWheelScreen({Key? key}) : super(key: key);

  void _themeSelected(BuildContext context, String theme) {
    // Exemplo 1: só mostrar um feedback
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      backgroundAsset: 'assets/images/background.png',
      topRight: const scoreHeader(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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

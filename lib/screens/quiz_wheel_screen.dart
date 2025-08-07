import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/header.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';
import 'package:r10_quiz/components/roulette_wheel.dart';

class QuizWheelScreen extends StatelessWidget {
  const QuizWheelScreen({Key? key}) : super(key: key);

  void _temaSelecionado(String tema) {
    print('Parou no tema: $tema');
    // aqui você pode navegar para o quiz ou carregar perguntas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'R10 Score'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: scoreHeader(),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Expanded(
                    child: RouletteWheel(
                      onFinish: _temaSelecionado,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

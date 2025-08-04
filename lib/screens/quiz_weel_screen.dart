import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/header.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';

class QuizWeelScreen extends StatelessWidget {
  const QuizWeelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'R10 Score'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_ronaldinho.png',
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
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  child: scoreHeader(),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

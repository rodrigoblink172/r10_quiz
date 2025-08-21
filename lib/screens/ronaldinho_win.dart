import 'dart:async';
import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/app_shell.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';

class RonaldinhoWinScreen extends StatefulWidget {
  const RonaldinhoWinScreen({
    super.key,
    required this.correct,
    required this.total,
  });

  final int correct;
  final int total;

  @override
  State<RonaldinhoWinScreen> createState() => _RonaldinhoWinScreenState();
}

class _RonaldinhoWinScreenState extends State<RonaldinhoWinScreen> {
  @override
  void initState() {
    super.initState();
    // Fecha após 3 segundos e volta para a Home
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      backgroundAsset: 'assets/images/ronaldinho_win.png',
      topRight: const scoreHeader(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding:  EdgeInsets.only(top: 350)),


            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset('assets/gif/trophy.gif', fit: BoxFit.contain),
            ),

            const SizedBox(height: 16),
            const Text(
              'Boa! Você mandou bem!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,
            
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Voltando para a Home…',
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 12),
            Text(
              'Você acertou ${widget.correct} de ${widget.total} perguntas.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

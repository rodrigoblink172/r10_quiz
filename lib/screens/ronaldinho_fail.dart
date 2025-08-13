import 'dart:async';
import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/app_shell.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';

class RonaldinhoFailScreen extends StatefulWidget {
  const RonaldinhoFailScreen({super.key});

  @override
  State<RonaldinhoFailScreen> createState() => _RonaldinhoFailScreenState();
}

class _RonaldinhoFailScreenState extends State<RonaldinhoFailScreen> {
  @override
  void initState() {
    super.initState();
    // Fecha após 3 segundos e volta pra Home
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AppShell(
      backgroundAsset: 'assets/images/ronaldinho_fail.png',
      topRight: scoreHeader(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding:  EdgeInsets.only(top: 350)),


            Icon(Icons.sentiment_dissatisfied, size: 100, color: Colors.redAccent),
            SizedBox(height: 16),
            Text(
              'Foi por pouco… 😬',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Voltando para a Home…',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

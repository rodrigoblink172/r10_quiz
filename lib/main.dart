import 'package:flutter/material.dart';
import 'package:r10_quiz/screens/home_screen.dart';

void main() {
  runApp(const Hyrule());
}

class Hyrule extends StatelessWidget {
  const Hyrule({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'R10 Quiz',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}



import 'dart:math';
import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import 'package:r10_quiz/widgets/header.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';

class QuizWheelScreen extends StatefulWidget {
  const QuizWheelScreen({Key? key}) : super(key: key);

  @override
  State<QuizWheelScreen> createState() => _QuizWheelScreenState();
}


class _QuizWheelScreenState extends State<QuizWheelScreen> {
  late RouletteController _controller;
  late RouletteGroup _group;

  final List<Color> sliceColors = [
    Colors.greenAccent,
    Colors.green,
    Colors.lightGreen,
    Colors.yellowAccent,
    Colors.yellow,
  ];

  bool isSpinning = false;

  @override
  void initState() {
    super.initState();

    final values = ['Jogadores', 'História', 'Títulos', 'Seleções', 'Clubes'];
    _group = RouletteGroup.uniform(
      values.length,
      colorBuilder: (index) => sliceColors[index],
      textBuilder: (index) => values[index],
      textStyleBuilder: (index) => const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    _controller = RouletteController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rollRoulette() async {
    setState(() => isSpinning = true);

    final index = Random().nextInt(_group.units.length);
    final offset = Random().nextDouble();

    await _controller.rollTo(
      index,
      offset: offset,
      duration: const Duration(seconds: 3),
    );

    final result = _group.units[index].text;
    print('Parou no tema: $result');

    setState(() => isSpinning = false);
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
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: scoreHeader(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Roulette(
                          controller: _controller,
                          group: _group,
                          style: const RouletteStyle(
                            dividerThickness: 4,
                            dividerColor: Colors.black,
                          ),
                        ),
                        const Positioned(
                          top: 90,
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 80,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: !isSpinning,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: ElevatedButton(
                      onPressed: _rollRoulette,
                      child: const Text('Girar Roleta'),
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

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import 'package:audioplayers/audioplayers.dart';


class RouletteWheel extends StatefulWidget {
  final void Function(String)? onFinish;

  const RouletteWheel({Key? key, this.onFinish}) : super(key: key);

  @override
  State<RouletteWheel> createState() => _RouletteWheelState();
}

class _RouletteWheelState extends State<RouletteWheel> {
  late RouletteController _controller;
  late RouletteGroup _group;
  bool isSpinning = false;

  final List<String> theme = ['Jogadores', 'História', 'Títulos', 'Seleções', 'Clubes', 'Regras'];

  final List<Color> sliceColors = [
    Colors.greenAccent,
    Colors.green,
    Colors.lightGreen,
    Colors.yellowAccent,
    Colors.yellow,
    Colors.orange,
  ];

  late final AudioPlayer _audioPlayer;


  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    _group = RouletteGroup.uniform(
      theme.length,
      colorBuilder: (index) => sliceColors[index],
      textBuilder: (index) => theme[index],
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
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _rollRoulette() async {
    setState(() => isSpinning = true);

    final index = Random().nextInt(_group.units.length);
    final offset = Random().nextDouble();

    await _controller.rollTo(
      index,
      offset: offset,
      duration: const Duration(seconds: 4),
    );

    final theme = _group.units[index].text;
    widget.onFinish?.call(theme!);

    setState(() => isSpinning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                top:110,
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 80,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: !isSpinning,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: ElevatedButton(
            onPressed: () async {
              await _audioPlayer.play(AssetSource('sounds/wheel_start.mp3'));
              await _rollRoulette(); 
            },
            child: const Text('Girar Roleta'),
            
          ),
        ),
      ],
    );
  }
}

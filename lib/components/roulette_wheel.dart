import 'dart:math';
import 'package:flutter/material.dart';
import 'package:r10_quiz/controllers/rewards_controller.dart';
import 'package:roulette/roulette.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart'; // HapticFeedback

class RouletteWheel extends StatefulWidget {
  final void Function(String)? onFinish;

  const RouletteWheel({Key? key, this.onFinish}) : super(key: key);

  @override
  State<RouletteWheel> createState() => _RouletteWheelState();
}

class _RouletteWheelState extends State<RouletteWheel> {
  late RouletteController _controller;
  late RouletteGroup _group;
  late final AudioPlayer _audioPlayer;

  bool isSpinning = false;

  // Labels dos temas
  final List<String> themes = const [
    'Jogadores',
    'História',
    'Títulos',
    'Seleções',
    'Clubes',
    'Regras',
  ];

  // Cores das fatias (uma por tema)
  final List<Color> sliceColors = const [
    Colors.greenAccent,
    Colors.green,
    Colors.lightGreen,
    Colors.yellowAccent,
    Colors.yellow,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();

    assert(
      sliceColors.length == themes.length,
      'sliceColors e themes precisam ter o mesmo tamanho',
    );

    _audioPlayer = AudioPlayer();

    _group = RouletteGroup.uniform(
      themes.length,
      colorBuilder: (index) => sliceColors[index],
      textBuilder: (index) => themes[index],
      textStyleBuilder: (index) {
        // Ajusta contraste do texto na fatia
        final color = sliceColors[index];
        final useDarkText = color.computeLuminance() > 0.6;
        return TextStyle(
          color: useDarkText ? Colors.black : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );
      },
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
    if (isSpinning) return;

    setState(() => isSpinning = true);
    try {
      // feedback tátil
      HapticFeedback.lightImpact();

      final index = Random().nextInt(_group.units.length);
      final offset = Random().nextDouble();

      await _controller.rollTo(
        index,
        offset: offset,
        duration: const Duration(seconds: 4),
      );

      if (!mounted) return;

      final selectedTheme = _group.units[index].text;
      if (selectedTheme != null) {
        widget.onFinish?.call(selectedTheme);
      }
    } finally {
      if (mounted) {
        setState(() => isSpinning = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Distância (em px) entre a borda da roleta e a seta
    const double edgeGap = 8.0;
    const double pointerSize = 80.0;

    return Column(
      children: [
        // A área da roleta cresce para ocupar o espaço disponível.
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // A roleta desenha um círculo ocupando o menor lado disponível.
              final double wheelSize =
                  min(constraints.maxWidth, constraints.maxHeight);
              final double radius = wheelSize / 2;

              // Queremos posicionar a seta a partir do CENTRO, para cima.
              // offsetY negativo sobe a seta. Consideramos metade da seta,
              // para a ponta encostar na borda com uma folga (edgeGap).
              final double pointerOffsetY =
                  -(radius + edgeGap - (pointerSize / 2)) - 50;

              return Stack(
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
                  Transform.translate(
                    offset: Offset(0, pointerOffsetY),
                    child: const Icon(
                      Icons.arrow_drop_down,
                      size: pointerSize,
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: !isSpinning,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F378A),
              foregroundColor: Colors.white,
              minimumSize: const Size(188, 50), // Tamanho mínimo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Borda arredondada
              ),
              elevation: 4, // Sombra
            ),
            onPressed: () async {
              RewardsController.instance.startNewGame();
              // Tenta tocar o áudio; se falhar, apenas ignora e gira.
              try {
                await _audioPlayer.play(
                  AssetSource('sounds/wheel_start.mp3'),
                );
              } catch (e) {
                debugPrint('Falha ao tocar áudio: $e');
              }
              await _rollRoulette();
            },
            child: const Text(
              'GIRAR ROLETA',
              style: TextStyle(fontSize: 20),
            ),
          ),

          
        ),
      ],
    );
  }
}

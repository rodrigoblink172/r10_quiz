import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:r10_quiz/config/colors.dart';
import 'package:r10_quiz/screens/ranking_screen.dart';
import 'package:r10_quiz/controllers/rewards_controller.dart';

class scoreHeader extends StatelessWidget {
  const scoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final rewards = RewardsController.instance;

    return AnimatedBuilder(
      animation: rewards,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.boxButton,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.only(top: 2, bottom: 0, left: 5),
              width: 215,
              height: 38,
              child: Row(
                children: [
                  // HATS
                  GestureDetector(
                    onTap: () async {
                      final player = AudioPlayer();
                      await player.play(AssetSource('sounds/hat.mp3'));
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (dialogContext) {
                          Future.delayed(const Duration(seconds: 3), () {
                            if (Navigator.of(dialogContext).canPop()) {
                              Navigator.of(dialogContext).pop(true);
                            }
                          });
                          return const AlertDialog(
                            content: Text('Funcionalidade indisponível no momento'),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Image.asset(
                            'assets/images/hat_icon.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const SizedBox(width: 0),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4, right: 30),
                          child: Text(
                            '${rewards.hats}', // dinâmico
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // COINS
                  GestureDetector(
                    onTap: () async {
                      final player = AudioPlayer();
                      await player.play(AssetSource('sounds/coins.mp3'));
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (dialogContext) {
                          Future.delayed(const Duration(seconds: 3), () {
                            if (Navigator.of(dialogContext).canPop()) {
                              Navigator.of(dialogContext).pop(true);
                            }
                          });
                          return const AlertDialog(
                            content: Text('Funcionalidade indisponível no momento'),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/coin_icon.png',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 0),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${rewards.coins}', // dinâmico
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // BOTÃO RANKING
            Container(
              decoration: BoxDecoration(
                color: AppColors.boxButton,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.only(top: 2, bottom: 0),
              margin: const EdgeInsets.only(left: 15),
              width: 60,
              height: 40,
              child: GestureDetector(
                onTap: () {
                  final currentRout = ModalRoute.of(context)?.settings.name;
                  if (currentRout != '/ranking') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RankingScreen(),
                        settings: const RouteSettings(name: '/ranking'),
                      ),
                    );
                  }
                },
                child: Image.asset(
                  'assets/images/ranking_icon.png',
                  width: 100,
                  height: 50,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

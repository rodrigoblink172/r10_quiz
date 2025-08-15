import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:r10_quiz/config/colors.dart';
import 'package:r10_quiz/screens/ranking_screen.dart';
import 'package:r10_quiz/controllers/rewards_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HatsText extends StatelessWidget {
  const HatsText({super.key, this.style});
  final TextStyle? style;

  @override Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userDoc, 
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Text('0', style: style); 
        }
        final data = snap.data?.data();
        final raw = data?['hats'] ?? 0;
        final hats = raw is int ? raw : (raw as num).toInt();

        return Text('$hats', style: style);
          },
        );
      }
    
  }





class CoinsText extends StatelessWidget {
  const CoinsText({super.key, this.style});
  final TextStyle? style;


  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userDoc,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Text('0', style: style); 
        }
        final data = snap.data?.data();
        final raw = data?['coins'] ?? 0;
        final coins = raw is int ? raw : (raw as num).toInt(); 

        return Text('$coins', style: style);
      },
    );
  }
}


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
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4, right: 30),
                          child: HatsText(
                            style: TextStyle( // dinâmico
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
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: CoinsText(
                             style: TextStyle(
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

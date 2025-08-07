import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/header.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}


class _RankingScreenState extends State<RankingScreen> {



  bool isSpinning = false;

  @override
  void initState() {
    super.initState();



  }

  @override
  void dispose() {
    super.dispose();
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
                  
                  const SizedBox(height:20),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          child: Image.asset(
                            'assets/images/ranking_trophy.png',
                            width: 125,
                            height: 125,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 475),
                      child: Text(
                        'Temporada 7',
                        style: TextStyle(
                          fontSize: 28, 
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Heading',
                          shadows: [
                            Shadow(offset: Offset(2, 2),
                            blurRadius: 4
                            )
                            
                            ] 
                          ),
                      ),
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

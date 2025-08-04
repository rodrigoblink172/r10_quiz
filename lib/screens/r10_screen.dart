import 'package:flutter/material.dart';
import 'package:r10_quiz/screens/home_screen.dart';

class R10Screen extends StatelessWidget {
  const R10Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/r10_mais.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(

            padding: const EdgeInsets.only(bottom: 85),
            child: Align(
              
            child: GestureDetector(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Home() ));
            },
             child: Container(
              width: 580,
              height: 70,
              color: Colors.transparent,
             )
             ,)
            ),
            
            ),
          ),

        ],
      ),
    );
  }
}

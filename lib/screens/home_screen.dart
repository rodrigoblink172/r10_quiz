import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/header.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'R10 Score'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_ronaldinho.png',
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  child: scoreHeader(),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 580),
                    child: ElevatedButton(onPressed: (){print('123');},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 79, 55, 138),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(188, 50),
                    ),
                     child: const Text('COMEÇAR QUIZ',
                      style: TextStyle(fontSize: 20),
                    ),
                    ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

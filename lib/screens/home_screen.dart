import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/background_ronaldinho.png',
                fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //implementar action
                          },
                          child: const Text ('chapeu'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //implementar action
                          },
                          child: const Text ('coin'),
                        )
                      ],
                    ),
                    
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

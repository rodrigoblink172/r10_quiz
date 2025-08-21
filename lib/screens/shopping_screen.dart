import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/app_shell.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';

class ShoppingScreen extends StatelessWidget {
    const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {    return AppShell(
      backgroundAsset: 'assets/images/background.png',
      topRight: const scoreHeader(), 
      child: SizedBox(

        width: 120,
              height: 120,
              child: Image.asset('assets/gif/shopping_breve.gif', fit: BoxFit.contain),

      ),
    );}
}

  


  


      
import 'package:flutter/material.dart';
import 'package:r10_quiz/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const R10());
}



class R10 extends StatelessWidget {
  const R10({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'R10 Quiz',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const LoginScreen(),

    );
  }
}



// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:r10_quiz/screens/home_screen.dart'; // classe HomeScreen

// >>> cria/atualiza o doc do usuário em users/<uid>
Future<void> ensureUserDoc(User user) async {
  final uid = user.uid;
  final email = user.email ?? '';
  final nome = user.displayName ?? '';

  final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

  await FirebaseFirestore.instance.runTransaction((tx) async {
    final snap = await tx.get(userRef);
    final now = FieldValue.serverTimestamp();

    if (snap.exists) {
      tx.update(userRef, {'updatedAt': now});
    } else {
      tx.set(userRef, {
        'email': email,
        'nome': nome,
        'score': 0,
        'stats': {'acertos': 0, 'erros': 0},
        'coins': 0,
        'level': 1,
        'hats': 0,
        'myItems': [],
        'myItemsUpdatedAt': now,
        'createdAt': now,
        'updatedAt': now,
      });
    }
  });
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  Future<UserCredential> _googleSignIn() async {
    final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
    if (googleUser == null) throw Exception('Login cancelado pelo usuário');
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _entrar() async {
    setState(() => _loading = true);
    try {
      await _googleSignIn();

      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;
      if (user == null || email == null) {
        throw Exception('Não foi possível obter o e-mail do usuário.');
      }

      // >>> checa autorização por e-mail: allowed/<email>
      final snap = await FirebaseFirestore.instance
          .collection('allowed')
          .doc(email) // usar o e-mail exatamente como veio do Auth
          .get();

      if (snap.exists) {
        // >>> aqui é o ponto: cria/atualiza users/<uid> ANTES de navegar
        await ensureUserDoc(user);

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Home()),
        );
      } else {
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
        _snack('Seu e-mail não está autorizado.');
      }
    } catch (e) {
      _snack('Erro ao entrar: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo ao R10 Quiz',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 240,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _entrar,
                  icon: const Icon(Icons.login),
                  label: Text(_loading ? 'Entrando…' : 'Entrar com o Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F378A),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _loading
                    ? null
                    : () async {
                        await GoogleSignIn().signOut();
                        await FirebaseAuth.instance.signOut();
                        _snack('Saiu da conta.');
                      },
                child: const Text('Sair (debug)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

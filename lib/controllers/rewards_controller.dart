import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardsController extends ChangeNotifier {
  RewardsController._();
  static final RewardsController instance = RewardsController._();

  int _coins = 0;
  int _hats  = 0;
  int _correct = 0;

  int get coins => _coins;
  int get hats  => _hats;
  int get correct => _correct;

  void startNewGame() {
    _correct = 0;
    notifyListeners();
  }

  /// [correct] = acertos da partida
  /// [totalQuestions] = total de perguntas da partida (ex.: 10)
  Future<void> registerFinalScore(int correct, {required int totalQuestions}) async {
    _correct = correct;

    final int wrong        = (totalQuestions - correct).clamp(0, totalQuestions);
    final int earnedCoins  = correct * 5;          // regra existente
    final int earnedHats   = (correct ~/ 5) * 2;   // regra existente
    final int matchPoints  = earnedCoins * 3;      // PTS = moedas * 3

    // atualiza memória local (se algum lugar da UI usar o controller direto)
    _coins += earnedCoins;
    _hats  += earnedHats;
    notifyListeners();

    // persiste no Firestore (Ranking lê daqui)
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = FirebaseFirestore.instance.collection('users').doc(uid);

      await doc.set({
        // economia do jogo
        'coins'     : FieldValue.increment(earnedCoins),
        'hats'      : FieldValue.increment(earnedHats),

        // ranking
        'score'     : FieldValue.increment(matchPoints), // PTS
        'acertos'   : FieldValue.increment(correct),      // V
        'erros'     : FieldValue.increment(wrong),        // D

        // se você também guarda em um mapa "stats", mantemos em sincronia:
        'stats.acertos': FieldValue.increment(correct),
        'stats.erros'  : FieldValue.increment(wrong),

        // utilidades
        'lastScore' : matchPoints,
        'updatedAt' : FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}

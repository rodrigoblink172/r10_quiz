import 'package:flutter/foundation.dart';

class RewardsController extends ChangeNotifier {
  RewardsController._();
  static final RewardsController instance = RewardsController._();

  int _coins = 0;   
  int _hats = 0;    
  int _correct = 0; 

  int get coins => _coins;
  int get hats => _hats;
  int get correct => _correct;


  void startNewGame() {
    _correct = 0;       
    notifyListeners();  
  }


  void registerFinalScore(int score) {
    _correct = score;

    final int earnedCoins = score * 5;            
    final int earnedHats  = (score ~/ 5) * 2;     

    _coins += earnedCoins;
    _hats  += earnedHats;

    notifyListeners(); 
  }


}

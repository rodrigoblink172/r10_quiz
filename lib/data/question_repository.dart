import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/questions.dart';

class QuestionRepository {
  /// Carrega um QuestionPack a partir de um arquivo JSON nos assets.
  ///
  /// Ex.: `assets/data/historia.json`
  Future<QuestionPack> loadFromAsset(String path) async {
    final jsonStr = await rootBundle.loadString(path);
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    return QuestionPack.fromMap(map);
  }

  /// (Opcional) Helper: se quiser mapear categoria -> caminho aqui.
  /// Use se preferir centralizar o mapeamento (senão, pode manter na tela).
  Future<QuestionPack> loadByCategory(String category) async {
    final path = _assetPathForCategory(category);
    return loadFromAsset(path);
  }

  String _assetPathForCategory(String category) {
    switch (category) {
      case 'História':
        return 'assets/data/history.json';
      case 'Jogadores':
        return 'assets/data/players.json';
      case 'Regras':
        return 'assets/data/rules.json';
      case 'Clubes':
        return 'assets/data/teams.json';
      case 'Títulos':
        return 'assets/data/titles.json';
      case 'Seleções':
        return 'assets/data/worldTeams.json';
      default:
      // Fallback: normaliza acentos e minúsculas para tentar um arquivo compatível.
        final normalized = category
            .toLowerCase()
            .replaceAll('á', 'a')
            .replaceAll('à', 'a')
            .replaceAll('â', 'a')
            .replaceAll('ã', 'a')
            .replaceAll('é', 'e')
            .replaceAll('ê', 'e')
            .replaceAll('í', 'i')
            .replaceAll('ó', 'o')
            .replaceAll('ô', 'o')
            .replaceAll('õ', 'o')
            .replaceAll('ú', 'u')
            .replaceAll('ç', 'c');
        return 'assets/data/$normalized.json';
    }
  }
}

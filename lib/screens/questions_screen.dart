import 'dart:math';
import 'package:flutter/material.dart';
import 'package:r10_quiz/screens/ronaldinho_fail.dart';
import 'package:r10_quiz/screens/ronaldinho_win.dart';
import 'package:r10_quiz/widgets/app_shell.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';
import 'package:r10_quiz/models/questions.dart';
import 'package:r10_quiz/data/question_repository.dart';
import 'package:r10_quiz/controllers/rewards_controller.dart';


class QuestionScreen extends StatefulWidget {
  const QuestionScreen({
    super.key,
    required this.category, // Ex.: "História"
  });

  final String category;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _repo = QuestionRepository();
  late Future<QuestionPack> _futurePack;

  int _currentIndex = 0;
  int _score = 0;

  List<AnswerOption>? _shuffled;
  String? _selectedId;
  bool _locked = false;

  late final int _sessionSeed;

  @override
  void initState() {
    super.initState();
    RewardsController.instance.startNewGame();
    _sessionSeed = DateTime.now().millisecondsSinceEpoch % 1000000;
    _futurePack = _repo.loadFromAsset(_assetPathForCategory(widget.category));
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

  List<AnswerOption> _buildShuffledOptions(Question q) {
    if (_shuffled != null) return _shuffled!;
    final list = List<AnswerOption>.from(q.options);
    final seed = _sessionSeed ^ q.id.hashCode;
    list.shuffle(Random(seed));
    _shuffled = list;
    return _shuffled!;
  }

  void _onSelect(Question q, AnswerOption opt) {
    if (_locked) return;
    final isCorrect = q.isCorrect(opt.id);
    setState(() {
      _selectedId = opt.id;
      _locked = true;
      if (isCorrect) _score++;
    });

    //RewardsController.instance.registerAnswer(isCorrect: isCorrect);


    
  }

  void _next(QuestionPack pack) {
    if (_currentIndex + 1 < pack.questions.length) {
      setState(() {
        _currentIndex++;
        _selectedId = null;
        _locked = false;
        _shuffled = null;
      });
    } else {
      _finish(pack);
    }
  }

  void _finish(QuestionPack pack) async {
  final int total = pack.questions.length; 
  RewardsController.instance.registerFinalScore(_score);

  if (!mounted) return;

  final Widget result = _score == 0
      ? const RonaldinhoFailScreen()
      : RonaldinhoWinScreen( 
          correct: _score,
          total: total,
      );

  await Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => result,
      settings: const RouteSettings(name: '/quiz_result'),
    ),
  );
}




  @override
  Widget build(BuildContext context) {
    return AppShell(
      backgroundAsset: 'assets/images/background.png',
      topRight: const scoreHeader(),
      child: FutureBuilder<QuestionPack>(
        future: _futurePack,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return Center(
              child: Text(
                'Erro ao carregar perguntas de "${widget.category}".',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            );
          }

          final pack = snap.data!;
          if (pack.questions.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma pergunta disponível.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final q = pack.questions[_currentIndex];
          final options = _buildShuffledOptions(q);
          final total = pack.questions.length;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProgressHeader(
                    category: pack.category,
                    current: _currentIndex + 1,
                    total: total,
                  ),
                  const SizedBox(height: 20),
                  _QuestionCard(text: q.question),
                  const SizedBox(height: 20),
                  ...options.map((opt) {
                    final isSelected = _selectedId == opt.id;
                    final isCorrect = q.isCorrect(opt.id);

                    Color border = Colors.black12;
                    if (_locked) {
                      if (isCorrect) {
                        border = Colors.green;
                      } else if (isSelected) {
                        border = Colors.red;
                      }
                    }

                    

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OptionTile(
                        label: opt.text,
                        onTap: () => _onSelect(q, opt),
                        borderColor: border,
                        enabled: !_locked,
                        isCorrectForRipple: isCorrect,
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _selectedId == null ? null : () => _next(pack),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F378A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(
                      _currentIndex + 1 < total ? 'Próxima' : 'Finalizar',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.category,
    required this.current,
    required this.total,
  });

  final String category;
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$category - $current / $total',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.onTap,
    this.borderColor,
    this.enabled = true,
    required this.isCorrectForRipple,
  });

  final String label;
  final VoidCallback onTap;
  final Color? borderColor;
  final bool enabled;
  final bool isCorrectForRipple;

  @override
  Widget build(BuildContext context) {
    // Cor do efeito ao clicar
    final overlay = MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.pressed)) {
        return (isCorrectForRipple ? Colors.green : Colors.red).withOpacity(0.80);
      }
      if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
        return Colors.black12; // opcional
      }
      return null;
    });

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        overlayColor: overlay,        // << AQUI COLORIMOS O RIPPLE
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor ?? Colors.black12, width: 2),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

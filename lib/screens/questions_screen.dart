import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    required this.category,
  });

  final String category;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> with TickerProviderStateMixin {
  final _repo = QuestionRepository();
  late Future<QuestionPack> _futurePack;

  int _currentIndex = 0;
  int _score = 0;

  List<AnswerOption>? _shuffled;
  String? _selectedId;
  bool _locked = false;

  late final int _sessionSeed;

  // ===== Timer por pergunta (barra que esvazia) =====
  static const int _timePerQuestionSeconds = 12; // ajuste como quiser
  late AnimationController _timerController;
  QuestionPack? _pack; // referência ao pack sorteado com 10 perguntas

  @override
  void initState() {
    super.initState();
    RewardsController.instance.startNewGame();
    _sessionSeed = DateTime.now().millisecondsSinceEpoch % 1000000;
    _futurePack = _repo.loadFromAsset(_assetPathForCategory(widget.category));

    // Quando carregar, sorteia 10 e inicia o timer da 1ª pergunta
    _futurePack.then((value) {
      if (!mounted) return;

      final allQuestions = List<Question>.from(value.questions);
      allQuestions.shuffle(Random());
      final selectedQuestions = allQuestions.take(10).toList();

      final packSorteado = QuestionPack(
        category: value.category,
        questions: selectedQuestions,
      );

      setState(() => _pack = packSorteado);
      _startTimer();
    });

    // Controller da barra de tempo (0→1 internamente; visual usamos 1→0)
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _timePerQuestionSeconds),
    );

    // Quando completar a duração (barra vazia), conta como errada e avança
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onTimeUp();
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
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

  // ==== Timer helpers ====
  void _startTimer() {
    if (!mounted) return;
    _timerController
      ..reset()
      ..forward();
  }

  void _pauseTimer() {
    if (_timerController.isAnimating) {
      _timerController.stop();
    }
  }

  void _onTimeUp() {
    // Se já está travado por seleção, não faz nada
    if (_locked) return;

    setState(() {
      _locked = true;   // usuário não respondeu no tempo → conta como errada
      _selectedId = null;
    });

    // Avança automaticamente (pequeno delay para feedback, se quiser animar algo)
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted || _pack == null) return;
      _next(_pack!);
    });
  }

  void _onSelect(Question q, AnswerOption opt) {
    if (_locked) return;
    final isCorrect = q.isCorrect(opt.id);

    _pauseTimer(); // para o timer ao selecionar

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
      _startTimer(); // reinicia a barra na próxima pergunta
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

          // Usa o pack sorteado (10 perguntas) quando disponível
          final pack = _pack ?? snap.data!;

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

                  const SizedBox(height: 10),

                  // ===== Barra de tempo (sem números) =====
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: AnimatedBuilder(
                        animation: _timerController,
                        builder: (context, _) {
                          final double fill = (1.0 - _timerController.value).clamp(0.0, 1.0);
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: fill,
                            child: Container(
                              color: const Color(0xFF4F378A),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

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
    return SizedBox(
      height: 120, // altura fixa para todas as perguntas
      child: Container(
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
        child: AutoSizeText(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20, // tamanho máximo
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,       // permite até 3 linhas
          minFontSize: 14,   // nunca menor que 14
          overflow: TextOverflow.ellipsis,
        ),
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
        return Colors.black12;
      }
      return null;
    });

    return SizedBox(
      height: 60, // altura fixa para todas as opções
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          overlayColor: overlay, // ripple color
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor ?? Colors.black12, width: 2),
            ),
            child: Center(
              child: AutoSizeText(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16, // tamanho máximo
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,       // até 2 linhas nas opções
                minFontSize: 12,   // nunca menor que 12
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

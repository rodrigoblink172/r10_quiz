import 'dart:math';

/// Uma alternativa de resposta (ex.: {"id": "a", "text": "Pelé"})
class AnswerOption {
  final String id;
  final String text;

  const AnswerOption({required this.id, required this.text});

  factory AnswerOption.fromMap(Map<String, dynamic> map) {
    return AnswerOption(
      id: map['id'] as String,
      text: map['text'] as String,
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'text': text};
}

/// Uma pergunta com alternativas e a referência da alternativa correta por ID.
class Question {
  final String id;
  final String question; // enunciado
  final List<AnswerOption> options;
  final String correctAnswerId;

  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerId,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
// Fallback: aceita "text" como nome legado do enunciado (além de "question")
    final String prompt = (map['question'] ?? map['text']) as String;

    final rawOptions = map['options'] as List;
// Suporta tanto [{id,text}] quanto ["texto1","texto2",...]
    final options = rawOptions.isNotEmpty && rawOptions.first is Map
        ? rawOptions
            .map((o) => AnswerOption.fromMap(o as Map<String, dynamic>))
            .toList()
        : List<AnswerOption>.from(
            rawOptions
                .map((t) => AnswerOption(id: t.toString(), text: t.toString())),
          );

    final q = Question(
      id: map['id'] as String,
      question: prompt,
      options: options,
      correctAnswerId: map['correct_answer_id'] as String,
    );

// Validações simples em tempo de execução (ajudam a achar erros no JSON)
    assert(q.options.isNotEmpty, 'Question "${q.id}" sem opções.');
    assert(
      q.options.any((o) => o.id == q.correctAnswerId),
      'Question "${q.id}" com correct_answer_id inexistente: ${q.correctAnswerId}',
    );

    return q;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'question': question,
        'options': options.map((e) => e.toMap()).toList(),
        'correct_answer_id': correctAnswerId,
      };

  /// Verifica se o ID selecionado é o correto.
  bool isCorrect(String selectedId) => selectedId == correctAnswerId;

  /// Retorna uma **nova** lista de opções embaralhada.
  /// Use um [seed] para ter ordem estável durante a sessão (opcional).
  List<AnswerOption> shuffledOptions([int? seed]) {
    final list = List<AnswerOption>.from(options);
    list.shuffle(seed != null ? Random(seed) : Random());
    return list;
  }

  /// Retorna a opção correta (útil para feedback).
  AnswerOption get correctOption =>
      options.firstWhere((o) => o.id == correctAnswerId);
}

/// Pacote de perguntas por categoria.
class QuestionPack {
  final String category;
  final List<Question> questions;

  const QuestionPack({
    required this.category,
    required this.questions,
  });

  factory QuestionPack.fromMap(Map<String, dynamic> map) {
    final qs = (map['questions'] as List)
        .map((q) => Question.fromMap(q as Map<String, dynamic>))
        .toList();

    return QuestionPack(
      category: map['category'] as String,
      questions: qs,
    );
  }

  Map<String, dynamic> toMap() => {
        'category': category,
        'questions': questions.map((e) => e.toMap()).toList(),
      };
}

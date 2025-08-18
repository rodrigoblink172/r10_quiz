import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:r10_quiz/widgets/app_shell.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';
import 'package:r10_quiz/generated/assets.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5B4DA6);
    const darkPurple = Color(0xFF433A63);
    const cardBorder = Color(0xFFFFD54F);
    const headerText = Colors.white;

    final uid = FirebaseAuth.instance.currentUser?.uid;

    // Apenas 1 orderBy para não exigir índice composto
    final stream = FirebaseFirestore.instance
        .collection('users')
        .orderBy('score', descending: true)
        .limit(200)
        .snapshots();

    return AppShell(
      backgroundAsset: 'assets/images/background.png',
      topRight: const scoreHeader(),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Erro ao carregar ranking: ${snap.error}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Ainda não há jogadores no ranking.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // Mapeia usuários e aplica desempate no cliente
          final users = docs.map(_RankingUser.fromDoc).toList()
            ..sort((a, b) {
              final byScore = b.score.compareTo(a.score);
              if (byScore != 0) return byScore;
              final byAcertos = b.acertos.compareTo(a.acertos);
              if (byAcertos != 0) return byAcertos;
              return a.erros.compareTo(b.erros); // menos erros primeiro
            });

          final highlightIndex = uid == null
              ? null
              : users.indexWhere((u) => u.id == uid);

          // Usuário do chip superior (ou topo do ranking se não logado)
          final me = (highlightIndex != null && highlightIndex >= 0)
              ? users[highlightIndex]
              : users.first;

          // Converte para linhas da tabela
          final rows = <_RankingRow>[];
          for (var i = 0; i < users.length; i++) {
            final u = users[i];
            rows.add(
              _RankingRow(
                id: u.id,
                position: i + 1,
                name: u.nome,
                pts: u.score,
                v: u.acertos,
                d: u.erros,
                n: 0,
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            Assets.imagesRankingTrophy,
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ranking',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  blurRadius: 6,
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Chip com o usuário destacado
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: purple,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1F000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              _pill(
                                '${rows.firstWhere(
                                  (r) => r.id == me.id,
                                  orElse: () => rows.first,
                                ).position}',
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  me.nome,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              _miniStat('${me.score}'),
                              _miniStat('${me.acertos}'),
                              _miniStat('${me.erros}'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Liga de teste interno',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  blurRadius: 6,
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.military_tech,
                              color: Colors.amber.shade400, size: 32),
                        ],
                      ),

                      const SizedBox(height: 16),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Container(
                          decoration: BoxDecoration(
                            color: darkPurple,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: cardBorder, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x2A000000),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: _RankingTable(
                            rows: rows,
                            highlightRowIndex: (highlightIndex != null &&
                                    highlightIndex >= 0)
                                ? highlightIndex
                                : null,
                            headerColor: headerText,
                            rowTextColor: Colors.white.withOpacity(0.95),
                            background: darkPurple,
                            highlightColor: purple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ===================== MODELOS =====================

class _RankingUser {
  final String id;
  final String nome;
  final int score;
  final int acertos;
  final int erros;

  _RankingUser({
    required this.id,
    required this.nome,
    required this.score,
    required this.acertos,
    required this.erros,
  });

  static int _toInt(dynamic x) {
    if (x is int) return x;
    if (x is num) return x.toInt();
    return 0;
  }

  static _RankingUser fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    final stats = (d['stats'] as Map<String, dynamic>?) ?? {};
    final nome = (d['nome'] as String?)?.trim();
    return _RankingUser(
      id: doc.id,
      nome: (nome != null && nome.isNotEmpty)
          ? nome
          : (d['displayName'] as String?) ??
              (d['email'] as String?) ??
              'Jogador',
      score: _toInt(d['score']),
      acertos: _toInt(d['acertos'] ?? stats['acertos']),
      erros: _toInt(d['erros'] ?? stats['erros']),
    );
  }
}

class _RankingRow {
  final String id;
  final int position;
  final String name;
  final int pts;
  final int v;
  final int d;
  final int n;
  const _RankingRow({
    required this.id,
    required this.position,
    required this.name,
    required this.pts,
    required this.v,
    required this.d,
    required this.n,
  });
}

// ===================== TABELA =====================

class _RankingTable extends StatelessWidget {
  const _RankingTable({
    required this.rows,
    required this.highlightRowIndex,
    required this.headerColor,
    required this.rowTextColor,
    required this.background,
    required this.highlightColor,
  });

  final List<_RankingRow> rows;
  final int? highlightRowIndex;
  final Color headerColor;
  final Color rowTextColor;
  final Color background;
  final Color highlightColor;

  static const _posWidth = 28.0;
  static const _ptsWidth = 44.0;
  static const _vWidth = 36.0;
  static const _dWidth = 36.0;
  static const _rowH = 30.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: background.withOpacity(0.85),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              SizedBox(
                width: _posWidth,
                child: Text('#',
                    style: _headerStyle(headerColor),
                    textAlign: TextAlign.right),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Nome',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              SizedBox(
                width: _ptsWidth,
                child: Text('PTS',
                    style: _headerStyle(headerColor),
                    textAlign: TextAlign.right),
              ),
              SizedBox(
                width: _vWidth,
                child: Text('V',
                    style: _headerStyle(headerColor),
                    textAlign: TextAlign.right),
              ),
              SizedBox(
                width: _dWidth,
                child: Text('D',
                    style: _headerStyle(headerColor),
                    textAlign: TextAlign.right),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        ...List.generate(rows.length, (index) {
          final r = rows[index];
          final isHighlight = highlightRowIndex == index;

          return Container(
            height: _rowH,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: isHighlight ? highlightColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                  width: _posWidth,
                  child: Text(
                    '${r.position}',
                    textAlign: TextAlign.right,
                    style: _rowStyle(rowTextColor.withOpacity(0.9)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    r.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _rowStyle(rowTextColor),
                  ),
                ),
                SizedBox(
                  width: _ptsWidth,
                  child: Text('${r.pts}',
                      textAlign: TextAlign.right,
                      style: _rowStyle(rowTextColor)),
                ),
                SizedBox(
                  width: _vWidth,
                  child: Text('${r.v}',
                      textAlign: TextAlign.right,
                      style: _rowStyle(rowTextColor)),
                ),
                SizedBox(
                  width: _dWidth,
                  child: Text('${r.d}',
                      textAlign: TextAlign.right,
                      style: _rowStyle(rowTextColor)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  TextStyle _headerStyle(Color c) =>
      TextStyle(fontWeight: FontWeight.w700, color: c, fontSize: 13);

  TextStyle _rowStyle(Color c) =>
      TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w500);
}

// ===================== WIDGETS AUXILIARES =====================

Widget _pill(String text) {
  return Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.black87, width: 2),
      boxShadow: const [
        BoxShadow(color: Color(0x26000000), blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
    alignment: Alignment.center,
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
  );
}

Widget _miniStat(String value) {
  return Container(
    width: 42,
    alignment: Alignment.centerRight,
    child: Text(
      value,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
  );
}

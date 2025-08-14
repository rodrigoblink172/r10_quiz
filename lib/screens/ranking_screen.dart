import 'package:flutter/material.dart';
import 'package:r10_quiz/generated/assets.dart';
import 'package:r10_quiz/widgets/app_shell.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart'; // se for função, mantenha scoreHeader()

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const purple = Color(0xFF5B4DA6);
    const darkPurple = Color(0xFF433A63);
    const cardBorder = Color(0xFFFFD54F);
    const headerText = Colors.white;
    
    final rows = const [
      _RankingRow(position: 1, name: 'CobradaBola123', pts: 99, v: 54, d: 12, n: 0),
      _RankingRow(position: 2, name: 'Ronaldo98',       pts: 99, v: 54, d: 12, n: 0),
      _RankingRow(position: 3, name: 'NavySeal',        pts: 99, v: 54, d: 12, n: 0),
      _RankingRow(position: 4, name: 'Luiz1234',        pts: 99, v: 54, d: 12, n: 0),
      _RankingRow(position: 5, name: 'Boldrin',         pts: 99, v: 54, d: 12, n: 0),
      _RankingRow(position: 6, name: 'CobradaBola123',  pts: 99, v: 54, d: 12, n: 0),
      _RankingRow(position: 7, name: 'Ronaldo98',       pts: 99, v: 54, d: 12, n: 0), // linha destacada
      _RankingRow(position: 8, name: 'NavySeal',        pts: 99, v: 54, d: 12, n: 0),
      _RankingRow(position: 9, name: 'Luiz1234',        pts: 99, v: 54, d: 12, n: 0),
      _RankingRow(position: 10, name: 'Boldrin',        pts: 99, v: 54, d: 12, n: 0),
    ];

    return AppShell(
      backgroundAsset: 'assets/images/background.png',
      topRight: const scoreHeader(), // se for widget/classe, troque para const ScoreHeader()
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
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
                            Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Chip roxo com o usuário em destaque e mini estatísticas
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          _pill('7'),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Ronaldo98',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          _miniStat('99'),
                          _miniStat('54'),
                          _miniStat('12'),
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
                            Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.military_tech, color: Colors.amber.shade400, size: 32),
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
                        highlightRowIndex: 6, // zero-based; 6 == posição 7
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
      ),
    );
  }
}

class _RankingRow {
  final int position;
  final String name;
  final int pts;
  final int v;
  final int d;
  final int n;
  const _RankingRow({
    required this.position,
    required this.name,
    required this.pts,
    required this.v,
    required this.d,
    required this.n,
  });
}

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
  static const _vWidth   = 36.0;
  static const _dWidth   = 36.0;
  static const _rowH     = 30.0;

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
              SizedBox(width: _posWidth, child: Text('#', style: _headerStyle(headerColor), textAlign: TextAlign.right)),
              const SizedBox(width: 12),
              const Expanded(child: Text('Nome', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white))),
              SizedBox(width: _ptsWidth, child: Text('PTS', style: _headerStyle(headerColor), textAlign: TextAlign.right)),
              SizedBox(width: _vWidth,   child: Text('V',   style: _headerStyle(headerColor), textAlign: TextAlign.right)),
              SizedBox(width: _dWidth,   child: Text('D',   style: _headerStyle(headerColor), textAlign: TextAlign.right)),
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

                // nome (expande e trunca)
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
                  child: Text('${r.pts}', textAlign: TextAlign.right, style: _rowStyle(rowTextColor)),
                ),
                SizedBox(
                  width: _vWidth,
                  child: Text('${r.v}', textAlign: TextAlign.right, style: _rowStyle(rowTextColor)),
                ),
                SizedBox(
                  width: _dWidth,
                  child: Text('${r.d}', textAlign: TextAlign.right, style: _rowStyle(rowTextColor)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  TextStyle _headerStyle(Color c) => TextStyle(
    fontWeight: FontWeight.w700,
    color: c,
    fontSize: 13,
  );

  TextStyle _rowStyle(Color c) => TextStyle(
    color: c,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}



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
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w800),
    ),
  );
}

Widget _miniStat(String value) {
  return Container(
    width: 42,
    alignment: Alignment.centerRight,
    child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
  );
}

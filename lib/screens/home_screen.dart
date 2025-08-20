// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/app_shell.dart';
import 'package:r10_quiz/widgets/scoreHeader.dart';
import 'package:r10_quiz/screens/quiz_wheel_screen.dart';

/// Tela principal do aplicativo (Home)
/// ALTERAÇÃO: Adicionada documentação e renomeado arquivo para home_screen.dart
class Home extends StatelessWidget {
  // ALTERAÇÃO: Adicionado suporte para key personalizada (usado pelo login)
  const Home({super.key});

  /// Navega para a tela do Quiz Wheel
  /// ALTERAÇÃO: Extraída como função separada para melhor organização e testes
  void _navigateToQuiz(BuildContext context) {
    debugPrint('Navegando para QuizWheelScreen'); // ALTERAÇÃO: Log para debug

    Navigator.push(
      context,
      PageRouteBuilder(
        // ALTERAÇÃO: Animação personalizada de transição
        pageBuilder: (context, animation, secondaryAnimation) =>
        const QuizWheelScreen(
          // ALTERAÇÃO: Adicionado locator para tela de destino
          key: Key('quiz_wheel_from_home'),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // ALTERAÇÃO: Animação de slide da direita para esquerda
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      // ALTERAÇÃO: Adicionado locator para o AppShell
      key: const Key('home_app_shell'),

      backgroundAsset: 'assets/images/background_ronaldinho.png',

      // Header com score do usuário
      topRight: const ScoreHeader(
        // ALTERAÇÃO: Adicionado locator para o header de score (assumindo que vai ser refatorado)
        key: Key('home_score_header'),
      ),

      // Botão principal para iniciar quiz
      bottomCenter: Container(
        // ALTERAÇÃO: Wrapper container para melhor controle de layout e locator
        key: const Key('start_quiz_container'),

        child: ElevatedButton(
          key: const Key('start_quiz_button'), // LOCATOR PRINCIPAL ⭐
          onPressed: () => _navigateToQuiz(context),

          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F378A),
            foregroundColor: Colors.white,
            minimumSize: const Size(200, 56), // ALTERAÇÃO: Botão ligeiramente maior
            // ALTERAÇÃO: Adicionadas configurações visuais extras
            elevation: 4,
            shadowColor: const Color(0xFF4F378A).withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28), // Botão mais arredondado
            ),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ALTERAÇÃO: Adicionado ícone ao botão
              const Icon(
                Icons.play_arrow_rounded,
                key: Key('start_quiz_icon'),
                size: 24,
              ),

              const SizedBox(width: 8),

              // Texto do botão
              const Text(
                'COMEÇAR QUIZ',
                key: Key('start_quiz_text'),
                style: TextStyle(
                  fontSize: 18, // ALTERAÇÃO: Fonte ligeiramente menor para melhor proporção
                  fontWeight: FontWeight.w700, // ALTERAÇÃO: Peso mais forte
                  letterSpacing: 0.5, // ALTERAÇÃO: Espaçamento entre letras
                ),
              ),
            ],
          ),
        ),
      ),

      // ALTERAÇÃO: Adicionado conteúdo central com informações úteis
      child: Container(
        key: const Key('home_center_content'),
        padding: const EdgeInsets.symmetric(horizontal: 32),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ALTERAÇÃO: Card informativo no centro (opcional, pode ser removido)
            Card(
              key: const Key('welcome_info_card'),
              elevation: 2,
              color: Colors.black.withOpacity(0.3), // Fundo semi-transparente
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: const Color(0xFF4F378A).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Ícone central
                    Icon(
                      Icons.sports_soccer,
                      key: const Key('welcome_soccer_icon'),
                      size: 48,
                      color: const Color(0xFF4F378A),
                    ),

                    const SizedBox(height: 12),

                    // Texto de boas-vindas
                    Text(
                      'Pronto para testar seus\nconhecimentos sobre futebol?',
                      key: const Key('welcome_message'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtexto motivacional
                    Text(
                      'Responda perguntas e ganhe pontos!',
                      key: const Key('welcome_subtitle'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ALTERAÇÃO: Estatísticas rápidas (placeholder - pode ser conectado com dados reais)
            Row(
              key: const Key('quick_stats_row'),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickStat(
                  key: 'total_games_stat',
                  icon: Icons.quiz,
                  label: 'Jogos',
                  value: '---', // Placeholder - conectar com dados reais
                ),

                _buildQuickStat(
                  key: 'best_streak_stat',
                  icon: Icons.local_fire_department,
                  label: 'Melhor Sequência',
                  value: '---', // Placeholder - conectar com dados reais
                ),

                _buildQuickStat(
                  key: 'current_level_stat',
                  icon: Icons.star,
                  label: 'Nível',
                  value: '1', // Placeholder - conectar com dados reais
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget para criar estatísticas rápidas
  /// ALTERAÇÃO: Novo widget para mostrar stats do jogador
  Widget _buildQuickStat({
    required String key,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      key: Key(key),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4F378A).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            key: Key('${key}_icon'),
            color: const Color(0xFF4F378A),
            size: 20,
          ),

          const SizedBox(height: 4),

          Text(
            value,
            key: Key('${key}_value'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          Text(
            label,
            key: Key('${key}_label'),
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/*
RESUMO DAS ALTERAÇÕES FEITAS:

🎯 LOCATORS ADICIONADOS (PRINCIPAIS PARA QA):
- 'home_app_shell': AppShell principal da home
- 'home_score_header': Header com pontuação
- 'start_quiz_container': Container do botão principal
- 'start_quiz_button': Botão para iniciar quiz ⭐ PRINCIPAL
- 'start_quiz_icon': Ícone do botão
- 'start_quiz_text': Texto do botão
- 'home_center_content': Conteúdo central
- 'welcome_info_card': Card de boas-vindas
- 'welcome_soccer_icon': Ícone de futebol
- 'welcome_message': Mensagem principal
- 'welcome_subtitle': Subtítulo motivacional
- 'quick_stats_row': Row com estatísticas
- 'total_games_stat': Stat de jogos totais
- 'best_streak_stat': Stat de melhor sequência
- 'current_level_stat': Stat de nível atual
- 'quiz_wheel_from_home': Tela de destino (QuizWheel)

🚀 MELHORIAS IMPLEMENTADAS:

1. **UX/UI Melhorado**:
   - Botão maior com ícone play
   - Card informativo no centro
   - Estatísticas rápidas do jogador
   - Animação de slide na navegação
   - Cores e bordas consistentes

2. **Organização do Código**:
   - Função de navegação separada
   - Helper para criar stats
   - Documentação completa
   - Logs de debug

3. **Layout Mais Rico**:
   - Conteúdo central significativo (não mais SizedBox.shrink)
   - Card de boas-vindas
   - Área de estatísticas
   - Visual mais profissional

4. **Preparação para Futuro**:
   - Placeholders para dados reais
   - Estrutura para conectar com Firestore
   - Keys para todos elementos importantes

COMO OS QA PODEM USAR:
```dart
// Testar navegação para quiz
await tester.tap(find.byKey(Key('start_quiz_button')));

// Verificar elementos da UI
expect(find.byKey(Key('welcome_info_card')), findsOneWidget);
expect(find.byKey(Key('quick_stats_row')), findsOneWidget);

// Testar estatísticas
expect(find.byKey(Key('total_games_stat')), findsOneWidget);
```

PRÓXIMAS MELHORIAS SUGERIDAS:
1. Conectar estatísticas com dados reais do Firestore
2. Adicionar animações nos cards
3. Implementar pull-to-refresh
4. Adicionar configurações do usuário

Pronto para a próxima tela! 🎮
*/
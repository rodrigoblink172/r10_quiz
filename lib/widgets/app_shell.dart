import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/header.dart';

/// Widget Shell principal que provê estrutura base para todas as telas do app
/// ALTERAÇÃO: Adicionada documentação completa da classe
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    this.appBar,
    required this.backgroundAsset,
    this.topRight,
    this.bottomCenter,
    required this.child,
    this.horizontalPadding = 16,
    // ALTERAÇÃO: Novos parâmetros opcionais para maior flexibilidade
    this.showAppBar = true,
    this.overlayColor,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
  });

  /// AppBar personalizada (opcional)
  final PreferredSizeWidget? appBar;

  /// Caminho do asset da imagem de fundo
  final String backgroundAsset;

  /// Widget posicionado no topo à direita (ex: score header)
  final Widget? topRight;

  /// Widget posicionado no centro inferior (ex: botão principal)
  final Widget? bottomCenter;

  /// Conteúdo principal da tela
  final Widget child;

  /// Padding horizontal do conteúdo principal
  final double horizontalPadding;

  /// ALTERAÇÃO: Controla se deve mostrar a AppBar
  final bool showAppBar;

  /// ALTERAÇÃO: Cor de overlay sobre a imagem de fundo (opcional)
  final Color? overlayColor;

  /// ALTERAÇÃO: Controla SafeArea no topo
  final bool safeAreaTop;

  /// ALTERAÇÃO: Controla SafeArea na base
  final bool safeAreaBottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ALTERAÇÃO: Adicionado locator para o Scaffold principal
      key: const Key('app_shell_scaffold'),

      // AppBar condicional
      appBar: showAppBar
          ? (appBar ?? const AppHeader(
        title: 'R10 Score',
        // ALTERAÇÃO: Adicionado locator para AppHeader padrão
        key: Key('app_shell_default_header'),
      ))
          : null,

      body: Stack(
        // ALTERAÇÃO: Adicionado locator para Stack principal
        key: const Key('app_shell_main_stack'),

        children: [
          // ALTERAÇÃO: Container para melhor controle da imagem de fundo
          Positioned.fill(
            child: Container(
              key: const Key('app_shell_background_container'),
              child: Stack(
                children: [
                  // Imagem de fundo
                  Image.asset(
                    backgroundAsset,
                    key: const Key('app_shell_background_image'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    // ALTERAÇÃO: Callback de erro para imagens não encontradas
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Erro ao carregar imagem de fundo: $backgroundAsset');
                      return Container(
                        key: const Key('app_shell_background_error'),
                        color: const Color(0xFF1A1A1A), // Fundo escuro de fallback
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Imagem não encontrada',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // ALTERAÇÃO: Overlay colorido opcional (para melhor legibilidade)
                  if (overlayColor != null)
                    Positioned.fill(
                      child: Container(
                        key: const Key('app_shell_overlay'),
                        color: overlayColor,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Conteúdo principal com SafeArea configurável
          SafeArea(
            key: const Key('app_shell_safe_area'),
            top: safeAreaTop,
            bottom: safeAreaBottom,

            child: Stack(
              key: const Key('app_shell_content_stack'),

              children: [
                // ALTERAÇÃO: Container wrapper para melhor controle do conteúdo principal
                Positioned.fill(
                  child: Container(
                    key: const Key('app_shell_main_content_container'),
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: child,
                  ),
                ),

                // Widget do topo à direita (ex: scoreHeader)
                if (topRight != null)
                  Positioned(
                    top: 8,
                    right: 16,
                    child: Container(
                      key: const Key('app_shell_top_right_container'),
                      child: topRight!,
                    ),
                  ),

                // Widget do rodapé central (ex: botão iniciar)
                if (bottomCenter != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: Container(
                      key: const Key('app_shell_bottom_center_container'),
                      child: Center(child: bottomCenter!),
                    ),
                  ),

                // ALTERAÇÃO: Indicador de loading global (para uso futuro)
                if (_shouldShowGlobalLoading())
                  Positioned.fill(
                    child: Container(
                      key: const Key('app_shell_global_loading'),
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          key: Key('app_shell_loading_indicator'),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF4F378A),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ALTERAÇÃO: Helper para determinar se deve mostrar loading global
  /// Esta função pode ser expandida para aceitar parâmetros de estado
  bool _shouldShowGlobalLoading() {
    // Por enquanto sempre false, mas pode ser controlado por parâmetro no futuro
    return false;
  }
}

/// ALTERAÇÃO: Extensão para facilitar uso comum do AppShell
extension AppShellHelpers on AppShell {
  /// Cria um AppShell com overlay escuro para melhor legibilidade
  static AppShell withDarkOverlay({
    Key? key,
    PreferredSizeWidget? appBar,
    required String backgroundAsset,
    Widget? topRight,
    Widget? bottomCenter,
    required Widget child,
    double horizontalPadding = 16,
    bool showAppBar = true,
    double overlayOpacity = 0.3,
  }) {
    return AppShell(
      key: key,
      appBar: appBar,
      backgroundAsset: backgroundAsset,
      topRight: topRight,
      bottomCenter: bottomCenter,
      child: child,
      horizontalPadding: horizontalPadding,
      showAppBar: showAppBar,
      overlayColor: Colors.black.withOpacity(overlayOpacity),
    );
  }

  /// Cria um AppShell sem AppBar (para telas full-screen)
  static AppShell fullScreen({
    Key? key,
    required String backgroundAsset,
    Widget? topRight,
    Widget? bottomCenter,
    required Widget child,
    double horizontalPadding = 16,
    Color? overlayColor,
  }) {
    return AppShell(
      key: key,
      backgroundAsset: backgroundAsset,
      topRight: topRight,
      bottomCenter: bottomCenter,
      child: child,
      horizontalPadding: horizontalPadding,
      showAppBar: false,
      overlayColor: overlayColor,
      safeAreaTop: false,
    );
  }
}

/*
RESUMO DAS ALTERAÇÕES FEITAS:

🎯 LOCATORS ADICIONADOS (PRINCIPAIS PARA QA):
- 'app_shell_scaffold': Scaffold principal
- 'app_shell_main_stack': Stack principal
- 'app_shell_background_container': Container da imagem
- 'app_shell_background_image': Imagem de fundo ⭐
- 'app_shell_background_error': Tela de erro de imagem
- 'app_shell_overlay': Overlay colorido opcional
- 'app_shell_safe_area': Área segura
- 'app_shell_content_stack': Stack do conteúdo
- 'app_shell_main_content_container': Container do conteúdo principal
- 'app_shell_top_right_container': Container do widget topo-direita
- 'app_shell_bottom_center_container': Container do widget rodapé
- 'app_shell_default_header': Header padrão
- 'app_shell_global_loading': Loading global
- 'app_shell_loading_indicator': Indicador de loading

🚀 MELHORIAS IMPLEMENTADAS:

1. **Robustez & Tratamento de Erros**:
   - ErrorBuilder para imagens não encontradas
   - Fallback visual quando imagem falha
   - Logs de debug para problemas de asset

2. **Flexibilidade Expandida**:
   - showAppBar: controla exibição da AppBar
   - overlayColor: overlay sobre imagem de fundo
   - safeAreaTop/Bottom: controle fino do SafeArea
   - Loading global preparado para uso futuro

3. **Organização & Manutenibilidade**:
   - Documentação completa de todos parâmetros
   - Função helper para loading global
   - Extensões com factory methods úteis
   - Containers wrapper para melhor controle

4. **Extensões Úteis**:
   - withDarkOverlay(): Para melhor legibilidade
   - fullScreen(): Para telas sem AppBar
   - Facilita uso comum do componente

5. **Preparação para Futuro**:
   - Sistema de loading global
   - Parâmetros configuráveis
   - Estrutura extensível

COMO OS QA PODEM USAR:
```dart
// Testar carregamento da imagem de fundo
expect(find.byKey(Key('app_shell_background_image')), findsOneWidget);

// Testar erro de imagem
// (simular asset não encontrado)
expect(find.byKey(Key('app_shell_background_error')), findsOneWidget);

// Testar posicionamento dos widgets
expect(find.byKey(Key('app_shell_top_right_container')), findsOneWidget);
expect(find.byKey(Key('app_shell_bottom_center_container')), findsOneWidget);

// Testar loading global (quando implementado)
expect(find.byKey(Key('app_shell_global_loading')), findsNothing);
```

EXEMPLOS DE USO DAS NOVAS EXTENSÕES:
```dart
// Com overlay escuro
AppShellHelpers.withDarkOverlay(
  backgroundAsset: 'assets/bg.png',
  child: MyContent(),
);

// Full screen
AppShellHelpers.fullScreen(
  backgroundAsset: 'assets/bg.png',
  child: MyContent(),
);
```

BENEFÍCIOS PARA O PROJETO:
- Componente mais robusto e confiável
- Fácil de testar automaticamente
- Preparado para casos edge (imagem não carrega)
- Flexível para diferentes tipos de tela
- Código mais limpo e documentado

Pronto para a próxima refatoração! 🏗️✨
*/
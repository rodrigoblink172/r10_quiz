import 'package:flutter/material.dart';
import 'package:r10_quiz/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Função principal da aplicação
/// ALTERAÇÃO: Adicionado comentário de documentação e melhor organização
void main() async {
  // Garante que o Flutter esteja inicializado antes de executar código assíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // ALTERAÇÃO: Adicionado tratamento de erro para inicialização do Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase inicializado com sucesso'); // Log para debug
  } catch (e) {
    debugPrint('Erro ao inicializar Firebase: $e');
    // Em produção, você pode querer mostrar uma tela de erro
  }

  runApp(const R10());
}

/// Widget principal da aplicação R10 Quiz
/// ALTERAÇÃO: Adicionado documentação da classe
class R10 extends StatelessWidget {
  // ALTERAÇÃO: Adicionado locator para testes automatizados - permite identificar o app principal
  const R10({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ALTERAÇÃO: Adicionado locator para o MaterialApp - útil para testes de navegação
      key: const Key('main_material_app'),

      title: 'R10 Quiz',

      // ALTERAÇÃO: Configuração de tema mais robusta e organizadas
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,

        // ALTERAÇÃO: Adicionadas configurações extras do tema para consistência
        appBarTheme: const AppBarTheme(
          centerTitle: true, // Centraliza títulos da AppBar
          elevation: 2, // Sombra padrão
        ),

        // Configuração de botões elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Configuração de campos de texto
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // ALTERAÇÃO: Adicionada configuração de debug banner
      debugShowCheckedModeBanner: false, // Remove banner de debug em desenvolvimento

      // Tela inicial
      home: const LoginScreen(
        // ALTERAÇÃO: Adicionado locator para a tela de login - facilita testes de navegação
        key: Key('login_screen_main'),
      ),

      // ALTERAÇÃO: Adicionada configuração de localização (preparado para internacionalização futura)
      locale: const Locale('pt', 'BR'), // Português Brasil

      // ALTERAÇÃO: Configurações de acessibilidade
      builder: (context, child) {
        // Wrapper para configurações globais de acessibilidade
        return MediaQuery(
          // Força o texto a não escalar além de 1.3x para manter layout consistente
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3),
          ),
          child: child!,
        );
      },
    );
  }
}

/*
RESUMO DAS ALTERAÇÕES FEITAS:

1. LOCATORS ADICIONADOS:
   - 'main_material_app': Identifica o MaterialApp principal
   - 'login_screen_main': Identifica a tela de login inicial

2. MELHORIAS DE CÓDIGO:
   - Tratamento de erro na inicialização do Firebase
   - Logs de debug para monitoramento
   - Documentação com comentários ///
   - debugShowCheckedModeBanner = false

3. CONFIGURAÇÕES DE TEMA EXPANDIDAS:
   - AppBarTheme configurado
   - ElevatedButtonTheme padronizado
   - InputDecorationTheme para campos de texto consistentes

4. ACESSIBILIDADE:
   - Configuração de locale para PT-BR
   - Controle de escala de texto (textScaleFactor)
   - Builder para configurações globais

5. PREPARAÇÃO PARA FUTURO:
   - Estrutura preparada para internacionalização
   - Configurações que facilitam testes
   - Logs para debug e monitoramento

PRÓXIMOS PASSOS:
- Refatorar LoginScreen adicionando locators lá também
- Criar constantes para os locators (Keys) em arquivo separado
- Adicionar testes automatizados usando esses locators
*/
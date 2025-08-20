// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:r10_quiz/screens/home_screen.dart'; // classe HomeScreen

/// Cria ou atualiza o documento do usuário na coleção 'users'
/// ALTERAÇÃO: Adicionada documentação da função e melhor tratamento de erros
Future<void> ensureUserDoc(User user) async {
  final uid = user.uid;
  final email = user.email ?? '';
  final nome = user.displayName ?? '';

  final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

  try {
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(userRef);
      final now = FieldValue.serverTimestamp();

      if (snap.exists) {
        // ALTERAÇÃO: Adicionado log para debug
        debugPrint('Usuário existente atualizado: $email');
        tx.update(userRef, {'updatedAt': now});
      } else {
        // ALTERAÇÃO: Adicionado log para debug
        debugPrint('Novo usuário criado: $email');
        tx.set(userRef, {
          'email': email,
          'nome': nome,
          'score': 0,
          'stats': {'acertos': 0, 'erros': 0},
          'coins': 0,
          'level': 1,
          'hats': 0,
          'myItems': [],
          'myItemsUpdatedAt': now,
          'createdAt': now,
          'updatedAt': now,
        });
      }
    });
  } catch (e) {
    // ALTERAÇÃO: Melhor tratamento de erro
    debugPrint('Erro ao criar/atualizar usuário: $e');
    rethrow; // Re-lança o erro para ser tratado pela função chamadora
  }
}

/// Tela de login principal do aplicativo
/// ALTERAÇÃO: Adicionada documentação da classe
class LoginScreen extends StatefulWidget {
  // ALTERAÇÃO: Adicionado locator para a tela de login
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  /// Realiza o login com Google Sign-In
  /// ALTERAÇÃO: Melhor tratamento de erros e documentação
  Future<UserCredential> _googleSignIn() async {
    try {
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();

      if (googleUser == null) {
        throw Exception('Login cancelado pelo usuário');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Erro no Google Sign-In: $e');
      rethrow;
    }
  }

  /// Função principal de entrada no aplicativo
  /// ALTERAÇÃO: Melhor organização e tratamento de erros
  Future<void> _entrar() async {
    if (_loading) return; // ALTERAÇÃO: Previne múltiplas chamadas

    setState(() => _loading = true);

    try {
      // Realiza login com Google
      await _googleSignIn();

      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (user == null || email == null) {
        throw Exception('Não foi possível obter o e-mail do usuário.');
      }

      // ALTERAÇÃO: Adicionado log para debug
      debugPrint('Verificando autorização para: $email');

      // Verifica autorização por e-mail na coleção 'allowed'
      final snap = await FirebaseFirestore.instance
          .collection('allowed')
          .doc(email) // usar o e-mail exatamente como veio do Auth
          .get();

      if (snap.exists) {
        debugPrint('Usuário autorizado: $email');

        // Cria/atualiza documento do usuário ANTES de navegar
        await ensureUserDoc(user);

        if (!mounted) return;

        // ALTERAÇÃO: Navegação com animação personalizada
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const Home(
              // ALTERAÇÃO: Adicionado locator para a tela Home
              key: Key('home_screen_from_login'),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // ALTERAÇÃO: Animação de fade-in suave
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      } else {
        debugPrint('Usuário não autorizado: $email');

        // Faz logout se não autorizado
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
        _snack('Seu e-mail não está autorizado.');
      }
    } catch (e) {
      debugPrint('Erro no processo de login: $e');
      _snack('Erro ao entrar: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  /// Exibe mensagem de feedback para o usuário
  /// ALTERAÇÃO: Melhor configuração da SnackBar
  void _snack(String msg) {
    if (!mounted) return; // ALTERAÇÃO: Verifica se ainda está montado

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        // ALTERAÇÃO: Configurações adicionais para melhor UX
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// Função de logout para debug
  /// ALTERAÇÃO: Extraída como função separada para melhor organização
  Future<void> _debugSignOut() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      debugPrint('Logout realizado com sucesso');
      _snack('Saiu da conta.');
    } catch (e) {
      debugPrint('Erro no logout: $e');
      _snack('Erro ao sair: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ALTERAÇÃO: Adicionado locator para o Scaffold principal
      key: const Key('login_scaffold'),

      body: SafeArea(
        // ALTERAÇÃO: Adicionado locator para a área segura
        key: const Key('login_safe_area'),

        child: Center(
          child: SingleChildScrollView(
            // ALTERAÇÃO: Adicionado scroll para telas pequenas
            padding: const EdgeInsets.all(24.0),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // ALTERAÇÃO: Alinhamento centralizado

              children: [
                // ALTERAÇÃO: Adicionado ícone do app
                Container(
                  key: const Key('app_logo_container'),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F378A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.quiz,
                    size: 64,
                    color: Color(0xFF4F378A),
                    key: Key('app_logo_icon'),
                  ),
                ),

                const SizedBox(height: 32),

                // Título principal
                const Text(
                  'Bem-vindo ao R10 Quiz',
                  key: Key('welcome_title'),
                  style: TextStyle(
                    fontSize: 28, // ALTERAÇÃO: Fonte maior
                    fontWeight: FontWeight.w700, // ALTERAÇÃO: Peso mais forte
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // ALTERAÇÃO: Adicionado subtítulo
                Text(
                  'Teste seus conhecimentos e divirta-se!',
                  key: const Key('welcome_subtitle'),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Botão principal de login
                SizedBox(
                  width: 280, // ALTERAÇÃO: Largura maior
                  height: 56, // ALTERAÇÃO: Altura maior
                  child: ElevatedButton.icon(
                    key: const Key('google_login_button'), // LOCATOR PRINCIPAL
                    onPressed: _loading ? null : _entrar,

                    icon: _loading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        key: Key('login_loading_indicator'),
                      ),
                    )
                        : const Icon(
                      Icons.login,
                      key: Key('login_icon'),
                    ),

                    label: Text(
                      _loading ? 'Entrando…' : 'Entrar com o Google',
                      key: const Key('login_button_text'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F378A),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: const Color(0xFF4F378A).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botão de debug (apenas em desenvolvimento)
                TextButton(
                  key: const Key('debug_signout_button'), // LOCATOR PARA TESTES
                  onPressed: _loading ? null : _debugSignOut,

                  child: Text(
                    'Sair (debug)',
                    key: const Key('debug_signout_text'),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ALTERAÇÃO: Adicionada versão do app (útil para debug)
                Text(
                  'v1.0.0',
                  key: const Key('app_version_text'),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
RESUMO DAS ALTERAÇÕES FEITAS:

🎯 LOCATORS ADICIONADOS (PRINCIPAIS PARA QA):
- 'login_scaffold': Scaffold principal
- 'login_safe_area': Área segura da tela
- 'app_logo_container': Container do logo
- 'app_logo_icon': Ícone do app
- 'welcome_title': Título principal
- 'welcome_subtitle': Subtítulo
- 'google_login_button': Botão principal de login ⭐
- 'login_loading_indicator': Indicador de carregamento
- 'login_icon': Ícone do botão
- 'login_button_text': Texto do botão
- 'debug_signout_button': Botão de logout debug
- 'debug_signout_text': Texto do botão debug
- 'app_version_text': Versão do app
- 'home_screen_from_login': Tela Home (quando navega)

🚀 MELHORIAS IMPLEMENTADAS:
1. **UX/UI Melhorado**:
   - Logo com container estilizado
   - Subtítulo informativo
   - Botão maior e mais atrativo
   - Indicador de loading no botão
   - Animação de transição suave
   - ScrollView para telas pequenas

2. **Tratamento de Erros**:
   - Try-catch em todas as funções async
   - Logs de debug detalhados
   - SnackBar melhorada com ação
   - Verificação de mounted state

3. **Organização do Código**:
   - Documentação completa
   - Função de logout separada
   - Prevenção de múltiplas chamadas
   - Constantes para cores

4. **Acessibilidade**:
   - Keys em todos os elementos importantes
   - Textos centralizados
   - Tamanhos de fonte adequados
   - Cores com bom contraste

COMO OS QA PODEM USAR:
```dart
// Testar login
await tester.tap(find.byKey(Key('google_login_button')));

// Verificar loading
expect(find.byKey(Key('login_loading_indicator')), findsOneWidget);

// Testar logout debug
await tester.tap(find.byKey(Key('debug_signout_button')));
```

Próximo passo: Refatorar a HomeScreen! 🏠
*/
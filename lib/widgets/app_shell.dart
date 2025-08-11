import 'package:flutter/material.dart';
import 'package:r10_quiz/widgets/header.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    this.appBar,
    required this.backgroundAsset,
    this.topRight,
    this.bottomCenter,
    required this.child,
    this.horizontalPadding = 16,
  });

  final PreferredSizeWidget? appBar;

  final String backgroundAsset;

  final Widget? topRight;

  final Widget? bottomCenter;

  final Widget child;

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? const AppHeader(title: 'R10 Score'),
      body: Stack(
        children: [
          // Fundo
          Positioned.fill(
            child: Image.asset(
              backgroundAsset,
              fit: BoxFit.cover,
            ),
          ),
          // Conteúdo
          SafeArea(
            child: Stack(
              children: [
                // Conteúdo principal preenchendo a área
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: child,
                  ),
                ),
                // Topo à direita (ex: scoreHeader)
                if (topRight != null)
                  Positioned(
                    top: 8,
                    right: 16,
                    child: topRight!,
                  ),
                // Rodapé central (ex: botão iniciar)
                if (bottomCenter != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: Center(child: bottomCenter!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../../../routes/app_routes.dart';

class RestartGame extends StatelessWidget {
  const RestartGame({
    required this.isGameOver,
    required this.pauseGame,
    required this.restartGame,
    required this.continueGame,
    this.color = Colors.white,
    super.key,
  });

  final VoidCallback pauseGame;
  final VoidCallback restartGame;
  final VoidCallback continueGame;
  final bool isGameOver;
  final Color color;

  Future<void> showGameControls(BuildContext context) async {
    pauseGame();
    final result = await Navigator.of(context).pushNamed(AppRoutes.patientMemoryMatchControls);
    
    // Handle the result from game controls
    if (result == 'restart') {
      restartGame();
    } else {
      continueGame();
    }
  }

  void navigateback(BuildContext context) {
    Navigator.of(context).popUntil(
      (Route<dynamic> route) => route.settings.name == AppRoutes.patientMain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      icon: (isGameOver)
          ? const Icon(Icons.replay_circle_filled)
          : const Icon(Icons.pause_circle_filled),
      iconSize: 40,
      onPressed: () =>
          isGameOver ? navigateback(context) : showGameControls(context),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../../routes/app_routes.dart';
import '../widgets/game_button.dart';
import '../../utils/constants.dart';

class GameControlsPage extends StatelessWidget {
  const GameControlsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'PAUSE',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              GameButton(
                onPressed: () => Navigator.of(context).pop('continue'),
                title: 'CONTINUE',
                color: continueButtonColor,
                width: 200,
              ),
              const SizedBox(height: 20),
              GameButton(
                onPressed: () {
                  // Pop back to game and signal restart
                  Navigator.of(context).pop('restart');
                },
                title: 'RESTART',
                color: restartButtonColor,
                width: 200,
              ),
              const SizedBox(height: 20),
              GameButton(
                onPressed: () {
                  Navigator.of(context).popUntil(
                    (Route<dynamic> route) => route.settings.name == AppRoutes.patientMain,
                  );
                },
                title: 'QUIT',
                color: quitButtonColor,
                width: 200,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
} 
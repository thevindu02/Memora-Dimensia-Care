import 'package:flutter/material.dart';
import '../../../../../../routes/app_routes.dart';
import '../../ui/widgets/game_button.dart';
import '../../utils/constants.dart';

class GameControlsBottomSheet extends StatelessWidget {
  const GameControlsBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'PAUSE',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          GameButton(
            onPressed: () => Navigator.of(context).pop('continue'),
            title: 'CONTINUE',
            color: continueButtonColor,
            width: 200,
          ),
          const SizedBox(height: 10),
          GameButton(
            onPressed: () => Navigator.of(context).pop('restart'),
            title: 'RESTART',
            color: restartButtonColor,
            width: 200,
          ),
          const SizedBox(height: 10),
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
    );
  }
}

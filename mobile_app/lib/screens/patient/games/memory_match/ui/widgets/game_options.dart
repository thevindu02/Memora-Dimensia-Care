import 'package:flutter/material.dart';
import '../../ui/pages/memory_match_page.dart';
import '../../ui/widgets/game_button.dart';
import '../../utils/constants.dart';
import '../../../../../../routes/app_routes.dart';

class GameOptions extends StatelessWidget {
  const GameOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: gameLevels.map((level) {
        String routeName;
        switch (level['level']) {
          case 4:
            routeName = AppRoutes.patientMemoryMatchLevel4;
            break;
          case 6:
            routeName = AppRoutes.patientMemoryMatchLevel6;
            break;
          case 8:
            routeName = AppRoutes.patientMemoryMatchLevel8;
            break;
          default:
            routeName = AppRoutes.patientMemoryMatchLevel4;
        }
        
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GameButton(
            onPressed: () => Navigator.of(context).pushNamed(routeName),
            title: level['title'],
            color: level['color'],
            width: 250,
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'ui/widgets/game_options.dart';

class MemoryMatchGame extends StatelessWidget {
  const MemoryMatchGame({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: const StartUpPage(),
    //   title: 'The MemoryMatch Game',
    //   theme: ThemeData.light(),
    //   debugShowCheckedModeBanner: false,
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text(gameTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GameOptions(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/game.dart';
import '../../../ui/widgets/game_confetti.dart';

import '../../../ui/widgets/memory_card.dart';
import '../../../ui/widgets/restart_game.dart';
import '../../../ui/widgets/web/game_best_time.dart';
import '../../../ui/widgets/web/game_timer.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    required this.gameLevel,
    super.key,
  });

  final int gameLevel;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Timer? timer; // Changed from late Timer to Timer?
  late Game game;
  late Duration duration;
  int bestTime = 0;
  bool showConfetti = false;

  @override
  void initState() {
    super.initState();
    game = Game(widget.gameLevel);
    duration = const Duration();
    startTimer();
    getBestTime();
  }

  void getBestTime() async {
    SharedPreferences gameSP = await SharedPreferences.getInstance();
    if (gameSP.getInt('${widget.gameLevel.toString()}BestTime') != null) {
      bestTime = gameSP.getInt('${widget.gameLevel.toString()}BestTime')!;
    }
    if (mounted) { // Check if widget is still mounted
      setState(() {});
    }
  }

  startTimer() {
    timer?.cancel(); // Cancel any existing timer
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!mounted) return; // Check if widget is still mounted

      setState(() {
        final seconds = duration.inSeconds + 1;
        duration = Duration(seconds: seconds);
      });

      if (game.isGameOver) {
        timer?.cancel();
        SharedPreferences gameSP = await SharedPreferences.getInstance();
        if (gameSP.getInt('${widget.gameLevel.toString()}BestTime') == null ||
            gameSP.getInt('${widget.gameLevel.toString()}BestTime')! >
                duration.inSeconds) {
          gameSP.setInt(
              '${widget.gameLevel.toString()}BestTime', duration.inSeconds);
          if (mounted) { // Check if widget is still mounted
            setState(() {
              showConfetti = true;
              bestTime = duration.inSeconds;
            });
          }
        }
      }
    });
  }

  pauseTimer() {
    timer?.cancel();
  }

  void _resetGame() {
    game.resetGame();
    timer?.cancel(); // Cancel timer first
    duration = const Duration();
    startTimer();
    if (mounted) { // Check if widget is still mounted
      setState(() {
        // State update if needed
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = sqrt(MediaQuery.of(context).size.width) *
        sqrt(MediaQuery.of(context).size.height);

    return Stack(
      children: [
        GridView.count(
          padding: const EdgeInsets.fromLTRB(8.0, 80.0, 8.0, 8.0),
          childAspectRatio: MediaQuery.of(context).size.aspectRatio * 1.2,
          mainAxisSpacing: responsiveSpacing / 100,
          crossAxisSpacing: responsiveSpacing / 100,
          crossAxisCount: game.gridSize,
          children: List.generate(game.cards.length, (index) {
            return MemoryCard(
              index: index,
              card: game.cards[index],
              onCardPressed: game.onCardPressed,
            );
          }),
        ),
        Positioned(
          top: 12.0,
          right: 24.0,
          child: RestartGame(
            isGameOver: game.isGameOver,
            pauseGame: () => pauseTimer(),
            restartGame: () => _resetGame(),
            continueGame: () => startTimer(),
          ),
        ),
        Positioned(
          bottom: 12.0,
          right: 24.0,
          child: GameTimer(
            time: duration,
          ),
        ),
        Positioned(
          bottom: 12.0,
          left: 24.0,
          child: GameBestTime(
            bestTime: bestTime,
          ),
        ),
        showConfetti ? const GameConfetti() : const SizedBox(),
      ],
    );
  }
}
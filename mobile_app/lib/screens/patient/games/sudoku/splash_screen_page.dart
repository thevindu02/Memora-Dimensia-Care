import 'dart:async';
import 'package:flutter/material.dart';

import 'main.dart';
import 'styles.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/icon_foreground.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Sudoku',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Styles.foregroundColor,
              ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(color: Styles.primaryColor),
          ],
        ),
      ),
    );
  }
}

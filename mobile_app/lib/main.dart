import 'package:flutter/material.dart';
import 'screens/caregiver/view_article_screen.dart'; // ✅ import your ProfileView

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: HealthcareApp(), // ✅ load ProfileView directly
    );
  }
}

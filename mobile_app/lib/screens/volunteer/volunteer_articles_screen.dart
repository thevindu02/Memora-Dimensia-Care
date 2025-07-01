import 'package:flutter/material.dart';

class VolunteerArticlesScreen extends StatelessWidget {
  const VolunteerArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Volunteers')),
      body: Center(child: Text('Volunteer Article Screen')),
    );
  }
}
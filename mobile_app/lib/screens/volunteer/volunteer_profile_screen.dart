import 'package:flutter/material.dart';

class VolunteerProfileScreen extends StatelessWidget {
  const VolunteerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Volunteer Profile')),
      body: Center(child: Text('Volunteer Profile Screen')),
    );
  }
}
import 'package:flutter/material.dart';

class CaregiverPatientsScreen extends StatelessWidget {
  const CaregiverPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patients')),
      body: Center(child: Text('Caregiver Patients Screen')),
    );
  }
}
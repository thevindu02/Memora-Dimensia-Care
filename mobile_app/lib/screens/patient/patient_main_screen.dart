import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../routes/route_generator.dart';
import '../../widgets/patient/PatientBottomNavigationBar.dart';
import 'patient_dashboard_screen.dart';
import 'patient_notification_screen.dart';
import 'patient_games_screen.dart';
import 'patient_profile_screen.dart';

class PatientMainScreen extends StatefulWidget {
  const PatientMainScreen({Key? key}) : super(key: key);

  @override
  State<PatientMainScreen> createState() => _PatientMainScreenState();
}

class _PatientMainScreenState extends State<PatientMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PatientDashboardScreen(),
    PatientNotificationScreen(),
    PatientGamesScreen(),
    PatientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: PatientBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

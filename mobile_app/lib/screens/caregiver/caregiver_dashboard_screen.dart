import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class CaregiverDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Caregiver Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome Manager!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.caregiverPatients);
              },
              child: Text('View Patients'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.caregiverProfile);
              },
              child: Text('Caregiver Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

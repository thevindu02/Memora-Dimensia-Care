import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class VolunteerDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Volunteer Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome Volunteer!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.volunteerArticles);
              },
              child: Text('View my Articles'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.volunteerProfile);
              },
              child: Text('Volunteer Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

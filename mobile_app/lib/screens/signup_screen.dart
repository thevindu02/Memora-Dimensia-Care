import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';
import 'package:flutter/gestures.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Join Our Community',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade400,
                Colors.blue.shade200,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 80,
                color: Colors.deepPurple[300],
              ),
              SizedBox(height: 24),
              Text(
                'Who are you?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Choose your role to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              _buildRoleButton(
                context,
                'Guardian',
                'Care for your loved ones',
                Icons.family_restroom,
                Colors.green,
                'guardian',
              ),
              SizedBox(height: 16),
              _buildRoleButton(
                context,
                'Caregiver',
                'Provide professional care',
                Icons.medical_services,
                Colors.blue,
                'caregiver',
              ),
              SizedBox(height: 16),
              _buildRoleButton(
                context,
                'Volunteer',
                'Help your community',
                Icons.volunteer_activism,
                Colors.orange,
                'volunteer',
              ),

              SizedBox(height: 40),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(text: "Already have an account? "),
                    TextSpan(
                      text: 'Login here',
                      style: TextStyle(
                        color: Colors.blue[600],
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/login');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      String role,
      ) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleRoleSelection(context, role),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          elevation: 2,
          shadowColor: Colors.black26,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withOpacity(0.3), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _handleRoleSelection(BuildContext context, String role) {
    String signupRoute = _getSignupRoute(role);
    Navigator.pushNamed(context, signupRoute);
  }

  String _getSignupRoute(String role) {
    switch (role) {
      case 'guardian':
        return '/guardian/signup';
      case 'caregiver':
        return '/caregiver/signup';
      case 'volunteer':
        return '/volunteer/signup';
      default:
        return '/guardian/signup';
    }
  }
}

import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class PatientWelcomeScreen extends StatelessWidget {
  const PatientWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Welcome text
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Subtitle
              const Text(
                'Your account has been successfully created',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              // Logo
              Image.asset(
                'assets/images/light_logo.png', // Replace with your actual logo path
                width: 360,
                height: 360,
                fit: BoxFit.contain,
              ),

              const Spacer(flex: 3),

              // Go to Dashboard button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to dashboard and clear all previous routes
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.patientMain,
                      (Route<dynamic> route) => false, // Remove all routes
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA0C4FD),
                    foregroundColor: Color(0xFF2B3F99),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Go to Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Support link
              GestureDetector(
                onTap: () {
                  // Handle support contact
                  // You can open a support page, email, or contact form
                },
                child: const Text(
                  'Need help? Contact support',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
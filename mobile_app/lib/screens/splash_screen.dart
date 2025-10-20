import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  _initializeApp() async {
    print('Splash: Starting initialization...');

    // Simulate app initialization (loading user data, preferences, etc.)
    await Future.delayed(Duration(seconds: 2));

    print('⏰ Splash screen: 2 seconds elapsed, navigating to login...');

    print('Splash: Navigation to login...');

    // Check if widget is still mounted before navigating
    if (mounted) {
      try {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        print('Splash: Navigation completed');
      } catch (e) {
        print('Splash: Navigation error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Option 1: If you have an image asset
            Image.asset(
              'assets/images/light_logo.png', // Replace with your actual logo path
              width: 360,
              height: 360,
              fit: BoxFit.contain,
            ),

            // Option 2: If you want to use an image from network
            // Image.network(
            //   'https://your-domain.com/logo.png',
            //   width: 120,
            //   height: 120,
            //   fit: BoxFit.contain,
            //   loadingBuilder: (context, child, loadingProgress) {
            //     if (loadingProgress == null) return child;
            //     return SizedBox(
            //       width: 120,
            //       height: 120,
            //       child: Center(child: CircularProgressIndicator()),
            //     );
            //   },
            //   errorBuilder: (context, error, stackTrace) {
            //     return Icon(Icons.error, size: 120);
            //   },
            // ),
            SizedBox(height: 30),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

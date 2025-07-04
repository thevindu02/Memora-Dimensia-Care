import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
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
    // Simulate app initialization (loading user data, preferences, etc.)
    await Future.delayed(Duration(seconds: 2));

    // Always navigate to login screen after splash
    Navigator.pushReplacementNamed(context, '/login');
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

            // Option 3: If you want to keep the Flutter logo as backup
            // FlutterLogo(size: 100),

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
import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'routes/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Memora',
      routerConfig: appRouter,
      // For now, only GoRouter handles forgot password. Other routes use Navigator as before.
    );
  }
}
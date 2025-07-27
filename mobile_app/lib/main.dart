import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'routes/router.dart';
import 'package:flutter/services.dart';
import 'utils/navigator_observer.dart';
import 'constants/color_constants.dart';

void main() {

   WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style (keeps navigation visible)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memora',
      theme: ThemeData(
        primarySwatch: AppMaterialColors.primarySwatch,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: AppMaterialColors.primarySwatch,
        ).copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.error,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.onSecondary,
          onSurface: AppColors.onSurface,
          onBackground: AppColors.onSurface,
          onError: AppColors.onPrimary,
        ),
      ),
      initialRoute: AppRoutes.splash,
      navigatorObservers: [CustomNavigatorObserver()],
      //initialRoute: AppRoutes.patientGuardianRequest,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
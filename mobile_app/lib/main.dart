import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'services/auth_service.dart';
import 'services/fcm_notification_service.dart';
import 'screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'routes/router.dart';
import 'package:flutter/services.dart';
import 'utils/navigator_observer.dart';
import 'constants/color_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/deep_link_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (will use google-services.json on Android)
  await Firebase.initializeApp();

  // Initialize FCM Notifications
  await FCMNotificationService().initialize();

  // Set system UI overlay style (keeps navigation visible)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Initialize deep link service with navigator key
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkService.initialize(navigatorKey);
    });
  }

  @override
  void dispose() {
    DeepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Memora',
      theme: ThemeData(
        primarySwatch: AppMaterialColors.primarySwatch,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
        colorScheme:
            ColorScheme.fromSwatch(
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

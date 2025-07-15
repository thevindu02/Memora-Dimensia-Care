import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'routes/router.dart';
import 'package:flutter/services.dart';
import 'utils/navigator_observer.dart';

void main() {

   WidgetsFlutterBinding.ensureInitialized();

  // Hides status & navigation bars (makes app fullscreen)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  runApp(MyApp());

  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memora',
      //initialRoute: AppRoutes.splash,
      navigatorObservers: [CustomNavigatorObserver()],
      initialRoute: AppRoutes.patientGuardianRequest,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

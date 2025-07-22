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
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[700],
      ),
      initialRoute: AppRoutes.splash,
      navigatorObservers: [CustomNavigatorObserver()],
      //initialRoute: AppRoutes.patientGuardianRequest,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

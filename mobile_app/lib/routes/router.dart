import 'package:go_router/go_router.dart';
import '../screens/forgot_password_screen.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    // You can add more routes here in the future
  ],
); 
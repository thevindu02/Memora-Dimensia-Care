import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;
  static GlobalKey<NavigatorState>? _navigatorKey;
  static bool _isInitialized = false;

  // Initialize deep link handling
  static Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    if (_isInitialized) return; // Prevent multiple initializations

    _navigatorKey = navigatorKey;

    // Wait for the app to fully load before handling deep links
    await Future.delayed(const Duration(milliseconds: 1000));

    // Handle app opened via deep link (cold start)
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      // Only handle if this is a valid Memora deep link
      if (initialUri.scheme == 'memora' &&
          (initialUri.host == 'reset-password' ||
              initialUri.host == 'guardian-request')) {
        _handleDeepLink(initialUri);
      }
    }

    // Handle app already running and receiving deep link (hot start)
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri);
    });

    _isInitialized = true;
  }

  // Initialize deep links from dashboard (safer approach)
  static Future<void> initializeFromDashboard(
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    if (_isInitialized) return;

    _navigatorKey = navigatorKey;

    // Handle app already running and receiving deep link (hot start)
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri);
    });

    _isInitialized = true;
  }

  // Clean up resources
  static void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _isInitialized = false;
  }

  // Handle incoming deep links
  static void _handleDeepLink(Uri uri) {
    print('DeepLinkService: Received deep link: $uri');
    print(
      'DeepLinkService: Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}',
    );
    print('DeepLinkService: Query parameters: ${uri.queryParameters}');

    // Ignore localhost URLs (Flutter web development URLs)
    if (uri.host == 'localhost' || uri.host == '127.0.0.1') {
      print('DeepLinkService: Ignoring localhost URL');
      return;
    }

    // Only handle valid Memora deep links
    if (uri.scheme != 'memora') {
      print('DeepLinkService: Not a Memora deep link, ignoring');
      return;
    }

    if (_navigatorKey?.currentState != null) {
      String? token = uri.queryParameters['token'];
      print('DeepLinkService: Extracted token: $token');

      if (token != null && token.isNotEmpty) {
        // Check the host to determine which screen to navigate to
        if (uri.host == 'reset-password') {
          print(
            'DeepLinkService: Navigating to reset password screen with token',
          );
          _navigatorKey!.currentState!.pushNamed(
            AppRoutes.resetPassword,
            arguments: {'token': token},
          );
        } else if (uri.host == 'guardian-request') {
          print(
            'DeepLinkService: Navigating to guardian request screen with token',
          );
          _navigatorKey!.currentState!.pushNamed(
            AppRoutes.patientGuardianRequest,
            arguments: {'token': token},
          );
        } else {
          print('DeepLinkService: Unknown deep link host: ${uri.host}');
        }
      } else {
        print('DeepLinkService: No token found in deep link');
      }
    } else {
      print('DeepLinkService: Navigator key is null, cannot navigate');
    }
  }

  // Manually handle deep link (for testing)
  static void handlePasswordResetLink(BuildContext context, String token) {
    Navigator.pushNamed(
      context,
      AppRoutes.resetPassword,
      arguments: {'token': token},
    );
  }
}

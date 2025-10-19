import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import '../main.dart'; // Import to access navigatorKey

class FCMNotificationService {
  static final FCMNotificationService _instance =
      FCMNotificationService._internal();
  factory FCMNotificationService() => _instance;
  FCMNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Initialize FCM and local notifications
  Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
      return;
    }

    // Initialize local notifications for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'task_notifications', // channel id
      'Task Notifications', // channel name
      description: 'Notifications for scheduled tasks and reminders',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Get FCM token
    _fcmToken = await _firebaseMessaging.getToken();
    print('========================================');
    print('🔔 FCM TOKEN OBTAINED');
    print('Token: $_fcmToken');
    print('========================================');

    // Save token locally and send to backend
    if (_fcmToken != null) {
      await _saveFCMTokenLocally(_fcmToken!);
      // Send token to backend immediately after obtaining it
      await _sendTokenToBackend(_fcmToken!);
    }

    // Listen to token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _saveFCMTokenLocally(newToken);
      _sendTokenToBackend(newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle notification taps when app is in background (minimized)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('════════════════════════════════════════');
      print('👆 MINIMIZED APP - Notification tapped');
      print('   Navigating to SCHEDULE screen...');
      print('════════════════════════════════════════');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      _handleNotificationTap(message, navigateToSchedule: true);
    });

    // ✅ Handle notification taps when app was COMPLETELY CLOSED
    // This checks if the app was opened by clicking a notification
    _checkInitialMessage();
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      _showLocalNotification(message);
    }
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'task_notifications',
          'Task Notifications',
          channelDescription: 'Notifications for scheduled tasks and reminders',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Task Reminder',
      message.notification?.body ?? 'You have a scheduled task',
      platformChannelSpecifics,
      payload: json.encode(message.data),
    );
  }

  // Handle notification tap
  void _handleNotificationTap(
    RemoteMessage message, {
    required bool navigateToSchedule,
  }) {
    print('Notification tapped: ${message.data}');
    print('Navigate to schedule: $navigateToSchedule');
    _navigateToTask(message.data, navigateToSchedule: navigateToSchedule);
  }

  // Handle notification response (local notification tap) - When app is OPEN
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    print('════════════════════════════════════════');
    print('🔔 LOCAL NOTIFICATION TAPPED (App was OPEN)');
    print('════════════════════════════════════════');

    final String? payload = notificationResponse.payload;
    print('Payload: $payload');

    if (payload != null) {
      try {
        final Map<String, dynamic> data = json.decode(payload);
        print('Decoded data: $data');
        // When app is open, navigate to schedule screen with scroll
        _navigateToTask(data, navigateToSchedule: true);
      } catch (e) {
        print('❌ Error parsing notification payload: $e');
        print('════════════════════════════════════════');
      }
    } else {
      print('❌ No payload in notification');
      print('════════════════════════════════════════');
    }
  }

  // Navigate to task based on notification data
  Future<void> _navigateToTask(
    Map<String, dynamic> data, {
    required bool navigateToSchedule,
  }) async {
    try {
      print('════════════════════════════════════════');
      print('🔔 NOTIFICATION TAP - NAVIGATION START');
      print('════════════════════════════════════════');
      print('🔍 Raw notification data: $data');
      print('📍 Navigate to schedule: $navigateToSchedule');

      final taskId = data['taskId'];
      final patientId = data['patientId'];
      final notificationType = data['type'];
      final taskName = data['taskName'];

      print('📱 Navigation Details:');
      print('   Task ID: $taskId (type: ${taskId.runtimeType})');
      print('   Patient ID: $patientId (type: ${patientId.runtimeType})');
      print('   Type: $notificationType');
      print('   Task Name: $taskName');

      if (taskId == null || patientId == null) {
        print('❌ ERROR: Missing required navigation data');
        print('════════════════════════════════════════');
        return;
      }

      // Parse IDs to integers (they might come as strings from notification)
      int parsedTaskId;
      int parsedPatientId;

      try {
        parsedTaskId = taskId is int ? taskId : int.parse(taskId.toString());
        parsedPatientId = patientId is int
            ? patientId
            : int.parse(patientId.toString());
        print('✅ Parsed Task ID: $parsedTaskId, Patient ID: $parsedPatientId');
      } catch (e) {
        print('❌ ERROR parsing IDs: $e');
        print('════════════════════════════════════════');
        return;
      }

      // Get user role to determine which screen to navigate to
      final prefs = await SharedPreferences.getInstance();
      final userRole = prefs.getString('user_role')?.toUpperCase();

      print('👤 User Role: $userRole');

      // Navigate using navigatorKey from main.dart
      print('🔍 Checking navigation context...');
      print(
        '   navigatorKey.currentContext: ${navigatorKey.currentContext != null ? "✅ Available" : "❌ NULL"}',
      );
      print(
        '   navigatorKey.currentState: ${navigatorKey.currentState != null ? "✅ Available" : "❌ NULL"}',
      );

      if (navigatorKey.currentContext != null) {
        if (navigateToSchedule) {
          // Navigate to SCHEDULE screen with scroll to task
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('🎯 NAVIGATING TO SCHEDULE SCREEN');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          if (userRole == 'CAREGIVER') {
            print('📍 Route: /caregiver/routine');
            print(
              '📦 Arguments: {patientId: $parsedPatientId, scrollToTaskId: $parsedTaskId}',
            );

            // Use pushNamedAndRemoveUntil to force navigation and clear stack
            await navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/caregiver/routine',
              (route) => false, // Remove all previous routes
              arguments: {
                'patientId': parsedPatientId,
                'scrollToTaskId': parsedTaskId,
              },
            );
            print('✅ Navigation command sent for CAREGIVER (with stack clear)');
          } else if (userRole == 'PATIENT') {
            print('📍 Route: /patient/dashboard');
            print('📦 Arguments: {scrollToTaskId: $parsedTaskId}');

            await navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/patient/dashboard',
              (route) => false,
              arguments: {'scrollToTaskId': parsedTaskId},
            );
            print('✅ Navigation command sent for PATIENT (with stack clear)');
          } else if (userRole == 'GUARDIAN') {
            print('📍 Route: /guardian/schedule');
            print(
              '📦 Arguments: {patientId: $parsedPatientId, scrollToTaskId: $parsedTaskId}',
            );

            await navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/guardian/schedule',
              (route) => false,
              arguments: {
                'patientId': parsedPatientId,
                'scrollToTaskId': parsedTaskId,
              },
            );
            print('✅ Navigation command sent for GUARDIAN (with stack clear)');
          }
        } else {
          // Navigate to ROUTING screen (Dashboard/Home) WITHOUT task scroll
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('🏠 NAVIGATING TO ROUTING SCREEN (Dashboard)');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          if (userRole == 'CAREGIVER') {
            print('📍 Route: /caregiver/dashboard');
            await navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/caregiver/dashboard', // Fixed: Use correct route
              (route) => false,
            );
            print('✅ Navigation command sent for CAREGIVER');
          } else if (userRole == 'PATIENT') {
            print('📍 Route: /patient/main');
            await navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/patient/main',
              (route) => false,
            );
            print('✅ Navigation command sent for PATIENT');
          } else if (userRole == 'GUARDIAN') {
            print('📍 Route: /guardian/dashboard');
            await navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/guardian/dashboard',
              (route) => false,
            );
            print('✅ Navigation command sent for GUARDIAN');
          }
        }
        print('✅ NAVIGATION COMPLETED SUCCESSFULLY');
      } else {
        print('❌ ERROR: Navigator context not available');
      }
      print('════════════════════════════════════════');
    } catch (e) {
      print('❌ FATAL ERROR navigating to task: $e');
      print('Stack trace: ${StackTrace.current}');
      print('════════════════════════════════════════');
    }
  }

  // Save FCM token locally
  Future<void> _saveFCMTokenLocally(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  // Send FCM token to backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        print('❌ User not logged in, cannot send FCM token');
        return;
      }

      // Use ApiConstants for the base URL
      final url = Uri.parse('${ApiConstants.baseUrl}/api/fcm/token');

      print('📤 Sending FCM token to backend...');
      print('   User ID: $userId');
      print('   URL: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'fcmToken': token,
          'deviceType': 'android', // or 'ios' based on platform
        }),
      );

      if (response.statusCode == 200) {
        print('✅ FCM token registered successfully!');
        print('   Response: ${response.body}');
      } else {
        print('❌ Failed to send FCM token: ${response.statusCode}');
        print('   Response: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending FCM token to backend: $e');
    }
  }

  // Send token to backend when user logs in
  Future<void> sendTokenToBackendOnLogin() async {
    if (_fcmToken != null) {
      await _sendTokenToBackend(_fcmToken!);
    }
  }

  // Check if app was opened from a notification (when app was completely closed)
  Future<void> _checkInitialMessage() async {
    print('🔍 Checking if app was opened from notification...');

    // Wait for navigation to be ready - increased delay
    await Future.delayed(const Duration(milliseconds: 1000));

    final RemoteMessage? message = await FirebaseMessaging.instance
        .getInitialMessage();

    if (message != null) {
      print('════════════════════════════════════════');
      print('🚀 CLOSED APP - Notification opened app');
      print('   Navigating to SCHEDULE screen...');
      print('════════════════════════════════════════');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');

      // Wait MORE for the app to fully initialize navigation (increased from 1500ms to 3000ms)
      print('⏳ Waiting for app initialization (3 seconds)...');
      await Future.delayed(const Duration(milliseconds: 3000));

      print('🚀 NOW attempting navigation...');
      // Navigate to SCHEDULE screen (same as minimized/open state)
      _handleNotificationTap(message, navigateToSchedule: true);
    } else {
      print('✅ App opened normally (not from notification)');
    }
  }

  // Subscribe to topic (optional)
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  // Unsubscribe from topic (optional)
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
}

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // Handle background message here
}

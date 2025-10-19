import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

// Top-level function to handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📱 Handling background message: ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    print('🔔 Initializing Notification Service...');

    // Request permissions (especially important for iOS)
    await _requestPermission();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Configure Firebase Messaging
    await _configureFCM();

    _initialized = true;
    print('✅ Notification Service initialized successfully');
  }

  /// Request notification permissions
  Future<void> _requestPermission() async {
    print('📋 Requesting notification permissions...');

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    print('✅ Notification permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('⚠️ User granted provisional permission');
    } else {
      print('❌ User declined or has not accepted permission');
    }
  }

  /// Initialize local notifications (for showing notifications when app is in foreground)
  Future<void> _initializeLocalNotifications() async {
    print('📱 Initializing local notifications...');

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
    }

    print('✅ Local notifications initialized');
  }

  /// Create Android notification channel
  Future<void> _createAndroidNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'memora_reminders', // id
      'Task Reminders', // name
      description:
          'Notifications for upcoming tasks, medications, and appointments',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    print('✅ Android notification channel created');
  }

  /// Configure Firebase Cloud Messaging
  Future<void> _configureFCM() async {
    print('🔥 Configuring Firebase Cloud Messaging...');

    // Set foreground notification presentation options (iOS)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle initial message (when app is launched from terminated state)
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    print('✅ FCM configured');
  }

  /// Handle messages when app is in foreground
  void _handleForegroundMessage(RemoteMessage message) {
    print('📱 ============================================');
    print('📱 RECEIVED NOTIFICATION (FOREGROUND)');
    print('📱 ============================================');
    print('Message ID: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
    print('📱 ============================================');

    // Show local notification (because foreground messages don't auto-display)
    _showLocalNotification(message);
  }

  /// Handle message taps (when user clicks notification)
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('👆 User tapped notification!');
    print('Message data: ${message.data}');

    // TODO: Navigate to appropriate screen based on notification type
    String? type = message.data['type'];
    String? taskId = message.data['taskId'];

    print('Notification type: $type');
    print('Task ID: $taskId');

    // You can add navigation logic here based on the type
    // Example:
    // if (type == 'task_reminder') {
    //   navigatorKey.currentState?.pushNamed('/task-details', arguments: taskId);
    // }
  }

  /// Show local notification (for foreground messages)
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification == null) {
      print('⚠️ Notification payload is null, skipping local notification');
      return;
    }

    print('🔔 Showing local notification...');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'memora_reminders',
          'Task Reminders',
          channelDescription:
              'Notifications for upcoming tasks, medications, and appointments',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: message.data.toString(),
    );

    print('✅ Local notification shown');
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('👆 Local notification tapped!');
    print('Payload: ${response.payload}');

    // TODO: Parse payload and navigate to appropriate screen
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('📝 FCM Token: ${token.substring(0, 20)}...');
        return token;
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
    return null;
  }

  /// Listen to token refresh
  void onTokenRefresh(Function(String) callback) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token refreshed');
      callback(newToken);
    });
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('✅ Subscribed to topic: $topic');
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('✅ Unsubscribed from topic: $topic');
  }

  /// Delete FCM token (on logout)
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    print('✅ FCM token deleted');
  }
}

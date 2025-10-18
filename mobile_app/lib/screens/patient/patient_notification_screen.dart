import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';

class PatientNotificationScreen extends StatefulWidget {
  const PatientNotificationScreen({Key? key}) : super(key: key);

  @override
  State<PatientNotificationScreen> createState() => _PatientNotificationScreenState();
}

class _PatientNotificationScreenState extends State<PatientNotificationScreen> {
  int unreadCount = 3;
  int readCount = 2;
  bool showUnread = true; // Track which tab is active

  List<NotificationItem> notifications = [
    NotificationItem(
      id: 1,
      title: "Mealtime Reminder",
      time: "2min ago",
      icon: Icons.restaurant,
      iconColor: PatientColors.activityNutrition,
      isRead: false,
    ),
    NotificationItem(
      id: 2,
      title: "Accept request skip task",
      time: "2min ago",
      icon: Icons.playlist_add_check,
      iconColor: PatientColors.error,
      isRead: false,
    ),
    NotificationItem(
      id: 3,
      title: "Accept request skip task",
      time: "2min ago",
      icon: Icons.playlist_add_check,
      iconColor: PatientColors.error,
      isRead: false,
    ),
    NotificationItem(
      id: 4,
      title: "Medicine taken successfully",
      time: "1 hour ago",
      icon: Icons.medical_services,
      iconColor: PatientColors.success,
      isRead: true,
    ),
    NotificationItem(
      id: 5,
      title: "Exercise completed",
      time: "3 hours ago",
      icon: Icons.fitness_center,
      iconColor: PatientColors.activityPhysical,
      isRead: true,
    ),
  ];

  void markAsRead(int id) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1 && !notifications[index].isRead) {
        notifications[index].isRead = true;
        unreadCount--;
        readCount++;
      }
    });
  }

  void dismissNotification(int id) {
    setState(() {
      final notification = notifications.firstWhere((n) => n.id == id);
      notifications.removeWhere((n) => n.id == id);
      if (notification.isRead) {
        readCount--;
      } else {
        unreadCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientColors.background,
      appBar: AppBar(
        backgroundColor: PatientColors.surface,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Notification',
          style: TextStyle(
            color: PatientColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: PatientColors.onSurface),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.patientNotifications);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab section
          Container(
            color: PatientColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Unread notifications tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showUnread = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: showUnread ? PatientColors.primaryLight : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: showUnread ? PatientColors.primary : PatientColors.onSurfaceVariant,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Unread notification',
                            style: TextStyle(
                              color: showUnread ? PatientColors.primary : PatientColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: showUnread ? PatientColors.primary : PatientColors.onSurfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: PatientColors.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Read notifications tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showUnread = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !showUnread ? PatientColors.primaryLight : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: !showUnread ? PatientColors.success : PatientColors.onSurfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: PatientColors.onPrimary,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Read notifications',
                            style: TextStyle(
                              color: !showUnread ? PatientColors.success : PatientColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: !showUnread ? PatientColors.success : PatientColors.onSurfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$readCount',
                              style: const TextStyle(
                                color: PatientColors.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Notifications list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: showUnread 
                  ? notifications.where((n) => !n.isRead).length
                  : notifications.where((n) => n.isRead).length,
              itemBuilder: (context, index) {
                final filteredNotifications = showUnread
                    ? notifications.where((n) => !n.isRead).toList()
                    : notifications.where((n) => n.isRead).toList();
                
                if (filteredNotifications.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            showUnread ? Icons.notifications_none : Icons.check_circle_outline,
                            size: 64,
                            color: PatientColors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            showUnread ? 'No unread notifications' : 'No read notifications',
                            style: const TextStyle(
                              color: PatientColors.onSurfaceVariant,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                final notification = filteredNotifications[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: PatientColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: PatientColors.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Left colored border
                        Container(
                          width: 4,
                          height: 40,
                          decoration: BoxDecoration(
                            color: PatientColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: notification.iconColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            notification.icon,
                            color: notification.iconColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: PatientColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notification.time,
                                style: const TextStyle(
                                  color: PatientColors.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Action buttons
                        Column(
                          children: [
                            if (!notification.isRead) ...[
                              GestureDetector(
                                onTap: () => markAsRead(notification.id),
                                child: Text(
                                  'Mark as read',
                                  style: TextStyle(
                                    color: PatientColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            GestureDetector(
                              onTap: () => dismissNotification(notification.id),
                              child: Icon(
                                Icons.close,
                                color: PatientColors.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });
}
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import '../../services/notification_api_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum NotificationType {
  taskReminder,
  medicationReminder,
  appointmentReminder,
  skipRequest,
  dailyReport,
  emergency,
}

class NotificationItem {
  final int id;
  final String title;
  final String subtitle;
  final DateTime createdAt;
  bool isRead;
  final NotificationType type;
  final String? caregiverName;
  final String? taskName;
  final int? taskId;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.isRead,
    required this.type,
    this.caregiverName,
    this.taskName,
    this.taskId,
  });

  // Convert from API model
  factory NotificationItem.fromApiModel(NotificationModel model) {
    NotificationType type;
    switch (model.notificationType.toUpperCase()) {
      case 'TASK_REMINDER':
        type = NotificationType.taskReminder;
        break;
      case 'MEDICATION_REMINDER':
        type = NotificationType.medicationReminder;
        break;
      case 'APPOINTMENT_REMINDER':
        type = NotificationType.appointmentReminder;
        break;
      case 'SKIP_REQUEST':
        type = NotificationType.skipRequest;
        break;
      case 'DAILY_REPORT':
        type = NotificationType.dailyReport;
        break;
      case 'EMERGENCY':
        type = NotificationType.emergency;
        break;
      default:
        type = NotificationType.taskReminder;
    }

    return NotificationItem(
      id: model.notificationId,
      title: model.title,
      subtitle: model.message,
      createdAt: model.createdAt,
      isRead: model.isRead,
      type: type,
      caregiverName:
          model.patientName, // Using patientName field for caregiver info
      taskName: model.taskName,
      taskId: model.taskId,
    );
  }

  String get timeAgo => timeago.format(createdAt);

  IconData get icon {
    switch (type) {
      case NotificationType.medicationReminder:
        return Icons.medical_services;
      case NotificationType.skipRequest:
        return Icons.playlist_add_check;
      case NotificationType.taskReminder:
        return Icons.task_alt;
      case NotificationType.appointmentReminder:
        return Icons.calendar_today;
      case NotificationType.dailyReport:
        return Icons.assessment;
      case NotificationType.emergency:
        return Icons.warning;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.medicationReminder:
        return PatientColors.activityMedicine;
      case NotificationType.skipRequest:
        return PatientColors.error;
      case NotificationType.taskReminder:
        return PatientColors.primary;
      case NotificationType.appointmentReminder:
        return PatientColors.activitySocial;
      case NotificationType.dailyReport:
        return PatientColors.activityPhysical;
      case NotificationType.emergency:
        return Colors.red;
    }
  }
}

class PatientNotificationScreen extends StatefulWidget {
  const PatientNotificationScreen({Key? key}) : super(key: key);

  @override
  State<PatientNotificationScreen> createState() =>
      _PatientNotificationScreenState();
}

class _PatientNotificationScreenState extends State<PatientNotificationScreen> {
  final NotificationApiService _apiService = NotificationApiService();
  List<NotificationItem> notifications = [];
  bool showUnread = true;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiNotifications = await _apiService.getPatientNotifications();
      setState(() {
        notifications = apiNotifications
            .map((model) => NotificationItem.fromApiModel(model))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load notifications: $e';
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading notifications: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<NotificationItem> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  List<NotificationItem> get readNotifications =>
      notifications.where((n) => n.isRead).toList();

  int get unreadCount => unreadNotifications.length;
  int get readCount => readNotifications.length;

  Future<void> markAsRead(int id) async {
    try {
      await _apiService.markAsRead(id);
      await _loadNotifications(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification marked as read'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error marking as read: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> dismissNotification(int id) async {
    try {
      await _apiService.deleteNotification(id);
      await _loadNotifications(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification deleted'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting notification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
            icon: const Icon(
              Icons.notifications,
              color: PatientColors.onSurface,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.patientNotifications);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadNotifications,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              child: Column(
                children: [
                  // Tab section
                  Container(
                    color: PatientColors.surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                                color: showUnread
                                    ? PatientColors.primaryLight
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: showUnread
                                          ? PatientColors.primary
                                          : PatientColors.onSurfaceVariant,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Unread notification',
                                    style: TextStyle(
                                      color: showUnread
                                          ? PatientColors.primary
                                          : PatientColors.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: showUnread
                                          ? PatientColors.primary
                                          : PatientColors.onSurfaceVariant,
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
                                color: !showUnread
                                    ? PatientColors.primaryLight
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: !showUnread
                                          ? PatientColors.success
                                          : PatientColors.onSurfaceVariant,
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
                                      color: !showUnread
                                          ? PatientColors.success
                                          : PatientColors.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !showUnread
                                          ? PatientColors.success
                                          : PatientColors.onSurfaceVariant,
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
                    child: Builder(
                      builder: (context) {
                        final filteredNotifications = showUnread
                            ? unreadNotifications
                            : readNotifications;

                        if (filteredNotifications.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    showUnread
                                        ? Icons.notifications_none
                                        : Icons.check_circle_outline,
                                    size: 64,
                                    color: PatientColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    showUnread
                                        ? 'No unread notifications'
                                        : 'No read notifications',
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

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
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
                                        color: notification.iconColor
                                            .withOpacity(0.1),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            notification.timeAgo,
                                            style: const TextStyle(
                                              color: PatientColors
                                                  .onSurfaceVariant,
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
                                            onTap: () =>
                                                markAsRead(notification.id),
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
                                          onTap: () => dismissNotification(
                                            notification.id,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color:
                                                PatientColors.onSurfaceVariant,
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

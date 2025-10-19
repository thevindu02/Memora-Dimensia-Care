import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
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

class NotificationData {
  final int id;
  final String title;
  final String subtitle;
  final DateTime createdAt;
  final bool isUnread;
  final NotificationType type;
  final String? patientName;
  final String? taskName;
  final int? taskId;

  NotificationData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.isUnread,
    required this.type,
    this.patientName,
    this.taskName,
    this.taskId,
  });

  // Convert from API model
  factory NotificationData.fromApiModel(NotificationModel model) {
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
      default:
        type = NotificationType.taskReminder;
    }

    return NotificationData(
      id: model.notificationId,
      title: model.title,
      subtitle: model.message,
      createdAt: model.createdAt,
      isUnread: !model.isRead,
      type: type,
      patientName: model.patientName,
      taskName: model.taskName,
      taskId: model.taskId,
    );
  }

  String get timeAgo => timeago.format(createdAt);
}

class CaregiverNotificationScreen extends StatefulWidget {
  const CaregiverNotificationScreen({Key? key}) : super(key: key);

  @override
  State<CaregiverNotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends State<CaregiverNotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NotificationApiService _apiService = NotificationApiService();

  List<NotificationData> notifications = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiNotifications = await _apiService.getCaregiverNotifications();
      setState(() {
        notifications = apiNotifications
            .map((model) => NotificationData.fromApiModel(model))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load notifications: $e';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading notifications: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<NotificationData> get unreadNotifications =>
      notifications.where((n) => n.isUnread).toList();

  List<NotificationData> get readNotifications =>
      notifications.where((n) => !n.isUnread).toList();

  Future<void> _markAsRead(int notificationId) async {
    try {
      await _apiService.markAsRead(notificationId);
      await _loadNotifications(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification marked as read'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error marking as read: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteNotification(int notificationId) async {
    try {
      await _apiService.deleteNotification(notificationId);
      await _loadNotifications(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification deleted'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFF2B3F99), // Calm Navy
              unselectedLabelColor: Color(0xFF390797), // Deep Purple
              indicatorColor: Color(0xFF2B3F99), // Calm Navy
              indicatorWeight: 2,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Unread'),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFA0C4FD), // Light Sky Blue
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${unreadNotifications.length}',
                          style: const TextStyle(
                            color: Color(0xFF2B3F99), // Calm Navy
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Tab(text: 'Read'),
              ],
            ),
          ),
        ),
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
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Unread notifications tab
                  unreadNotifications.isEmpty
                      ? const Center(child: Text('No unread notifications'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: unreadNotifications.length,
                          itemBuilder: (context, index) {
                            return NotificationCard(
                              notification: unreadNotifications[index],
                              onMarkAsRead: _markAsRead,
                              onDelete: _deleteNotification,
                            );
                          },
                        ),
                  // Read notifications tab
                  readNotifications.isEmpty
                      ? const Center(child: Text('No read notifications'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: readNotifications.length,
                          itemBuilder: (context, index) {
                            return NotificationCard(
                              notification: readNotifications[index],
                              onMarkAsRead: _markAsRead,
                              onDelete: _deleteNotification,
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final Function(int) onMarkAsRead;
  final Function(int) onDelete;
  final Function(NotificationData)? onSkipTask;
  final Function(NotificationData)? onApproveSkip;
  final Function(NotificationData)? onDenySkip;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
    this.onSkipTask,
    this.onApproveSkip,
    this.onDenySkip,
  }) : super(key: key);

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.taskReminder:
        return Icons.task_alt;
      case NotificationType.skipRequest:
        return Icons.pause_circle;
      case NotificationType.medicationReminder:
        return Icons.medication;
      case NotificationType.emergency:
        return Icons.warning;
      case NotificationType.dailyReport:
        return Icons.assessment;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.taskReminder:
        return Color(0xFF2B3F99); // Calm Navy
      case NotificationType.skipRequest:
        return Color(0xFFC3B1E1); // Soft Lavender
      case NotificationType.medicationReminder:
        return Color(0xFFA0C4FD); // Light Sky Blue
      case NotificationType.emergency:
        return Colors.red;
      case NotificationType.dailyReport:
        return Color(0xFF390797); // Deep Purple
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isUnread
            ? Colors.white
            : Color(0xFFC3B1E1).withOpacity(0.18), // Soft Lavender for read
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Notification type icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getNotificationColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getNotificationIcon(),
                  color: _getNotificationColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: notification.isUnread
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Time and unread indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    notification.timeAgo,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  if (notification.isUnread) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2B3F99), // Calm Navy
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          // Action buttons
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Remove button (always shown)
              TextButton.icon(
                onPressed: () => onDelete(notification.id),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Remove', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
              // Mark as read button (only for unread notifications)
              if (notification.isUnread) ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => onMarkAsRead(notification.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA0C4FD), // Light Sky Blue
                    foregroundColor: Color(0xFF2B3F99), // Calm Navy
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text(
                    'Mark as Read',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B3F99),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// Usage in your main screen where you handle bottom navigation
class MainScren extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScren> {
  int _currentIndex = 0;

  // Your existing screens list
  final List<Widget> _screens = [
    Container(), // Home screen
    Container(), // Patients screen
    Container(), // Articles screen
    Container(), // Profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Home', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Colors.black),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CaregiverNotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            // Patients tab
            // Navigate to detailed patients screen
            Navigator.pushNamed(context, AppRoutes.caregiverPatients);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.viewArticleList);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.caregiverProfile);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2B3F99),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Community',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

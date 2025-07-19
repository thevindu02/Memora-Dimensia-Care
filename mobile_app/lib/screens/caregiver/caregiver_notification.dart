import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

enum NotificationType {
  taskReminder,
  skipRequest,
  dailyReport,
  emergency,
  medicationReminder,
}

class NotificationData {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;
  final NotificationType type;
  final String? patientName;
  final String? taskName;
  final String? skipReason;

  NotificationData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
    required this.type,
    this.patientName,
    this.taskName,
    this.skipReason,
  });
}

class CaregiverNotificationScreen extends StatefulWidget {
  const CaregiverNotificationScreen({Key? key}) : super(key: key);

  @override
  State<CaregiverNotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<CaregiverNotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample notification data
  List<NotificationData> notifications = [
    NotificationData(
      id: '1',
      title: 'Skip Request: Morning Exercise',
      subtitle: 'Patient: John Doe',
      time: '10 min ago',
      isUnread: true,
      type: NotificationType.taskReminder,
      patientName: 'John Doe',
      taskName: 'Breakfast Time',
    ),
    NotificationData(
      id: '2',
      title: 'Task Reminder: Breakfast Time',
      subtitle: 'Patient: Mary Smith wants to skip task',
      time: '30 min ago',
      isUnread: true,
      type: NotificationType.skipRequest,
      patientName: 'Mary Smith',
      taskName: 'Morning Exercise',
    ),
    NotificationData(
      id: '3',
      title: 'Medication Reminder',
      subtitle: 'Patient: Bob Johnson - Blood pressure medication',
      time: '1 hr ago',
      isUnread: true,
      type: NotificationType.medicationReminder,
      patientName: 'Bob Johnson',
    ),
    NotificationData(
      id: '4',
      title: 'Daily Report Generated',
      subtitle: 'Patient activity summary available',
      time: '2 days ago',
      isUnread: false,
      type: NotificationType.dailyReport,
    ),
    NotificationData(
      id: '5',
      title: 'Task Completed: Lunch Time',
      subtitle: 'Patient: John Doe completed task',
      time: '3 days ago',
      isUnread: false,
      type: NotificationType.taskReminder,
      patientName: 'John Doe',
      taskName: 'Lunch Time',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationData> get unreadNotifications =>
      notifications.where((n) => n.isUnread).toList();

  List<NotificationData> get readNotifications =>
      notifications.where((n) => !n.isUnread).toList();

  void _markAsRead(String notificationId) {
    setState(() {
      int index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = NotificationData(
          id: notifications[index].id,
          title: notifications[index].title,
          subtitle: notifications[index].subtitle,
          time: notifications[index].time,
          isUnread: false,
          type: notifications[index].type,
          patientName: notifications[index].patientName,
          taskName: notifications[index].taskName,
          skipReason: notifications[index].skipReason,
        );
      }
    });
  }

  void _showSkipTaskDialog(NotificationData notification) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Skip Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'You are about to skip:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.taskName ?? 'Task',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Reason for skipping:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Please provide a reason...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Handle skip task logic here
                        Navigator.pop(context);
                        _markAsRead(notification.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Task skipped: ${notification.taskName}'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Skip Task'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _approveSkipRequest(NotificationData notification) {
    // Handle approve skip request logic here
    _markAsRead(notification.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Skip request approved for ${notification.patientName}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _denySkipRequest(NotificationData notification) {
    // Handle deny skip request logic here
    _markAsRead(notification.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Skip request denied for ${notification.patientName}'),
        backgroundColor: Colors.red,
      ),
    );
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
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.blue,
              indicatorWeight: 2,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Unread'),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${unreadNotifications.length}',
                          style: const TextStyle(
                            color: Colors.white,
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
      body: TabBarView(
        controller: _tabController,
        children: [
          // Unread notifications tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: unreadNotifications.length,
            itemBuilder: (context, index) {
              return NotificationCard(
                notification: unreadNotifications[index],
                onMarkAsRead: _markAsRead,
                onSkipTask: _showSkipTaskDialog,
                onApproveSkip: _approveSkipRequest,
                onDenySkip: _denySkipRequest,
              );
            },
          ),
          // Read notifications tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: readNotifications.length,
            itemBuilder: (context, index) {
              return NotificationCard(
                notification: readNotifications[index],
                onMarkAsRead: _markAsRead,
                onSkipTask: _showSkipTaskDialog,
                onApproveSkip: _approveSkipRequest,
                onDenySkip: _denySkipRequest,
              );
            },
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final Function(String) onMarkAsRead;
  final Function(NotificationData) onSkipTask;
  final Function(NotificationData) onApproveSkip;
  final Function(NotificationData) onDenySkip;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onMarkAsRead,
    required this.onSkipTask,
    required this.onApproveSkip,
    required this.onDenySkip,
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
        return Colors.blue;
      case NotificationType.skipRequest:
        return Colors.orange;
      case NotificationType.medicationReminder:
        return Colors.green;
      case NotificationType.emergency:
        return Colors.red;
      case NotificationType.dailyReport:
        return Colors.purple;
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
        color: Colors.white,
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
                        fontWeight: notification.isUnread ? FontWeight.w600 : FontWeight.w400,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (notification.type == NotificationType.skipRequest && notification.skipReason != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Reason: ${notification.skipReason}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange[700],
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Time and unread indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    notification.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  if (notification.isUnread) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
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
              if (notification.type == NotificationType.skipRequest && notification.isUnread) ...[
                TextButton(
                  onPressed: () => onDenySkip(notification),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Deny', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => onApproveSkip(notification),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text('Approve', style: TextStyle(fontSize: 12)),
                ),
              ] else if (notification.type == NotificationType.taskReminder && notification.isUnread) ...[
                TextButton(
                  onPressed: () => onSkipTask(notification),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Skip Task', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => onMarkAsRead(notification.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text('Mark as Read', style: TextStyle(fontSize: 12)),
                ),
              ] else if (notification.isUnread) ...[
                ElevatedButton(
                  onPressed: () => onMarkAsRead(notification.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text('Mark as Read', style: TextStyle(fontSize: 12)),
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
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
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
          if (index == 1) { // Patients tab
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
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
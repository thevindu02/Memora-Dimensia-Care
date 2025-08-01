import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';

class GuardianNotificationsScreen extends StatelessWidget {
  static const Color softLavender = Color(0xFFC3B1E1);
  static const Color deepPurple = Color(0xFF390797);
  static const Color lightSkyBlue = Color(0xFFA0C4FD);
  static const Color calmNavy = Color(0xFF2B3F99);

  Color _getNotifColor(String type, [String? status]) {
    switch (type) {
      case 'Caregiver Request':
        if (status == 'Accepted') return lightSkyBlue;
        if (status == 'Rejected') return deepPurple;
        if (status == 'Expired') return softLavender;
        return calmNavy;
      case 'Subscription':
        if (status == 'Active') return deepPurple;
        if (status == 'Expired') return calmNavy;
        return lightSkyBlue;
      case 'Article Reply':
        return softLavender;
      case 'Q&A Reply':
        return lightSkyBlue;
      default:
        return calmNavy;
    }
  }

  final List<Map<String, dynamic>> notifications = [
    {
      'type': 'Caregiver Request',
      'status': 'Accepted',
      'title': 'Caregiver Request Accepted',
      'message': 'Your connection request to John Smith was accepted.',
      'time': '10:30 AM',
      'icon': Icons.person_add_alt_1,
    },
    {
      'type': 'Caregiver Request',
      'status': 'Rejected',
      'title': 'Caregiver Request Rejected',
      'message': 'Your connection request to Jane Doe was rejected.',
      'time': '9:15 AM',
      'icon': Icons.person_remove_alt_1,
    },
    {
      'type': 'Caregiver Request',
      'status': 'Expired',
      'title': 'Caregiver Request Expired',
      'message': 'Your connection request to Michael Lee expired.',
      'time': 'Yesterday',
      'icon': Icons.hourglass_empty,
    },
    {
      'type': 'Subscription',
      'status': 'Active',
      'title': 'Subscription Active',
      'message': 'Your Premium Plan expires in 5 days.',
      'time': 'Today',
      'icon': Icons.subscriptions,
    },
    {
      'type': 'Subscription',
      'status': 'Expired',
      'title': 'Subscription Expired',
      'message': 'Your Basic Plan has expired. Renew to continue services.',
      'time': '2 days ago',
      'icon': Icons.warning_amber_rounded,
    },
    {
      'type': 'Article Reply',
      'title': 'New Reply to Your Comment',
      'message':
          'Anna replied to your comment on "Caring for Dementia Patients".',
      'time': '8:00 AM',
      'icon': Icons.forum,
    },
    {
      'type': 'Q&A Reply',
      'title': 'New Answer to Your Question',
      'message': 'Dr. Brown answered your question in Q&A Forums.',
      'time': '7:45 AM',
      'icon': Icons.question_answer,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final Color notifColor = _getNotifColor(
            notif['type'],
            notif['status'],
          );
          return Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: notifColor.withOpacity(0.10),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: notifColor.withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: notifColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(notif['icon'], color: notifColor, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.info,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        notif['message'],
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurface,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        notif['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

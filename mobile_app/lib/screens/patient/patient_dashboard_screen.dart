import 'package:flutter/material.dart';
import 'dart:ui';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import 'select_routine_screen.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({Key? key}) : super(key: key);

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  int currentBottomNavIndex = 0;

  final List<Activity> activities = [
    Activity(
      icon: Icons.restaurant,
      title: 'Breakfast Time',
      subtitle: 'Morning meal',
      time: '8:00 AM',
      isCompleted: true,
      color: AppColors.primary,
    ),
    Activity(
      icon: Icons.dinner_dining,
      title: 'Dinner Time',
      subtitle: 'Evening meal',
      time: '6:00 PM',
      isCompleted: false,
      color: AppColors.primary,
    ),
    Activity(
      icon: Icons.bathtub,
      title: 'Bathing Time',
      subtitle: 'Personal hygiene',
      time: '7:00 PM',
      isCompleted: false,
      color: AppColors.primary,
    ),
    Activity(
      icon: Icons.bed,
      title: 'Sleep Time',
      subtitle: 'Night rest',
      time: '7:00 PM',
      isCompleted: false,
      color: AppColors.primary,
    ),
  ];

  void _selectActivity(Activity activity) {
    setState(() {
      // Deselect all activities first
      for (var a in activities) {
        a.isSelected = false;
      }
      // Select the clicked activity
      activity.isSelected = true;
    });
  }

  void _showSkipDialog(Activity activity) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              ),
            ),
            // Dialog
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Skip Task',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'You are about to skip: ${activity.title}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Reason for skipping:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: reasonController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Please provide a reason...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (reasonController.text.trim().isNotEmpty) {
                              setState(() {
                                activity.isSkipped = true;
                                activity.isCompleted = false;
                                activity.isSelected = false; // Deselect when skipped
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Task "${activity.title}" has been skipped'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please provide a reason for skipping'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Skip Task',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: PatientColors.backgroundWhite,
        automaticallyImplyLeading: false, // ← disables back icon
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/light_logo.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'Memora',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.patientNotifications);
            },
          ),
        ],
      ),
      //Expanded(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage('assets/images/profile_avatar.png'),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Good Morning, Sarah',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Today, Dec 21',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Task Summary Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.lightAccent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Today\'s Tasks',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      Icons.list,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '8',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.successBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Completed',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      Icons.check,
                                      color: AppColors.success,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '3',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Daily Activities Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Activities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SelectTypeWithErrorHandling(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Add Task'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightAccent,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Activities List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return ActivityCard(
                        activity: activity,
                        onSelect: () => _selectActivity(activity),
                        onToggle: () {
                          setState(() {
                            activity.isCompleted = !activity.isCompleted;
                            if (activity.isCompleted) {
                              activity.isSkipped = false; // Reset skip when completed
                              activity.isSelected = false; // Deselect when completed
                            }
                          });
                        },
                        onSkip: () => _showSkipDialog(activity),
                        onUndoSkip: () {
                          setState(() {
                            activity.isSkipped = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task "${activity.title}" is back on track'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Quick Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            QuickActionCard(
                              icon: Icons.add,
                              title: 'Add Medication',
                              color: Colors.blue[100]!,
                              onTap: () {},
                            ),
                            const SizedBox(width: 15),
                            QuickActionCard(
                              icon: Icons.favorite,
                              title: 'Log Vitals',
                              color: Colors.green[100]!,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
          ),
        ),
     // ),
    );
  }
}

class Activity {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  bool isCompleted;
  bool isSkipped;
  bool isSelected;
  final Color color;

  Activity({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isCompleted,
    this.isSkipped = false,
    this.isSelected = false,
    required this.color,
  });
}

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onToggle;
  final VoidCallback onSkip;
  final VoidCallback onUndoSkip;
  final VoidCallback onSelect;

  const ActivityCard({
    Key? key,
    required this.activity,
    required this.onToggle,
    required this.onSkip,
    required this.onUndoSkip,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: activity.isSelected
                  ? AppColors.lightAccent
                  : activity.isSkipped 
                      ? Colors.orange.shade50 
                      : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: activity.isSelected
                    ? AppColors.primary
                    : activity.isSkipped 
                        ? Colors.orange.shade300
                        : Colors.grey.shade200,
                width: activity.isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: activity.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        activity.icon,
                        color: activity.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                activity.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  decoration: activity.isSkipped ? TextDecoration.lineThrough : null,
                                  color: activity.isSkipped ? Colors.grey : Colors.black87,
                                ),
                              ),
                              if (activity.isSkipped) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'SKIPPED',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: activity.isSkipped ? Colors.grey.shade400 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          activity.time,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: activity.isSkipped ? Colors.grey : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: activity.isSkipped ? null : onToggle,
                          child: activity.isCompleted
                              ? Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 20,
                                )
                              : Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: activity.isSkipped 
                                          ? Colors.grey.shade300
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Skip button for selected task
                if (activity.isSelected && !activity.isCompleted && !activity.isSkipped)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSkip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 1,
                      ),
                      child: const Text(
                        'Skip Task',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                // Show undo skip option for skipped tasks
                if (activity.isSkipped) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onUndoSkip,
                      icon: const Icon(Icons.undo, size: 16),
                      label: const Text('Undo Skip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade100,
                        foregroundColor: Colors.orange.shade700,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const QuickActionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue[700],
                  size: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
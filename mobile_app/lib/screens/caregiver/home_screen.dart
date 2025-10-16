import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PatientsScreen(),
    const ArticlesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        unselectedItemColor: Color(0xFF2B3F99),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.caregiverNotification);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today’s Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildSummaryCard(context),
            const SizedBox(height: 20),
            _buildEmergencyContacts(context),
            const SizedBox(height: 20),
            _buildUrgentTasksSection(context),
            const SizedBox(height: 20),
            _buildGuardianRequestsSection(context),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryLight.withOpacity(
                0.08,
              ), // Light Sky Blue, more transparent
              AppColors.primaryLight.withOpacity(0.06),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppColors.primaryLight.withOpacity(0.10),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem('3', 'Patients', AppColors.primaryDark),
                  _buildStatItem('12', 'Tasks', AppColors.primaryDark),
                  _buildStatItem('2', 'Urgent', AppColors.primaryDark),
                  _buildStatItem('1', 'Missed', AppColors.primaryDark),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.75,
                backgroundColor: AppColors.primaryLight.withOpacity(
                  0.10,
                ), // Lighter accent
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 8),
              Text(
                '75% of daily tasks completed',
                style: TextStyle(fontSize: 12, color: Color(0xFF2B3F99)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildUrgentTasksSection(BuildContext context) {
    // Example urgent tasks list (can be replaced with dynamic data)
    final urgentTasks = [
      {
        'title': 'Medication Due Soon',
        'subtitle': 'John - Morning pills in 15 minutes',
        'icon': Icons.warning_amber,
        'iconColor': AppColors.primaryDark,
      },
      // Add more tasks here if needed
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Urgent Tasks',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...urgentTasks.map(
          (task) => Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(
                0.13,
              ), // Light Sky Blue background with low opacity
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.10),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    task['icon'] as IconData,
                    color: task['iconColor'] as Color,
                    size: 28,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          task['subtitle'] as String,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuardianRequestsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guardian Requests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.caregiverConnectionRequests);
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryLight.withOpacity(0.08),
                    AppColors.primaryLight.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.primaryLight.withOpacity(0.10),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF2B3F99)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'New Requests from Guardians',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.primaryDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Request to connect with a patient',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContacts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contacts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildContactChip(
              context,
              'Ambulance',
              Icons.local_hospital,
              Colors.red,
            ),
            _buildContactChip(
              context,
              'Hospital Hotline',
              Icons.local_hospital,
              AppColors.primaryLight,
            ),
            _buildContactChip(
              context,
              'Mental Health Crisis',
              Icons.psychology,
              Color(0xFF390797),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactChip(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    Color bgColor = color;
    Color textColor = Colors.white;
    if (label == 'Ambulance') {
      bgColor = Color(0xFFFF5252).withOpacity(0.08);
      textColor = Color(0xFFFF5252);
    } else if (label == 'Doctor') {
      bgColor = AppColors.primaryLight.withOpacity(0.08);
      textColor = Color(0xFF2B3F99).withOpacity(0.7);
    } else if (label == 'Hospital Hotline') {
      bgColor = AppColors.primaryLight.withOpacity(0.28);
      textColor = Color(0xFF2B3F99).withOpacity(0.7);
    } else if (label == 'Family') {
      bgColor = Color(0xFFC3B1E1).withOpacity(0.08);
      textColor = Color(0xFF390797).withOpacity(0.7);
    } else if (label == 'Support') {
      bgColor = Color(0xFF390797).withOpacity(0.08);
      textColor = Color(0xFF390797).withOpacity(0.7);
    } else if (label == 'Mental Health Crisis') {
      bgColor = AppColors.primaryLight.withOpacity(0.28);
      textColor = AppColors.primaryDark;
    }
    return ActionChip(
      avatar: Icon(icon, size: 20, color: textColor),
      label: Text(label, style: TextStyle(color: textColor)),
      onPressed: () {
        if (label == 'Ambulance') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Emergency Call'),
              content: Text('This will ring 1990 for Ambulance service.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK', style: TextStyle(color: Color(0xFF2B3F99))),
                ),
              ],
            ),
          );
        } else if (label == 'Fire & Rescue') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Emergency Call'),
              content: Text('This will ring 110 for Fire & Rescue service.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK', style: TextStyle(color: Color(0xFF2B3F99))),
                ),
              ],
            ),
          );
        } else if (label == 'Mental Health Crisis') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Emergency Call'),
              content: Text(
                'This will ring 1926 for Mental Health Crisis support.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK', style: TextStyle(color: Color(0xFF2B3F99))),
                ),
              ],
            ),
          );
        } else if (label == 'Hospital Hotline') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Emergency Call'),
              content: Text('This will ring 1919 for Hospital Hotline.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK', style: TextStyle(color: Color(0xFF2B3F99))),
                ),
              ],
            ),
          );
        }
      },
      backgroundColor: bgColor,
      shape: label == 'Ambulance'
          ? RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xFFFF5252).withOpacity(0.18),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
    );
  }
}

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Patients Screen')));
  }
}

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Articles Screen')));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profile Screen')));
  }
}

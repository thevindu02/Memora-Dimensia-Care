import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import '../../services/caregiver_service.dart';
import '../../services/schedule_service.dart';
import '../../services/daily_activity_service.dart';
import '../../services/task_service.dart' as TaskAPI;
import '../../services/medication_service.dart';
import '../../services/appointment_service.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  int _patientCount = 0;
  int _completedTasks = 0;
  int _pendingTasks = 0;
  int _skippedTasks = 0;
  int _totalTasks = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get caregiver ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      
      // Get the actual caregiver ID (not user ID)
      int? caregiverId = prefs.getInt('current_caregiver_id');
      
      print('🔑 Dashboard - Caregiver ID from prefs: $caregiverId');

      if (caregiverId == null) {
        // Fallback: try to get from userId and convert to caregiverId
        final userId = prefs.getInt('userId');
        print('🔄 Dashboard - User ID found: $userId, fetching caregiver ID...');
        
        if (userId != null) {
          caregiverId = await CaregiverService.getCaregiverIdByUserId(userId);
          if (caregiverId != null) {
            // Store it for future use
            await prefs.setInt('current_caregiver_id', caregiverId);
            print('✅ Dashboard - Caregiver ID fetched and stored: $caregiverId');
          }
        }
      }
      
      print('🔑 Dashboard - Final Caregiver ID: $caregiverId');

      if (caregiverId == null) {
        print('❌ Dashboard - Caregiver ID not found in SharedPreferences');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Fetch connected patients
      print('📞 Dashboard - Fetching connected requests for caregiver $caregiverId');
      final connectedRequests = await CaregiverService.getConnectedRequests(caregiverId);
      final patientCount = connectedRequests.length;
      print('👥 Dashboard - Found $patientCount connected patients');
      print('📋 Dashboard - Connected requests: $connectedRequests');

      // Get today's date in YYYY-MM-DD format
      final today = DateTime.now();
      final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      print('📅 Dashboard - Today\'s date: $dateStr');

      int totalCompleted = 0;
      int totalPending = 0;
      int totalSkipped = 0;
      int totalTasks = 0;

      // For each patient, fetch their today's tasks
      for (var request in connectedRequests) {
        final patientId = request['patientId'] as int?;
        if (patientId == null) {
          print('⚠️ Dashboard - Patient ID is null in request: $request');
          continue;
        }

        print('🔍 Dashboard - Processing patient $patientId');

        try {
          // Get or create today's schedule for this patient
          final scheduleResult = await ScheduleService.getOrCreateSchedule(patientId, dateStr);
          print('📆 Dashboard - Schedule result for patient $patientId: success=${scheduleResult.success}, data=${scheduleResult.data}');
          
          if (scheduleResult.success && scheduleResult.data != null) {
            final scheduleId = scheduleResult.data!['scheduleId'] as int;
            print('📋 Dashboard - Schedule ID for patient $patientId: $scheduleId');

            // Fetch all types of activities for this schedule
            await _fetchTasksForSchedule(scheduleId, (completed, pending, skipped, total) {
              print('✅ Dashboard - Patient $patientId tasks: completed=$completed, pending=$pending, skipped=$skipped, total=$total');
              totalCompleted += completed;
              totalPending += pending;
              totalSkipped += skipped;
              totalTasks += total;
            });
          } else {
            print('❌ Dashboard - Failed to get schedule for patient $patientId: ${scheduleResult.message}');
          }
        } catch (e) {
          print('❌ Dashboard - Error fetching tasks for patient $patientId: $e');
        }
      }

      print('📊 Dashboard - Final totals: patients=$patientCount, completed=$totalCompleted, pending=$totalPending, skipped=$totalSkipped, total=$totalTasks');

      setState(() {
        _patientCount = patientCount;
        _completedTasks = totalCompleted;
        _pendingTasks = totalPending;
        _skippedTasks = totalSkipped;
        _totalTasks = totalTasks;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Dashboard - Error loading dashboard data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchTasksForSchedule(
    int scheduleId,
    Function(int completed, int pending, int skipped, int total) callback,
  ) async {
    int completed = 0;
    int pending = 0;
    int skipped = 0;
    int total = 0;

    print('🔄 FetchTasks - Starting for schedule $scheduleId');

    try {
      // Fetch daily activities
      print('📋 FetchTasks - Fetching daily activities...');
      final dailyActivitiesResult = await DailyActivityService.getDailyActivities(scheduleId);
      print('📋 FetchTasks - Daily activities result: success=${dailyActivitiesResult.success}, count=${dailyActivitiesResult.data?.length ?? 0}');
      
      if (dailyActivitiesResult.success && dailyActivitiesResult.data != null) {
        for (var activity in dailyActivitiesResult.data!) {
          total++;
          if (activity.status == 'COMPLETED') {
            completed++;
          } else if (activity.status == 'SKIPPED' || activity.status == 'CANCELLED') {
            skipped++;
          } else {
            pending++;
          }
        }
        print('✅ FetchTasks - Daily activities: $total tasks (completed=$completed, pending=$pending, skipped=$skipped)');
      }

      // Fetch game tasks
      print('🎮 FetchTasks - Fetching game tasks...');
      final gameTasksResult = await TaskAPI.TaskService.getTasksByScheduleId(scheduleId);
      print('🎮 FetchTasks - Game tasks result: success=${gameTasksResult.success}, count=${gameTasksResult.data?.length ?? 0}');
      
      if (gameTasksResult.success && gameTasksResult.data != null) {
        for (var task in gameTasksResult.data!) {
          total++;
          if (task.status == 'COMPLETED') {
            completed++;
          } else if (task.status == 'SKIPPED' || task.status == 'CANCELLED') {
            skipped++;
          } else {
            pending++;
          }
        }
        print('✅ FetchTasks - After game tasks: $total total (completed=$completed, pending=$pending, skipped=$skipped)');
      }

      // Fetch medications
      print('💊 FetchTasks - Fetching medications...');
      final medications = await MedicationService.getMedicationSchedule(scheduleId);
      print('💊 FetchTasks - Medications count: ${medications.length}');
      
      for (var med in medications) {
        total++;
        if (med.status == 'COMPLETED') {
          completed++;
        } else if (med.status == 'SKIPPED' || med.status == 'CANCELLED') {
          skipped++;
        } else {
          pending++;
        }
      }
      print('✅ FetchTasks - After medications: $total total (completed=$completed, pending=$pending, skipped=$skipped)');

      // Fetch appointments
      print('📅 FetchTasks - Fetching appointments...');
      final appointments = await AppointmentService.getAppointments(scheduleId);
      print('📅 FetchTasks - Appointments count: ${appointments.length}');
      
      for (var appointment in appointments) {
        total++;
        if (appointment.status == 'COMPLETED') {
          completed++;
        } else if (appointment.status == 'SKIPPED' || appointment.status == 'CANCELLED') {
          skipped++;
        } else {
          pending++;
        }
      }
      print('✅ FetchTasks - Final totals: $total total (completed=$completed, pending=$pending, skipped=$skipped)');

      callback(completed, pending, skipped, total);
    } catch (e) {
      print('❌ FetchTasks - Error fetching tasks for schedule $scheduleId: $e');
      callback(0, 0, 0, 0);
    }
  }

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
    if (_isLoading) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 200,
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
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
            ),
          ),
        ),
      );
    }

    final completionRate = _totalTasks > 0 ? _completedTasks / _totalTasks : 0.0;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patients count at the top
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 20,
                    color: AppColors.primaryDark,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Managing $_patientCount ${_patientCount == 1 ? 'Patient' : 'Patients'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tasks breakdown
              Text(
                'Today\'s Tasks',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTaskStat(_completedTasks.toString(), 'Completed', Colors.green),
                  _buildTaskStat(_pendingTasks.toString(), 'Pending', Colors.orange),
                  _buildTaskStat(_skippedTasks.toString(), 'Skipped', Colors.red),
                ],
              ),

              const SizedBox(height: 16),

              // Progress bar with clearer label
              LinearProgressIndicator(
                value: completionRate,
                backgroundColor: AppColors.primaryLight.withOpacity(0.10),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 8),
              Text(
                '$_completedTasks of $_totalTasks tasks completed (${(completionRate * 100).toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
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
                              fontSize: 16,
                              color: AppColors.primaryDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Request to connect with a patient',
                            style: TextStyle(
                              fontSize: 14,
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

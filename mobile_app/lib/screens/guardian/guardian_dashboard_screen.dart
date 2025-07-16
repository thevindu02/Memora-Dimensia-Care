import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';


class GuardianDashboardScreen extends StatefulWidget {
  @override
  _GuardianDashboardScreenState createState() => _GuardianDashboardScreenState();
}

class _GuardianDashboardScreenState extends State<GuardianDashboardScreen> {
  int _selectedIndex = 0;

  // Mock data for patients
  List<Map<String, dynamic>> patients = [
    {
      'id': 1,
      'name': 'John Doe',
      'label': 'Patient 1',
      'avatar': 'assets/images/patient1.jpg', // You can replace with actual asset
    },
    {
      'id': 2,
      'name': 'Jane Smith',
      'label': 'Patient 2',
      'avatar': 'assets/images/patient2.jpg', // You can replace with actual asset
    },
  ];

  // Mock data for notifications grouped by patient and type
  Map<String, List<Map<String, dynamic>>> notifications = {
    'John Doe': [
      {
        'type': 'Medication Reminder',
        'message': 'Take at 8:00 AM',
        'time': '8:00 AM',
      },
      {
        'type': 'Appointment',
        'message': 'Doctor visit at 3:00 PM',
        'time': '3:00 PM',
      },
    ],
    'Jane Smith': [
      {
        'type': 'Medication Reminder',
        'message': 'Take at 9:00 AM',
        'time': '9:00 AM',
      },
    ],
  };

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.guardianPatientDetails,
            arguments: patient,
          );
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withOpacity(0.2),
        highlightColor: Colors.blue.withOpacity(0.1),
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 30,
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    patient['label'],
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
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withOpacity(0.3),
        highlightColor: Colors.blue.withOpacity(0.2),
        child: Container(
          width: 100,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFA0C4FD).withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: Color(0xFF2B3F99),
                ),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
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

  Widget _buildNotificationCard(String patientName, Map<String, dynamic> notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFA0C4FD).withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFA0C4FD).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                patientName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2B3F99),
                ),
              ),
              Spacer(),
              Text(
                notification['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            notification['type'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            notification['message'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Handle arguments passed from navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['selectedIndex'] != null) {
        setState(() {
          _selectedIndex = args['selectedIndex'];
        });
      }
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.guardianForums);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.guardianProfile);
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patients section
            if (patients.isNotEmpty) ...[
              for (var patient in patients) _buildPatientCard(patient),
              SizedBox(height: 24),
            ],

            // Quick Access section
            Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildQuickAccessButton(
                  icon: Icons.person_add,
                  label: 'Add Patient',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.guardianAddPatient);
                  },
                ),
                _buildQuickAccessButton(
                  icon: Icons.group_add,
                  label: 'Add Caregiver',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.guardianAddCaregiver);
                  },
                ),
                _buildQuickAccessButton(
                  icon: Icons.assessment,
                  label: 'Reports',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.guardianPatientsReports);
                  },
                ),
                _buildQuickAccessButton(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.guardianSettings);
                  },
                ),
              ],
            ),
            SizedBox(height: 32),

            // Notifications section
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            // Display notifications grouped by patient
            for (var patientName in notifications.keys) ...[
              for (var notification in notifications[patientName]!)
                _buildNotificationCard(patientName, notification),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF2B3F99),
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
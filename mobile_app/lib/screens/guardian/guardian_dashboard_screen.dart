import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';
import '../../services/guardian_service.dart'; // Added import for GuardianService
import '../../constants/color_constants.dart';
import '../../utils/name_utils.dart';
import 'guardian_bottom_nav_bar.dart';

class GuardianDashboardScreen extends StatefulWidget {
  @override
  _GuardianDashboardScreenState createState() =>
      _GuardianDashboardScreenState();
}

class _GuardianDashboardScreenState extends State<GuardianDashboardScreen> {
  int _selectedIndex = 0;

  List<dynamic> _patients = [];
  bool _isLoadingPatients = true;

  // Mock data for alerts grouped by patient and type
  Map<String, List<Map<String, dynamic>>> alerts = {
    'John Doe': [
      {
        'type': 'Task Skipped',
        'message': 'Medication was skipped for 3 consecutive days.',
        'time': '8:00 AM',
      },
    ],
    'Jane Smith': [],
    'Michael Lee': [
      {
        'type': 'Task Skipped',
        'message': 'Exercise routine missed for 2 days in a row.',
        'time': '6:45 AM',
      },
    ],
  };

  // Color palette - using AppColors for consistency

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'Wandering Alert':
        return Icons.location_off;
      case 'Task Skipped':
        return Icons.assignment_late;
      case 'Biometric Anomaly':
        return Icons.favorite;
      default:
        return Icons.warning;
    }
  }

  Color _getAlertColor(String type) {
    switch (type) {
      case 'Wandering Alert':
        return AppColors.error; // High contrast for wandering alerts
      case 'Task Skipped':
        return AppColors.accent;
      case 'Biometric Anomaly':
        return AppColors.primary;
      default:
        return AppColors.primaryLight;
    }
  }

  Widget _buildAlertCard(String patientName, Map<String, dynamic> alert) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getAlertColor(alert['type']).withOpacity(0.10),
            _getAlertColor(alert['type']).withOpacity(0.18),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getAlertColor(alert['type']).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getAlertColor(alert['type']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  patientName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _getAlertColor(alert['type']),
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  alert['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                _getAlertIcon(alert['type']),
                color: _getAlertColor(alert['type']),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                alert['type'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            alert['message'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    print(patient); // Add this line for debugging

    // Helper function to capitalize first letter of each word
    String capitalizeName(String? name) {
      if (name == null || name.isEmpty) return '';
      return name
          .split(' ')
          .map((word) {
            if (word.isEmpty) return word;
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          })
          .join(' ');
    }

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
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.blue.withOpacity(0.2),
        highlightColor: Colors.blue.withOpacity(0.1),
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                spreadRadius: 0,
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: AppColors.outline.withOpacity(0.05),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.info.withOpacity(0.1),
                      AppColors.primaryLight.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: AppColors.info, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NameUtils.formatPatientName(patient),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        patient['dementiaStage'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (patient['caregiverName'] != null) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Caregiver: ${capitalizeName(patient['caregiverName'])}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (patient['caregiverPhone'] != null) ...[
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              patient['caregiverPhone'],
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
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
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primaryLight.withOpacity(0.3),
        highlightColor: AppColors.primaryLight.withOpacity(0.2),
        child: Container(
          width: 100,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                spreadRadius: 0,
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: AppColors.outline.withOpacity(0.05),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.info.withOpacity(0.1),
                      AppColors.primaryLight.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 26, color: AppColors.info),
              ),
              SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchPatients();
    // Handle arguments passed from navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['selectedIndex'] != null) {
        setState(() {
          _selectedIndex = args['selectedIndex'];
        });
      }
    });
  }

  Future<void> _fetchPatients() async {
    final int? userId = await AuthService.getCurrentUserId();
    int? guardianId;
    if (userId != null) {
      guardianId = await GuardianService.getGuardianIdByUserId(userId);
    }
    if (guardianId != null) {
      final patients = await PatientService.getPatientsByGuardian(guardianId);
      setState(() {
        _patients = patients;
        _isLoadingPatients = false;
      });
    } else {
      setState(() {
        _patients = [];
        _isLoadingPatients = false;
      });
    }
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      // Already on Home - no need to navigate
      return;
    }

    // Update the selected index for visual feedback
    setState(() {
      _selectedIndex = index;
    });

    // Use the helper to handle navigation
    BottomNavHelper.handleNavigation(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/light_logo.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Text(
              'Memora Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              color: AppColors.onSurface,
              size: 28,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.guardianNotifications);
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Access section (moved to top)
            Row(
              children: [
                Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.info,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildQuickAccessButton(
                  icon: Icons.person_add_outlined,
                  label: 'Add Patient',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.guardianAddPatient);
                  },
                ),
                _buildQuickAccessButton(
                  icon: Icons.group_add_outlined,
                  label: 'Add Caregiver',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.guardianAddCaregiver,
                    );
                  },
                ),
                _buildQuickAccessButton(
                  icon: Icons.group_outlined,
                  label: 'Caregivers',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.guardianCaregiverList,
                    );
                  },
                ),
                _buildQuickAccessButton(
                  icon: Icons.assessment_outlined,
                  label: 'Reports',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.guardianPatientsReports,
                    );
                  },
                ),
                _buildQuickAccessButton(
                  icon: Icons.reviews_outlined,
                  label: 'Add Reviews',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.guardianAddReviews);
                  },
                ),
                _buildQuickAccessButton(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.guardianSettings);
                  },
                ),
              ],
            ),
            SizedBox(height: 40),

            // Your Patients section (moved after Quick Access)
            Row(
              children: [
                Text(
                  'Your Patients',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.info,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Patients list
            if (_isLoadingPatients)
              Center(
                child: Container(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.info),
                  ),
                ),
              )
            else if (_patients.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.person_add_outlined,
                      size: 48,
                      color: AppColors.onSurfaceVariant,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No patients found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add your first patient to get started',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._patients.map((p) => _buildPatientCard(p)).toList(),

            SizedBox(height: 40),

            // Alerts section
            Row(
              children: [
                Text(
                  'Alerts',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${alerts.values.fold(0, (sum, list) => sum + list.length)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Display alerts grouped by patient
            if (alerts.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      size: 48,
                      color: AppColors.onSurfaceVariant,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No alerts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All clear! No alerts at the moment.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else
              for (var patientName in alerts.keys) ...[
                for (var alert in alerts[patientName]!)
                  _buildAlertCard(patientName, alert),
              ],
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';
import '../../services/guardian_service.dart'; // Add this import
import '../../constants/color_constants.dart';
import '../../utils/name_utils.dart';

class GuardianAddCaregiverScreen extends StatefulWidget {
  @override
  _GuardianAddCaregiverScreenState createState() =>
      _GuardianAddCaregiverScreenState();
}

class _GuardianAddCaregiverScreenState
    extends State<GuardianAddCaregiverScreen> {
  Map<String, dynamic>? selectedPatient;
  List<Map<String, dynamic>> patients = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final int? userId = await AuthService.getCurrentUserId();
      int? guardianId;
      if (userId != null) {
        guardianId = await GuardianService.getGuardianIdByUserId(userId);
      }
      if (guardianId != null) {
        // Use new endpoint
        final response = await PatientService.getPatientsWithRequestStatus(
          guardianId,
        );
        setState(() {
          patients = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      } else {
        setState(() {
          patients = [];
          isLoading = false;
          errorMessage = 'Could not determine guardian ID.';
        });
      }
    } catch (e) {
      setState(() {
        patients = [];
        isLoading = false;
        errorMessage = 'Failed to fetch patients: ' + e.toString();
      });
    }
  }

  void _openChat(Map<String, dynamic> patient) {
    Navigator.pushNamed(
      context,
      AppRoutes.chatConversation,
      arguments: {
        'id': patient['caregiverId'],
        'name': patient['caregiverName'] ?? 'Caregiver',
        'role': 'Caregiver',
      },
    );
  }

  void _cancelRequest(Map<String, dynamic> patient) async {
    final connectionId = patient['connectionId'];
    if (connectionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to cancel request - connection ID not found'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Check if request is still within 24 hours
    if (!_canCancelRequest(patient)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot cancel request after 24 hours'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Request'),
          content: Text(
            'Are you sure you want to cancel the connection request for ${NameUtils.capitalizeName(patient['name'] ?? '')}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final success = await GuardianService.cancelConnectionRequest(
          connectionId,
        );
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connection request cancelled successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          // Refresh the patients list
          _fetchPatients();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to cancel request'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling request: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  bool _canCancelRequest(Map<String, dynamic> patient) {
    final requestDateTimeStr = patient['requestDateTime'];
    if (requestDateTimeStr == null) return false;

    try {
      final requestDateTime = DateTime.parse(requestDateTimeStr);
      final now = DateTime.now();
      final hoursElapsed = now.difference(requestDateTime).inHours;
      return hoursElapsed < 24;
    } catch (e) {
      print('Error parsing request date time: $e');
      return false;
    }
  }

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    bool isSelected = selectedPatient?['patientId'] == patient['patientId'];
    String status = patient['latestRequestStatus'] ?? 'NONE';

    // Debug logging to check what data we're receiving
    print(
      'Patient: ${patient['name']}, Status: $status, ConnectionId: ${patient['connectionId']}, RequestDateTime: ${patient['requestDateTime']}',
    );

    bool isDisabled =
        status == 'ACTIVE' ||
        status ==
            'PENDING'; // Disable both ACTIVE and PENDING for card selection
    String statusLabel;
    switch (status) {
      case 'ACTIVE':
        statusLabel = 'Caregiver Assigned';
        break;
      case 'PENDING':
        statusLabel = 'Request Pending';
        break;
      case 'REJECTED':
        statusLabel =
            'Previous request was rejected. You can send a new request.';
        break;
      case 'EXPIRED':
        statusLabel = 'Previous request expired. You can send a new request.';
        break;
      case 'CANCELLED':
        statusLabel =
            'Previous request was cancelled. You can send a new request.';
        break;
      default:
        statusLabel = '';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled
            ? null
            : () {
                setState(() {
                  selectedPatient = patient;
                });
              },
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.grey.withOpacity(0.08),
        highlightColor: Colors.grey.withOpacity(0.04),
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.18),
                spreadRadius: 1,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Patient info section with buttons outside opacity for PENDING status
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Patient info with opacity for disabled state
                    Opacity(
                      opacity: isDisabled ? 0.5 : 1.0,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.primaryLight.withOpacity(
                              0.3,
                            ),
                            child: Icon(
                              Icons.person,
                              color: AppColors.info,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Opacity(
                        opacity: isDisabled ? 0.5 : 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              NameUtils.capitalizeName(patient['name'] ?? ''),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.info,
                              ),
                            ),
                            SizedBox(height: 4),
                            if ((patient['dementiaStage'] ?? '') != '') ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFA0C4FD).withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  patient['dementiaStage'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.info,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                            if (statusLabel.isNotEmpty) ...[
                              SizedBox(height: 4),
                              Text(
                                statusLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: status == 'ACTIVE'
                                      ? Colors.green
                                      : status == 'PENDING'
                                      ? Colors.orange
                                      : status == 'CANCELLED'
                                      ? Colors.red
                                      : Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            // Debug: Check button visibility condition
                            Builder(
                              builder: (context) {
                                print(
                                  'Button condition check: status=$status, connectionId=${patient['connectionId']}, isSelected=$isSelected',
                                );
                                return SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Chat and Cancel buttons on the right side - at full opacity, closer to content
                    if (status == 'PENDING' &&
                        patient['connectionId'] != null) ...[
                      SizedBox(width: 8), // Reduced spacing from left content
                      Column(
                        children: [
                          SizedBox(
                            width: 90,
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () => _openChat(patient),
                              child: Text(
                                'Chat',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFA0C4FD),
                                foregroundColor: Color(0xFF2B3F99),
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                minimumSize: Size(0, 28),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          SizedBox(
                            width: 90,
                            height: 28,
                            child: ElevatedButton(
                              onPressed: _canCancelRequest(patient)
                                  ? () => _cancelRequest(patient)
                                  : null,
                              child: Text(
                                _canCancelRequest(patient)
                                    ? 'Cancel'
                                    : 'Expired',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _canCancelRequest(patient)
                                    ? Colors.red
                                    : AppColors.onSurfaceVariant,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                minimumSize: Size(0, 28),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaregiverTypeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Color(0xFF2B3F99).withOpacity(0.2),
        highlightColor: Color(0xFF2B3F99).withOpacity(0.1),
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(20),
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
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFA0C4FD).withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: AppColors.info),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Debug print to check patient data
    print('Patients for selection:');
    for (var p in patients) {
      print(
        'Name: ${p['name']}, ID: ${p['patientId']}, Status: ${p['latestRequestStatus']}',
      );
    }
    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Add Caregiver',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (selectedPatient != null) {
              setState(() {
                selectedPatient = null;
              });
            } else {
              Navigator.of(context).pushNamed(AppRoutes.guardianDashboard);
            }
          },
        ),
        actions: [
          if (selectedPatient == null)
            IconButton(
              icon: Icon(Icons.refresh, color: AppColors.info),
              onPressed: _fetchPatients,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPatients,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedPatient == null) ...[
                // Patient selection phase
                Text(
                  'Select Patient',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Choose which patient you want to add a caregiver for',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 20),
                if (isLoading)
                  Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading patients...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                else if (errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchPatients,
                          child: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFA0C4FD),
                            foregroundColor: Color(0xFF2B3F99),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (patients.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_add_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No patients found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add a patient first before adding a caregiver',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.guardianAddPatient,
                            );
                          },
                          child: Text('Add Patient'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFA0C4FD),
                            foregroundColor: Color(0xFF2B3F99),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  for (var patient in patients) _buildPatientCard(patient),
              ] else ...[
                // Caregiver type selection phase
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface, // PURE WHITE background
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        spreadRadius: 1,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Selected patient: ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: NameUtils.capitalizeName(
                                          selectedPatient?['name'] ?? 'N/A',
                                        ),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.info,
                                        ),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedPatient = null;
                              });
                            },
                            child: Text(
                              'Change',
                              style: TextStyle(
                                color: AppColors.info,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Choose Caregiver Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Select how you want to add a caregiver',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 20),
                _buildCaregiverTypeCard(
                  icon: Icons.search,
                  title: 'Add an Unknown Caregiver',
                  subtitle: 'Search and connect with caregivers by location',
                  onTap: () {
                    // Build a map with name and city for the next screen
                    final patientArg = Map<String, dynamic>.from(
                      selectedPatient!,
                    );
                    patientArg['name'] = selectedPatient?['name'] ?? '';
                    // Optionally, ensure city is present
                    if (patientArg['city'] == null &&
                        selectedPatient?['city'] != null) {
                      patientArg['city'] = selectedPatient?['city'];
                    }
                    Navigator.pushNamed(
                      context,
                      AppRoutes.guardianAddUnknownCaregiver,
                      arguments: patientArg,
                    );
                  },
                ),
                _buildCaregiverTypeCard(
                  icon: Icons.contacts,
                  title: 'Add a Known Caregiver',
                  subtitle: 'Add someone you already know as a caregiver',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.guardianAddKnownCaregiver,
                      arguments: selectedPatient,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/caregiver_service.dart';
import '../../services/guardian_service.dart';
import '../../constants/color_constants.dart';
import '../../utils/name_utils.dart';

class GuardianAddUnknownCaregiverScreen extends StatefulWidget {
  @override
  _GuardianAddUnknownCaregiverScreenState createState() =>
      _GuardianAddUnknownCaregiverScreenState();
}

class _GuardianAddUnknownCaregiverScreenState
    extends State<GuardianAddUnknownCaregiverScreen> {
  Map<String, dynamic>? selectedPatient;
  String? selectedCity;
  List<Map<String, dynamic>> allCaregivers = [];
  List<Map<String, dynamic>> filteredCaregivers = [];
  bool isLoading = true;
  String? errorMessage;
  Map<int, DateTime> recentlyRejectedCaregivers =
      {}; // caregiverId -> rejection time

  // Sri Lankan cities
  final List<String> sriLankanCities = [
    'All Cities',
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Negombo',
    'Anuradhapura',
    'Polonnaruwa',
    'Kurunegala',
  ];

  int? _getPatientId(Map<String, dynamic>? patient) {
    if (patient == null) return null;
    return patient['id'] ?? patient['patientId'] ?? patient['patient_id'];
  }

  @override
  void initState() {
    super.initState();
    selectedCity = 'All Cities';

    // Get the selected patient from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          selectedPatient = args;
        });
        // Now fetch caregivers with the correct patient
        _fetchCaregivers();
      }
    });
  }

  Future<void> _fetchCaregivers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final patientId = _getPatientId(selectedPatient);
      if (patientId != null) {
        print('Fetching filtered caregivers for patientId: $patientId');
        final caregivers =
            await CaregiverService.getAvailableCaregiversForPatient(patientId);
        setState(() {
          allCaregivers = caregivers;
          filteredCaregivers = caregivers;
          isLoading = false;
        });
      } else {
        print('No patient selected! Not fetching caregivers.');
        setState(() {
          isLoading = false;
          errorMessage = 'No patient selected. Please select a patient first.';
          allCaregivers = [];
          filteredCaregivers = [];
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to fetch caregivers: ' + e.toString();
      });
    }
  }

  void _filterCaregivers(String? city) {
    setState(() {
      selectedCity = city;
      if (city == null || city.isEmpty || city == 'All Cities') {
        filteredCaregivers = allCaregivers;
      } else {
        filteredCaregivers = allCaregivers
            .where((caregiver) => (caregiver['city'] ?? '') == city)
            .toList();
      }
      // After filtering by city, filter out recently rejected caregivers
      final now = DateTime.now();
      filteredCaregivers = filteredCaregivers.where((c) {
        final id = c['id'];
        if (recentlyRejectedCaregivers.containsKey(id)) {
          final rejectedAt = recentlyRejectedCaregivers[id]!;
          if (now.difference(rejectedAt).inDays < 2) {
            return false; // Hide for 2 days
          }
        }
        return true;
      }).toList();
    });
  }

  void _handleCaregiverRejected(int caregiverId) {
    recentlyRejectedCaregivers[caregiverId] = DateTime.now();
    setState(() {
      // Remove from filteredCaregivers immediately
      filteredCaregivers.removeWhere((c) => c['id'] == caregiverId);
    });
  }

  void _showConnectionRequestDialog(Map<String, dynamic> caregiver) async {
    // Fetch guardian info if possible
    Map<String, dynamic>? guardianInfo;
    int? guardianId =
        selectedPatient?['guardianId'] ?? selectedPatient?['guardian_id'];
    if (guardianId != null) {
      guardianInfo = await GuardianService.getGuardianDetailsById(guardianId);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Send Connection Request',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Caregiver Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.info,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    'Name:',
                    NameUtils.formatPatientName(caregiver),
                  ),
                  _buildInfoRow(
                    'Location:',
                    caregiver['city'] ?? caregiver['location'] ?? '',
                  ),
                  _buildInfoRow('Experience:', caregiver['experience'] ?? ''),
                  _buildInfoRow(
                    'Skills:',
                    (caregiver['skills'] is List
                        ? (caregiver['skills'] as List).join(', ')
                        : (caregiver['skills'] ?? '')),
                  ),
                  _buildInfoRow(
                    'Qualifications:',
                    caregiver['qualifications'] ?? '',
                  ),
                  _buildInfoRow(
                    'Phone:',
                    caregiver['phoneNumber'] ?? caregiver['phone'] ?? '',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Guardian Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.info,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    'Name:',
                    NameUtils.capitalizeName(
                      selectedPatient?['guardianName'] ?? 'N/A',
                    ),
                  ),
                  _buildInfoRow(
                    'Email:',
                    selectedPatient?['guardianEmail'] ?? 'N/A',
                  ),
                  _buildInfoRow(
                    'Phone:',
                    selectedPatient?['guardianPhone'] ?? 'N/A',
                  ),
                  _buildInfoRow(
                    'City:',
                    selectedPatient?['guardianCity'] ?? 'N/A',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Patient Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.info,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    'Name:',
                    NameUtils.formatPatientName(selectedPatient ?? {}),
                  ),
                  _buildInfoRow(
                    'Relationship:',
                    selectedPatient?['relationship'] ?? 'N/A',
                  ),
                  _buildInfoRow(
                    'Dementia Type:',
                    selectedPatient?['dementiaType'] ?? 'N/A',
                  ),
                  _buildInfoRow(
                    'Dementia Stage:',
                    selectedPatient?['dementiaStage'] ?? 'N/A',
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _sendConnectionRequest(caregiver);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          foregroundColor: AppColors.info,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Send',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _sendConnectionRequest(Map<String, dynamic> caregiver) async {
    final int? guardianId =
        selectedPatient?['guardianId'] ?? selectedPatient?['guardian_id'];
    final int? patientId =
        selectedPatient?['patientId'] ?? selectedPatient?['patient_id'];
    final int? caregiverId =
        caregiver['id'] ??
        caregiver['caregiverId'] ??
        caregiver['caregiver_id'];

    if (guardianId == null || patientId == null || caregiverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Missing guardian, patient, or caregiver ID.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await GuardianService.sendCaregiverConnectionRequest(
      guardianId: guardianId,
      patientId: patientId,
      caregiverId: caregiverId,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection request sent successfully!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.guardianAddCaregiver,
          arguments: selectedPatient,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send connection request.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _viewProfile(Map<String, dynamic> caregiver) {
    // Auto-generate description if empty
    String description = caregiver['description'] ?? '';
    if (description.trim().isEmpty) {
      final exp = caregiver['experience'] ?? '';
      final skillsList = caregiver['skills'] ?? [];
      final skills = skillsList is List
          ? skillsList.join(', ')
          : skillsList.toString();
      final qual = caregiver['qualifications'] ?? '';
      description = 'Experienced caregiver';
      if (exp.isNotEmpty) description += ' with $exp';
      if (qual.isNotEmpty) description += ', holding $qual';
      if (skills.isNotEmpty) description += ', skilled in $skills';
      description += '.';
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(24),
              color: Color(0xFFF7F4FB),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Caregiver Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      NameUtils.formatPatientName(caregiver),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B3F99),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Info rows with icons
                  _buildProfileInfoRow(
                    Icons.location_on,
                    'Location:',
                    caregiver['city'] ?? '',
                  ),
                  _buildProfileInfoRow(
                    Icons.work,
                    'Experience:',
                    caregiver['experience'] ?? '',
                  ),
                  _buildProfileInfoRow(
                    Icons.star,
                    'Skills:',
                    (caregiver['skills'] is List
                        ? (caregiver['skills'] as List).join(', ')
                        : (caregiver['skills'] ?? '')),
                  ),
                  _buildProfileInfoRow(
                    Icons.school,
                    'Qualifications:',
                    caregiver['qualifications'] ?? '',
                  ),
                  _buildProfileInfoRow(
                    Icons.phone,
                    'Phone:',
                    caregiver['phoneNumber'] ?? caregiver['phone'] ?? '',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  // Removed action buttons; only X closes the dialog
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper for profile info row with icon
  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaregiverCard(Map<String, dynamic> caregiver) {
    final String fullName = NameUtils.formatPatientName(caregiver);
    final String city = caregiver['city'] ?? '';
    final String qualifications = caregiver['qualifications'] ?? '';
    final String experience = caregiver['experience'] ?? '';
    final List<dynamic> skillsList = caregiver['skills'] ?? [];
    final String skills = skillsList.isNotEmpty ? skillsList.join(', ') : '';
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primaryLight.withOpacity(0.3),
              child: Icon(Icons.person, size: 30, color: AppColors.info),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                    ),
                  ),
                  if (city.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                        SizedBox(width: 4),
                        Text(
                          city,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (skills.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Skills: $skills',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (experience.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.work,
                          size: 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Experience: $experience',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => _viewProfile(caregiver),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: AppColors.info,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View Profile',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _showConnectionRequestDialog(caregiver),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: AppColors.info,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Send Request',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Debug print to verify selectedPatient
    print(
      'Selected patient in Add Unknown Caregiver: ' +
          selectedPatient.toString(),
    );
    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        title: Text(
          'Add Unknown Caregiver',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Information Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryLight.withOpacity(0.3),
                      child: Icon(
                        Icons.person,
                        size: 24,
                        color: AppColors.info,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: selectedPatient != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  NameUtils.capitalizeName(selectedPatient!['name'] ?? 'Unknown'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.info,
                                  ),
                                ),
                                if ((selectedPatient!['city'] ?? '')
                                    .toString()
                                    .isNotEmpty)
                                  Text(
                                    selectedPatient!['city'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            )
                          : Text(
                              NameUtils.capitalizeName(selectedPatient?['name'] ?? ''),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[900],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Filter by Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.info,
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedCity,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                  hintText: 'Select City',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                items: sriLankanCities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: _filterCaregivers,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Available Caregivers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                    ),
                  ),
                ),
                Text(
                  '${filteredCaregivers.length} found',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  try {
                    if (isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (errorMessage != null) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      );
                    } else if (filteredCaregivers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppColors.onSurfaceVariant,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No caregivers found',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try selecting a different location',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: filteredCaregivers.length,
                        itemBuilder: (context, index) {
                          try {
                            return _buildCaregiverCard(
                              filteredCaregivers[index],
                            );
                          } catch (e) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(Icons.error, color: Colors.red),
                                  title: Text(
                                    'Error displaying caregiver',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    e.toString(),
                                    style: TextStyle(fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                  } catch (e) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Unexpected error: $e',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
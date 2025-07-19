import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';

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
    // _fetchPatients(); // Remove backend fetch
    // Use hardcoded patient data
    patients = [
      {
        'id': 1,
        'name': 'John Doe',
        'label': 'Patient 1',
        'avatar': 'assets/images/patient1.jpg',
        'dementiaStage': 'Mild',
        'fName': 'John',
        'lName': 'Doe',
      },
      {
        'id': 2,
        'name': 'Jane Smith',
        'label': 'Patient 2',
        'avatar': 'assets/images/patient2.jpg',
        'dementiaStage': 'Moderate',
        'fName': 'Jane',
        'lName': 'Smith',
      },
    ];
    isLoading = false;
  }

  Future<void> _fetchPatients() async {
    // Remove backend fetch, just set hardcoded data
    setState(() {
      patients = [
        {
          'id': 1,
          'name': 'John Doe',
          'label': 'Patient 1',
          'avatar': 'assets/images/patient1.jpg',
          'dementiaStage': 'Mild',
          'fName': 'John',
          'lName': 'Doe',
        },
        {
          'id': 2,
          'name': 'Jane Smith',
          'label': 'Patient 2',
          'avatar': 'assets/images/patient2.jpg',
          'dementiaStage': 'Moderate',
          'fName': 'Jane',
          'lName': 'Smith',
        },
      ];
      isLoading = false;
      errorMessage = null;
    });
  }

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    bool isSelected = selectedPatient?['id'] == patient['id'];

    // Debug print to see what data we have
    print('Building patient card: ${patient['name']} (ID: ${patient['id']})');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedPatient = patient;
          });
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: Color(0xFF2B3F99).withOpacity(0.2),
        highlightColor: Color(0xFF2B3F99).withOpacity(0.1),
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xFFA0C4FD).withOpacity(0.35)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Color(0xFF2B3F99)
                  : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
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
                child: Icon(Icons.person, color: Colors.grey[600], size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${patient['fName'] ?? patient['FName'] ?? patient['fname'] ?? ''} ${patient['lName'] ?? patient['LName'] ?? patient['lname'] ?? ''}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      patient['label'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    if (patient['dementiaStage'] != null) ...[
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFA0C4FD).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          patient['dementiaStage'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2B3F99),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: Color(0xFF2B3F99), size: 24),
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
                child: Icon(icon, size: 28, color: Color(0xFF2B3F99)),
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
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add Caregiver',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (selectedPatient == null)
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.black87),
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
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Choose which patient you want to add a caregiver for',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                    color: Color(0xFFA0C4FD).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFA0C4FD).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF2B3F99),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Selected patient: ',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      Text(
                        '${selectedPatient!['fName'] ?? selectedPatient!['FName'] ?? selectedPatient!['fname'] ?? ''} ${selectedPatient!['lName'] ?? selectedPatient!['LName'] ?? selectedPatient!['lname'] ?? ''}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B3F99),
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedPatient = null;
                          });
                        },
                        child: Text(
                          'Change',
                          style: TextStyle(
                            color: Color(0xFF2B3F99),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Select how you want to add a caregiver',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                _buildCaregiverTypeCard(
                  icon: Icons.search,
                  title: 'Add an Unknown Caregiver',
                  subtitle: 'Search and connect with caregivers by location',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.guardianAddUnknownCaregiver,
                      arguments: selectedPatient,
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

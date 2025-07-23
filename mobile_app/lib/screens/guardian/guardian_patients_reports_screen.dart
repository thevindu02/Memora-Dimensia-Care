import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';
import '../../services/guardian_service.dart'; // Add this import if not present

class GuardianPatientsReportsScreen extends StatefulWidget {
  @override
  _GuardianPatientsReportsScreenState createState() =>
      _GuardianPatientsReportsScreenState();
}

class _GuardianPatientsReportsScreenState
    extends State<GuardianPatientsReportsScreen> {
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
        final response = await PatientService.getPatientsWithRequestStatus(
          guardianId,
        );
        // Only use patient name and id, hardcode other fields
        final List<Map<String, dynamic>> loadedPatients = [];
        int labelCounter = 1;
        for (var p in response) {
          loadedPatients.add({
            'id': p['patientId'] ?? p['id'],
            'name': p['name'] ?? p['fName'] + ' ' + p['lName'],
            'label': 'Patient $labelCounter',
            'fName': (p['name'] ?? p['fName'] ?? '').split(' ').first,
            'lName': (p['name'] ?? p['lName'] ?? '').split(' ').length > 1
                ? (p['name'] ?? p['lName'] ?? '')
                      .split(' ')
                      .sublist(1)
                      .join(' ')
                : '',
            'totalReports': 10 + labelCounter, // hardcoded
            'lastReportDate': '2024-07-0${labelCounter}', // hardcoded
          });
          labelCounter++;
        }
        setState(() {
          patients = loadedPatients;
          isLoading = false;
          errorMessage = null;
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
        errorMessage = 'Failed to load patients: ' + e.toString();
      });
    }
  }

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.guardianSelectedPatientReports,
            arguments: patient,
          );
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withOpacity(0.2),
        highlightColor: Colors.blue.withOpacity(0.1),
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
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.grey[600], size: 35),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${patient['fName'] ?? patient['FName'] ?? patient['fname'] ?? ''} ${patient['lName'] ?? patient['LName'] ?? patient['lname'] ?? ''}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      patient['label'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFA0C4FD).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${patient['totalReports']} reports available',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2B3F99),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Last Report',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    patient['lastReportDate'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ],
              ),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        // Removed reload icon
        title: Text(
          'Patient Reports',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPatients,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              // Make Daily Reports a plain info section, not a card
              Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFA0C4FD).withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.assessment,
                        size: 24,
                        color: Color(0xFF2B3F99),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Reports',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Select a patient to view their daily reports',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Patients list
              Text(
                'Select Patient',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (errorMessage != null)
                Container(
                  padding: EdgeInsets.all(40),
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
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.red[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else if (patients.isEmpty)
                Container(
                  padding: EdgeInsets.all(40),
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
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Patients Added',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add patients to view their daily reports',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    for (var patient in patients) _buildPatientCard(patient),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

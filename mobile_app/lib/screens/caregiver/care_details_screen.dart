import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/caregiver_service.dart';
import '../../services/auth_service.dart'; // ADD THIS IMPORT

class CareDetailsScreen extends StatefulWidget {
  @override
  _CareDetailsScreenState createState() => _CareDetailsScreenState();
}

class _CareDetailsScreenState extends State<CareDetailsScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? patientData;
  bool _isLoading = true;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    int? patientId;
    if (args is int) {
      patientId = args;
    } else if (args is Map && args['patientId'] != null) {
      patientId = args['patientId'] as int;
    }
    if (patientId != null) {
      _fetchPatientDetails(patientId);
    } else {
      setState(() {
        _isLoading = false;
        _error = 'No patient selected.';
      });
    }
  }

  Future<void> _fetchPatientDetails(int patientId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await CaregiverService.getPatientDetails(patientId);
      setState(() {
        patientData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load patient details.';
        _isLoading = false;
      });
    }
  }

  String _capitalizeName(String name) {
    if (name.isEmpty) return name;
    return name
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
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
        title: Text(
          'Patient Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.caregiverNotification);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : patientData == null
          ? Center(child: Text('No data found.'))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFFA0C4FD),
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Color(0xFF2B3F99),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _capitalizeName(
                              patientData?['patientName'] ?? 'Unknown',
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Dementia Type',
                          patientData?['dementiaType'] ?? 'N/A',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          'Dementia Stage',
                          patientData?['dementiaStage'] ?? 'N/A',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Age',
                          patientData?['patientAge']?.toString() ?? 'N/A',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          'Relationship',
                          patientData?['relationship'] ?? 'N/A',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Guardian Contact Information
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guardian Contact Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildContactRow(
                          Icons.person,
                          _capitalizeName(
                            patientData?['guardianName'] ?? 'N/A',
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildContactRow(
                          Icons.phone,
                          patientData?['guardianPhone'] ?? 'N/A',
                        ),
                        SizedBox(height: 12),
                        _buildContactRow(
                          Icons.email,
                          patientData?['guardianEmail'] ?? 'N/A',
                        ),
                        SizedBox(height: 12),
                        _buildContactRow(
                          Icons.calendar_today,
                          'Accepted on ${(patientData?['acceptedDate'] != null && patientData!['acceptedDate'].toString().isNotEmpty) ? patientData!['acceptedDate'].toString().split('T')[0] : 'N/A'}',
                        ),
                        SizedBox(height: 12),
                        // Messages button: shown only when request accepted (acceptedDate present)
                        if (patientData != null && patientData!['acceptedDate'] != null && patientData!['acceptedDate'].toString().isNotEmpty)
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () async { // CHANGED: Made async
                                final guardianId = patientData?['guardianId'];
                                final guardianName = patientData?['guardianName'] ?? 'Guardian';
                                
                                if (guardianId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Guardian ID not available')),
                                  );
                                  return;
                                }
                                
                                // ADDED: Get current caregiver ID
                                final currentUserId = await AuthService.getCurrentCaregiverId();
                                
                                if (currentUserId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please login again')),
                                  );
                                  return;
                                }
                                
                                // CHANGED: Added currentUserId to arguments
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.chatConversation,
                                  arguments: {
                                    'id': guardianId,
                                    'name': guardianName,
                                    'currentUser': 'caregiver',
                                    'currentUserId': currentUserId.toString(), // ADDED THIS
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFA0C4FD),
                                foregroundColor: Color(0xFF2B3F99),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              ),
                              child: Text('Messages', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Additional Notes
                  Text(
                    'Additional Notes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      patientData?['notes'] ?? 'No additional notes.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}

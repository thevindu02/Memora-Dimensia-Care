import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/caregiver_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Patient {
  final int patientId;
  final String name;
  final int? age;
  final String? dementiaType;
  final String? dementiaStage;
  final String? relationship;
  final String? imageAsset;

  Patient({
    required this.patientId,
    required this.name,
    this.age,
    this.dementiaType,
    this.dementiaStage,
    this.relationship,
    this.imageAsset,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      patientId: map['patientId'] is int
          ? map['patientId']
          : int.tryParse(map['patientId'].toString()),
      name: map['patientName'] ?? 'Unknown',
      age: map['patientAge'],
      dementiaType: map['dementiaType'],
      dementiaStage: map['dementiaStage'],
      relationship: map['relationship'],
      imageAsset: null, // Optionally map to an asset if available
    );
  }
}

class PatientListScreen extends StatefulWidget {
  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientListScreen> {
  int _currentIndex = 1; // Patients tab selected
  TextEditingController _searchController = TextEditingController();
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
    _searchController.addListener(_filterPatients);
  }

  Future<void> _fetchPatients() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final caregiverId = await AuthService.getCurrentCaregiverId();
      if (caregiverId == null) {
        setState(() {
          _error = 'Unable to determine caregiver ID.';
          _isLoading = false;
        });
        return;
      }
      final data = await CaregiverService.getConnectedRequests(caregiverId);
      final patients = data
          .map<Patient>((item) => Patient.fromMap(item))
          .toList();
      setState(() {
        _allPatients = patients;
        _filteredPatients = patients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load patients.';
        _isLoading = false;
      });
    }
  }

  void _filterPatients() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        return patient.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Patients',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black87),
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
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search patients',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ),
                // Patients List
                Expanded(
                  child: _filteredPatients.isEmpty
                      ? Center(child: Text('No patients found.'))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredPatients.length,
                          itemBuilder: (context, index) {
                            final patient = _filteredPatients[index];
                            return _buildPatientCard(patient);
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, AppRoutes.caregiverDashboard);
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
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF2B3F99),
          unselectedItemColor: Color(0xFF2B3F99),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              activeIcon: Icon(Icons.people),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article_outlined),
              label: 'Articles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    final card = Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0x33C3B1E1), // Soft Lavender with 20% opacity
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Avatar (optional, fallback to icon)
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFA0C4FD), // Light Sky Blue
            child: Icon(
              Icons.person,
              size: 30,
              color: Color(0xFF2B3F99), // Calm Navy
            ),
          ),
          SizedBox(width: 16),
          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF390797), // Deep Purple
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    'Dementia Type:    ${patient.dementiaType != null && patient.dementiaType!.isNotEmpty ? patient.dementiaType : 'N/A'}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    'Dementia Stage:    ${patient.dementiaStage != null && patient.dementiaStage!.isNotEmpty ? patient.dementiaStage : 'N/A'}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          // Arrow Icon
          Icon(Icons.chevron_right, color: Color(0xFF2B3F99), size: 20),
        ],
      ),
    );

    return kIsWeb
        ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.patientRoutine,
                  arguments: patient.patientId,
                );
              },
              child: card,
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.patientRoutine,
                arguments: patient.patientId,
              );
            },
            child: card,
          );
  }
}

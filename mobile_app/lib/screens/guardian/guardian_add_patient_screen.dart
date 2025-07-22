import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart'; // Update the path as needed
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../../services/guardian_service.dart';

class GuardianAddPatientScreen extends StatefulWidget {
  @override
  _GuardianAddPatientScreenState createState() => _GuardianAddPatientScreenState();
}

class _GuardianAddPatientScreenState extends State<GuardianAddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _contactController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _diagnosisDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _relationshipController = TextEditingController();

  String? _selectedDementiaStage;
  String? _selectedDementiaType;
  DateTime? _selectedDOB;
  DateTime? _selectedDiagnosisDate;
  String? _selectedGender;
  bool _isLoading = false;

  final List<String> _dementiaStages = [
    'Mild',
    'Moderate',
    'Severe',
    'Very Severe',
  ];

  final Map<String, String> dementiaTypeMap = {
    "Alzheimer's Disease": 'ALZHEIMERS_DISEASE',
    "Vascular Dementia": 'VASCULAR_DEMENTIA',
    "Lewy Body Dementia": 'LEWY_BODY_DEMENTIA',
    "Frontotemporal Dementia": 'FRONTOTEMPORAL_DEMENTIA',
    "Mixed Dementia": 'MIXED_DEMENTIA',
    "Parkinson's Disease Dementia": 'PARKINSONS_DISEASE_DEMENTIA',
    "Creutzfeldt-Jakob Disease": 'CREUTZFELDT_JAKOB_DISEASE',
    "Normal Pressure Hydrocephalus": 'NORMAL_PRESSURE_HYDROCEPHALUS',
    "Huntington's Disease": 'HUNTINGTONS_DISEASE',
    "Wernicke-Korsakoff Syndrome": 'WERNICKE_KORSAKOFF_SYNDROME',
  };

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _contactController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _diagnosisDateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isDOB) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isDOB) {
          _selectedDOB = picked;
          _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
        } else {
          _selectedDiagnosisDate = picked;
          _diagnosisDateController.text = "${picked.day}/${picked.month}/${picked.year}";
        }
      });
    }
  }

  void _handleSavePatient() async {
    try {
      print('Save Patient button pressed');
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        print('Form validated, starting user creation');

        // 1. Create user
        final userResult = await UserService.addUser(
          FName: _firstNameController.text,
          LName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phoneNumber: _contactController.text,
          role: "PATIENT",
          status: "ACTIVE",
          birthdate: _selectedDOB != null
              ? "${_selectedDOB!.toIso8601String().split('T')[0]}"
              : "",
          profilePic: "", // Add profile pic logic if needed
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          gender: _selectedGender ?? "",
        );

        print('User creation result:  [1m [38;5;2m${userResult.success}, ${userResult.message} [0m');

        if (!userResult.success || userResult.userId == null) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create user: ${userResult.message}'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // 2. Create patient
        final dementiaStage = _selectedDementiaStage?.toUpperCase();
        final backendDementiaType = dementiaTypeMap[_selectedDementiaType];
        final dateOfDiagnosis = _selectedDiagnosisDate != null
            ? "${_selectedDiagnosisDate!.toIso8601String().split('T')[0]}"
            : null;

        // Get the current user id (from user table)
        final int? currentUserId = await AuthService.getCurrentUserId();
        print('Current User ID: $currentUserId');

        // Fetch the guardianId from the guardian table using the user id
        int? guardianId;
        if (currentUserId != null) {
          guardianId = await GuardianService.getGuardianIdByUserId(currentUserId);
        }
        print('Guardian Table ID: $guardianId');

        if (guardianId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You must be logged in as a guardian to add a patient.')), 
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final patientResult = await PatientService.addPatient(
          userId: userResult.userId!,
          dementiaStage: dementiaStage ?? "",
          dateOfDiagnosis: dateOfDiagnosis ?? "",
          dementiaType: backendDementiaType ?? "",
          guardianId: guardianId, // <-- Use guardian table id here
          relationship: _relationshipController.text.trim(),
        );

        print('Patient creation result: ${patientResult.success}, ${patientResult.message}');

        setState(() {
          _isLoading = false;
        });

        if (patientResult.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.guardianSubscriptionPlans,
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save patient: ${patientResult.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        print('Form validation failed');
      }
    } catch (e, stack) {
      print('Exception in _handleSavePatient: $e');
      print(stack);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _dementiaTypeDisplayNames = dementiaTypeMap.keys.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Patient',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _firstNameController,
                hintText: 'First Name',
              ),

              _buildTextField(
                controller: _lastNameController,
                hintText: 'Last Name',
              ),

              _buildTextField(
                controller: _dobController,
                hintText: 'Date of Birth',
                readOnly: true,
                onTap: () => _selectDate(context, true),
              ),

              _buildDropdownField(
                hintText: 'Gender',
                value: _selectedGender,
                items: _genders,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),

              _buildTextField(
                controller: _contactController,
                hintText: 'Contact Number',
              ),

              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
              ),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
              ),

              _buildTextField(
                controller: _relationshipController,
                hintText: 'Relationship with Patient',
              ),

              // Address section
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildTextField(
                      controller: _streetController,
                      hintText: 'Street',
                    ),
                    _buildTextField(
                      controller: _cityController,
                      hintText: 'City',
                    ),
                    _buildTextField(
                      controller: _stateController,
                      hintText: 'State',
                    ),
                  ],
                ),
              ),

              _buildDropdownField(
                hintText: 'Dementia Type',
                value: _selectedDementiaType,
                items: _dementiaTypeDisplayNames,
                onChanged: (value) {
                  setState(() {
                    _selectedDementiaType = value;
                  });
                },
              ),

              _buildDropdownField(
                hintText: 'Dementia Stage',
                value: _selectedDementiaStage,
                items: _dementiaStages,
                onChanged: (value) {
                  setState(() {
                    _selectedDementiaStage = value;
                  });
                },
              ),

              _buildTextField(
                controller: _diagnosisDateController,
                hintText: 'Date of diagnosis',
                readOnly: true,
                onTap: () => _selectDate(context, false),
              ),

              SizedBox(height: 24),

              // Save Patient button
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSavePatient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA0C4FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B3F99)),
                    strokeWidth: 2,
                  )
                      : Text(
                    'Save Patient',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2B3F99),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
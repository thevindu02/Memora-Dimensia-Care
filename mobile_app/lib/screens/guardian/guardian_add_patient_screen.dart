import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class GuardianAddPatientScreen extends StatefulWidget {
  @override
  _GuardianAddPatientScreenState createState() => _GuardianAddPatientScreenState();
}

class _GuardianAddPatientScreenState extends State<GuardianAddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _contactController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _dementiaTypeController = TextEditingController();
  final _diagnosisDateController = TextEditingController();

  String? _selectedDementiaStage;
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

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _patientNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _contactController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _dementiaTypeController.dispose();
    _diagnosisDateController.dispose();
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
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // TODO: Implement actual save patient logic here

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to dashboard
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.guardianDashboard,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _patientNameController,
                hintText: 'Patient Name',
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

              _buildTextField(
                controller: _dementiaTypeController,
                hintText: 'Dementia Type',
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
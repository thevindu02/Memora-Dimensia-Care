import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';

class GuardianEditPatientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? patient;

  const GuardianEditPatientDetailsScreen({Key? key, this.patient}) : super(key: key);

  @override
  _GuardianEditPatientDetailsScreenState createState() => _GuardianEditPatientDetailsScreenState();
}

class _GuardianEditPatientDetailsScreenState extends State<GuardianEditPatientDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _labelController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _contactNumberController;
  late TextEditingController _addressController;

  // Changed from TextEditingController to String for dropdown
  String? _selectedDementiaStage;

  // List of dementia stages for dropdown
  final List<String> _dementiaStages = ['Mild', 'Moderate', 'Severe', 'Very Severe'];

  List<dynamic> _patients = [];
  bool _isLoadingPatients = true;

  Map<String, dynamic> patientData = {};

  @override
  void initState() {
    super.initState();
    _fetchPatients();
    if (widget.patient != null) {
      patientData = widget.patient!;
    }

    _nameController = TextEditingController(
      text: '${patientData['fname'] ?? ''} ${patientData['lname'] ?? ''}'
    );
    _dateOfBirthController = TextEditingController(
      text: patientData['birthdate'] ?? ''
    );
    _contactNumberController = TextEditingController(
      text: patientData['phoneNumber'] ?? ''
    );
    _addressController = TextEditingController(
      text: '${patientData['street'] ?? ''}, ${patientData['city'] ?? ''}, ${patientData['state'] ?? ''}'
    );
    _selectedDementiaStage = patientData['dementiaStage'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _labelController.dispose();
    _dateOfBirthController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String initialValue,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          SizedBox(height: 8),
          Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus && controller.text == initialValue) {
                setState(() {
                  controller.text = '';
                });
              }
            },
            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: TextStyle(
                color: controller.text == initialValue ? Colors.grey : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: initialValue,
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue[700]!),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                fillColor: Colors.grey[50],
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[700]!),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              fillColor: Colors.grey[50],
              filled: true,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _savePatient() {
    if (_formKey.currentState!.validate()) {
      patientData = {
        ...patientData,
        'name': _nameController.text,
        'label': _labelController.text,
        'dateOfBirth': _dateOfBirthController.text,
        'contactNumber': _contactNumberController.text,
        'address': _addressController.text,
        'dementiaStage': _selectedDementiaStage,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient details updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.guardianDashboard,
            (route) => false,
      );
    }
  }

  void _resetToOriginal() {
    setState(() {
      _nameController.text = patientData['name'];
      _labelController.text = patientData['label'];
      _dateOfBirthController.text = patientData['dateOfBirth'];
      _contactNumberController.text = patientData['contactNumber'];
      _addressController.text = patientData['address'];
      _selectedDementiaStage = patientData['dementiaStage'];
    });
  }

  Future<void> _fetchPatients() async {
    final int? guardianId = await AuthService.getCurrentUserId();
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
                    '${patient['fName'] ?? ''} ${patient['lName'] ?? ''}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    patient['dementiaStage'] ?? '',
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

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? patient = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

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
          'Edit Patient Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.grey[600], size: 40),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Patient',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Update patient information',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              _buildTextField(
                label: 'Name',
                controller: _nameController,
                initialValue: _nameController.text,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              _buildTextField(
                label: 'Date of Birth',
                controller: _dateOfBirthController,
                initialValue: _dateOfBirthController.text,
                validator: (value) => value == null || value.isEmpty ? 'Please enter date of birth' : null,
              ),
              _buildTextField(
                label: 'Contact Number',
                controller: _contactNumberController,
                initialValue: _contactNumberController.text,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Please enter contact number' : null,
              ),
              _buildTextField(
                label: 'Address',
                controller: _addressController,
                initialValue: _addressController.text,
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please enter address' : null,
              ),
              _buildDropdownField(
                label: 'Dementia Stage',
                value: _selectedDementiaStage,
                items: _dementiaStages,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDementiaStage = newValue;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Please select a dementia stage' : null,
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _savePatient,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA0C4FD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2B3F99),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _resetToOriginal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0x59A0C4FD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2B3F99),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
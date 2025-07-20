import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../routes/app_routes.dart';

class EditProfileEdit extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileEdit> {
  int _currentIndex = 3; // Index of "Profile" tab

  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  
  // Text controllers for form fields
  final TextEditingController _nameController = TextEditingController(text: 'John Smith');
  final TextEditingController _emailController = TextEditingController(text: 'john.smith@example.com');
  final TextEditingController _birthdayController = TextEditingController(text: '2001-01-14');
  final TextEditingController _phoneController = TextEditingController(text: '+1 234 567 890');
  final TextEditingController _addressController = TextEditingController(text: 'No. 123, Galle Road');
  final TextEditingController _provinceController = TextEditingController(text: 'Western Province');
  final TextEditingController _cityController = TextEditingController(text: 'Colombo');
  final TextEditingController _experienceController = TextEditingController(text: 'Assisted with daily living activities\nAssisted with homework, mealtime, and bed');
  final TextEditingController _qualificationsController = TextEditingController(text: 'Experience in hospital, home, or private care');
  final TextEditingController _firstNameController = TextEditingController(text: 'John');
  final TextEditingController _lastNameController = TextEditingController(text: 'Smith');

  // Gender dropdown value
  String _selectedGender = 'Female';
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  final List<String> _skillOptions = [
    'Elder Care',
    'Child Care',
    'Disability Care',
    'Medical Care',
    'Housekeeping',
    'Cooking',
    'Transportation',
    'Companionship'
  ];
  // Default selected skills (cannot be unselected)
  final List<String> _defaultSelectedSkills = ['Elder Care', 'Child Care'];
  List<String> _selectedSkills = [];

  @override
  void initState() {
    super.initState();
    // Ensure default skills are always selected
    _selectedSkills = List<String>.from(_defaultSelectedSkills);
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _experienceController.dispose();
    _qualificationsController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.caregiverNotification);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Avatar Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Stack(
                  children: [
                    // Profile Image Container
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/caregiver.png'),
                    ),
                    // Edit icon - now opens gallery
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImageFromGallery,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(0xFF6B73FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Form Section
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('First Name', _firstNameController),
                    _buildTextField('Last Name', _lastNameController),
                    _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                    _buildTextField('Phone Number', _phoneController, keyboardType: TextInputType.phone),
                    Row(
                      children: [
                        Expanded(child: _buildGenderDropdown()),
                        SizedBox(width: 20),
                        Expanded(child: _buildTextField('Birthday', _birthdayController, readOnly: true, onTap: _selectDate)),
                      ],
                    ),
                    _buildSectionTitle('Address'),
                    _buildTextField('Street', _addressController),
                    _buildTextField('City', _cityController),
                    _buildTextField('State', _provinceController),
                    _buildSectionTitle('Experience'),
                    _buildTextField('Experience', _experienceController, maxLines: 3),
                    _buildSectionTitle('Qualifications'),
                    _buildTextField('Qualifications', _qualificationsController, maxLines: 2),
                    _buildSectionTitle('Skills'),
                    _buildSkillsField(),
                    
                    SizedBox(height: 30),
                    
                    // Action Buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9FC3FC),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD4E2F8),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) { // Patients tab
            // Navigate to detailed patients screen
            Navigator.pushNamed(context, AppRoutes.caregiverDashboard);
          }else if(index==1){
            Navigator.pushNamed(context, AppRoutes.caregiverPatients);
          }
          else if(index==2){
            Navigator.pushNamed(context, AppRoutes.viewArticleList);
          }
          else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2B3F99),
        unselectedItemColor: Color(0xFF2B3F99),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            maxLines: maxLines,
            onTap: onTap,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF6B73FF), width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: readOnly ? Icon(Icons.arrow_drop_down, color: Colors.grey[600]) : null,
            ),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF6B73FF), width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              dropdownColor: Colors.white,
              items: _genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10, bottom: 15),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Icon(
        icon,
        color: isActive ? Color(0xFF6B73FF) : Colors.grey[400],
        size: 24,
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2001, 1, 14),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF6B73FF),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Text('Password change functionality would be implemented here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: Color(0xFF6B73FF))),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Save changes logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFFD4E2F8),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildSkillsField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_outline, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Skills & Specializations',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _skillOptions.map((skill) {
              final isSelected = _selectedSkills.contains(skill);
              final isDefault = _defaultSelectedSkills.contains(skill);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isDefault) {
                      // Do nothing, cannot unselect default skills
                    } else if (isSelected) {
                      _selectedSkills.remove(skill);
                    } else {
                      _selectedSkills.add(skill);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFA0C4FD) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Color(0xFFA0C4FD) : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skill,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isDefault && isSelected)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.lock, size: 14, color: Colors.white),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_constants.dart';

class CaregiverRegisterPage extends StatefulWidget {
  const CaregiverRegisterPage({Key? key}) : super(key: key);

  @override
  State<CaregiverRegisterPage> createState() => _CaregiverRegisterPageState();
}

class _CaregiverRegisterPageState extends State<CaregiverRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _experienceController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _birthDateController = TextEditingController();

  DateTime? _selectedDate;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;
  String? _selectedExperience;
  String? _selectedGender;
  List<String> _selectedSkills = [];

  final List<String> _experienceOptions = [
    'Less than 1 year',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    'More than 10 years',
  ];

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  final List<String> _skillOptions = [
    'Elder Care',
    'Child Care',
    'Disability Care',
    'Medical Care',
    'Housekeeping',
    'Cooking',
    'Transportation',
    'Companionship',
  ];

  final List<String> _cityOptions = [
    'All Cities',
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Negombo',
    'Anuradhapura',
    'Polonnaruwa',
    'Kurunegala',
    'Ratnapura',
    'Batticaloa',
    'Trincomalee',
    'Matara',
    'Badulla',
    'Kalutara',
    'Gampaha',
    'Nuwara Eliya',
    'Chilaw',
    'Embilipitiya',
    'Wattala',
    'Moratuwa',
  ];
  String? _selectedCity;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _experienceController.dispose();
    _qualificationController.dispose();
    _birthDateController.dispose();
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Register as Caregiver',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Image Section
                _buildProfileImageSection(),
                const SizedBox(height: 30),

                // Personal Information Section
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 15),
                _buildPersonalInfoFields(),
                const SizedBox(height: 25),

                // Professional Information Section
                _buildSectionTitle('Professional Information'),
                const SizedBox(height: 15),
                _buildProfessionalInfoFields(),
                const SizedBox(height: 25),

                // Address Section
                _buildSectionTitle('Address Information'),
                const SizedBox(height: 15),
                _buildAddressFields(),
                const SizedBox(height: 25),

                // Security Section
                _buildSectionTitle('Security'),
                const SizedBox(height: 15),
                _buildSecurityFields(),
                const SizedBox(height: 40),

                // Register Button
                _buildRegisterButton(),
                const SizedBox(height: 20),

                // Login Link
                _buildLoginLink(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Handle image selection
              _showImageSelectionDialog();
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue[200]!, width: 2),
              ),
              child: Icon(Icons.person, size: 40, color: Colors.blue[400]),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Upload Profile Photo',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Tap to select photo',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFA0C4FD), // Match login/register button
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _firstNameController,
          label: 'First Name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: _lastNameController,
          label: 'Last Name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        _buildDateField(),
        const SizedBox(height: 15),
        _buildDropdownField(
          value: _selectedGender,
          label: 'Gender',
          icon: Icons.person_outline,
          items: _genderOptions,
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your gender';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (!RegExp(r'^\d{10}').hasMatch(value)) {
              return 'Phone number must be exactly 10 digits';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildProfessionalInfoFields() {
    return Column(
      children: [
        _buildDropdownField(
          value: _selectedExperience,
          label: 'Years of Experience',
          icon: Icons.work_outline,
          items: _experienceOptions,
          onChanged: (value) {
            setState(() {
              _selectedExperience = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your experience level';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: _qualificationController,
          label: 'Qualifications/Certifications',
          icon: Icons.school_outlined,
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your qualifications';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        _buildSkillsField(),
      ],
    );
  }

  Widget _buildAddressFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _streetController,
          label: 'Street',
          icon: Icons.route_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your street';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        // City dropdown
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCity,
            decoration: InputDecoration(
              labelText: 'City',
              prefixIcon: Icon(
                Icons.location_city_outlined,
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: _cityOptions.map((city) {
              return DropdownMenuItem<String>(value: city, child: Text(city));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCity = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your city';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: _stateController,
          label: 'State',
          icon: Icons.map_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your state';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSecurityFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock_outline,
          obscureText: !_passwordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
              return 'Password must contain at least one letter and one number';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          icon: Icons.lock_outline,
          obscureText: !_confirmPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _confirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final date = await showDatePicker(
          context: context,
          initialDate: today.subtract(
            const Duration(days: 6570),
          ), // 18 years ago
          firstDate: DateTime(1950),
          lastDate: today,
        );
        if (date != null) {
          setState(() {
            _selectedDate = date;
            _birthDateController.text =
                '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: AbsorbPointer(
          child: TextFormField(
            controller: _birthDateController,
            enabled: true,
            decoration: InputDecoration(
              labelText: 'Birth Date',
              prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
              hintText: 'Select your birth date',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              if (_selectedDate == null) {
                return 'Please select your birth date';
              }
              // Defensive: compare only date part
              final selected = DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
              );
              // Debug print for troubleshooting
              // ignore: avoid_print
              print(
                'Selected: ' +
                    selected.toIso8601String() +
                    ', Today: ' +
                    today.toIso8601String(),
              );
              if (selected.isAfter(today)) {
                return 'Birth date cannot be in the future';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a value';
              }
              return null;
            },
      ),
    );
  }

  Widget _buildSkillsField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(16),
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
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSkills.remove(skill);
                    } else {
                      _selectedSkills.add(skill);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[600] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA0C4FD), // Match login page
          foregroundColor: const Color(0xFF2B3F99), // Match login page
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Register as Caregiver',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to login page
            Navigator.pop(context);
          },
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showImageSelectionDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Profile Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      // Handle camera selection
                    },
                  ),
                  _buildImageOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      // Handle gallery selection
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blue[600]),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> registerCaregiver(Map<String, dynamic> data) async {
    final String url = '${ApiConstants.baseUrl}/api/caregivers/register';

    try {
      print('Sending POST to $url with data: $data');
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10)); // Add timeout

      print('Status: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Registration failed with status: ${response.statusCode}');
        print('Error response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSkills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one skill'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      print('Starting registration request...');
      // Build the data map
      Map<String, dynamic> data = {
        "fName": _firstNameController.text.trim(),
        "lName": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        "phoneNumber": _phoneController.text.trim(),
        "street": _streetController.text.trim(),
        "city": _selectedCity ?? "",
        "state": _stateController.text.trim(),
        // Format birthdate as yyyy-MM-dd for backend compatibility
        "birthdate": _selectedDate != null
            ? "${_selectedDate!.year.toString().padLeft(4, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
            : "",
        "profilePic": "", // Empty string instead of null for now
        "gender": _selectedGender ?? "Other", // Provide default if null
        "experience": _selectedExperience ?? "",
        "qualifications": _qualificationController.text.trim(),
        "skills": _selectedSkills.isNotEmpty ? _selectedSkills : [],
      };

      // Remove any null values
      data.removeWhere((key, value) => value == null);

      // Log the data being sent for debugging
      print('Registration data being sent:');
      data.forEach((key, value) {
        print('  $key: $value');
      });

      bool success = await registerCaregiver(data);
      print('Registration request completed. Success: $success');

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please verify your email.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

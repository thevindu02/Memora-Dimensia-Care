import 'package:flutter/material.dart';
import '../../services/auth/auth_service_factory.dart';
import '../../services/auth/base_auth_service.dart';
import '../../routes/app_routes.dart';
import '../../services/user_service.dart'; // Added import for UserService

class GuardianSignupScreen extends StatefulWidget {
  const GuardianSignupScreen({super.key});

  @override
  _GuardianSignupScreenState createState() => _GuardianSignupScreenState();
}

class _GuardianSignupScreenState extends State<GuardianSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthdateController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _selectedGender;
  DateTime? _selectedDate;

  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    bool isPassword = false,
    bool readOnly = false,
    VoidCallback? onTap,
    VoidCallback? toggleVisibility,
    Widget? suffixIcon,
  }) {
    IconData? prefixIcon;

    // Assign icons based on hint text
    if (hintText.contains('First name') || hintText.contains('Last name')) {
      prefixIcon = Icons.person_outline;
    } else if (hintText.contains('email')) {
      prefixIcon = Icons.email_outlined;
    } else if (hintText.contains('contact')) {
      prefixIcon = Icons.phone_outlined;
    } else if (hintText.contains('Street')) {
      prefixIcon = Icons.location_on_outlined;
    } else if (hintText.contains('City')) {
      prefixIcon = Icons.location_city_outlined;
    } else if (hintText.contains('State')) {
      prefixIcon = Icons.map_outlined;
    } else if (hintText.contains('password')) {
      prefixIcon = Icons.lock_outline;
    } else if (hintText.contains('birthdate')) {
      prefixIcon = Icons.cake_outlined;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
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
          prefixIcon: prefixIcon != null ? Icon(
            prefixIcon,
            color: Colors.grey[500],
          ) : null,
          suffixIcon: suffixIcon ?? (isPassword
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[500],
            ),
            onPressed: toggleVisibility,
          )
              : null),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (hintText.contains('email') && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          if (hintText.contains('Confirm password') && value != _passwordController.text) {
            return 'Passwords do not match';
          }
          if (hintText.contains('password') && !hintText.contains('Confirm') && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          hintText: 'Select gender',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(
            Icons.wc_outlined,
            color: Colors.grey[500],
          ),
        ),
        items: _genderOptions.map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a gender';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF2B3F99),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _handleRegister() async {
    try {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

        // Call UserService.addUser to register guardian
        final userResult = await UserService.addUser(
          FName: _firstNameController.text.trim(),
          LName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _contactController.text.trim(),
          role: "GUARDIAN",
          status: "ACTIVE",
          birthdate: _selectedDate != null
              ? _selectedDate!.toIso8601String().split('T')[0]
              : "",
          profilePic: "",
          street: _streetController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          gender: _selectedGender ?? "",
        );

      setState(() {
        _isLoading = false;
      });

        if (userResult.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful! Redirecting to login...'),
          backgroundColor: Colors.green,
        ),
      );
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed:  [1m [38;5;1m [0m${userResult.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),

                // Page heading
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 30),

                // Name section - First and Last name side by side
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _firstNameController,
                        hintText: 'First name',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _lastNameController,
                        hintText: 'Last name',
                      ),
                    ),
                  ],
                ),

                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                ),

                _buildTextField(
                  controller: _contactController,
                  hintText: 'Enter your contact number',
                ),

                // Birthdate and Gender section
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _birthdateController,
                        hintText: 'Select birthdate',
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildGenderDropdown(),
                    ),
                  ],
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
                  controller: _passwordController,
                  hintText: 'Enter password',
                  obscureText: !_isPasswordVisible,
                  isPassword: true,
                  toggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),

                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: !_isConfirmPasswordVisible,
                  isPassword: true,
                  toggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),

                SizedBox(height: 20),

                // Register button
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA0C4FD), // Updated background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    )
                        : Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B3F99), // Updated text color
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Terms and conditions
                Text(
                  'By registering, you agree to our Terms and Conditions.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../services/auth/auth_service_factory.dart';
import '../../services/auth/base_auth_service.dart';
import '../../routes/app_routes.dart';

class GuardianSignupScreen extends StatefulWidget {
  const GuardianSignupScreen({super.key});

  @override
  _GuardianSignupScreenState createState() => _GuardianSignupScreenState();
}

class _GuardianSignupScreenState extends State<GuardianSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'phoneNumber': TextEditingController(),
  };

  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      BaseAuthService authService = AuthServiceFactory.getAuthService('guardian');

      Map<String, dynamic> userData = {};
      _controllers.forEach((key, controller) {
        userData[key] = controller.text.trim();
      });

      Map<String, dynamic> result = await authService.signup(userData);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Guardian account created successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.guardianDashboard);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Signup failed'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Guardian Registration')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('firstName', 'First Name'),
                _buildTextField('lastName', 'Last Name'),
                _buildEmailField(),
                _buildPasswordField(),
                _buildTextField('phoneNumber', 'Phone Number'),
                SizedBox(height: 24),
                _buildSignupButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(labelText: label),
        validator: (value) => value?.trim().isEmpty ?? true ? '$label is required' : null,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _controllers['email'],
        decoration: InputDecoration(labelText: 'Email'),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value?.trim().isEmpty ?? true) return 'Email is required';
          if (!BaseAuthService.isValidEmail(value!)) return 'Please enter a valid email';
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _controllers['password'],
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Password is required';
          if (!BaseAuthService.isValidPassword(value!)) return 'Password must be at least 6 characters';
          return null;
        },
      ),
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignup,
        child: _isLoading ? CircularProgressIndicator() : Text('Create Guardian Account'),
      ),
    );
  }
}
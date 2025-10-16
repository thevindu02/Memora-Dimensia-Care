import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class PatientEmailVerificationScreen extends StatefulWidget {
  final String? email; // Pre-filled email from guardian request
  
  const PatientEmailVerificationScreen({Key? key, this.email}) : super(key: key);

  @override
  State<PatientEmailVerificationScreen> createState() => _PatientEmailVerificationScreenState();
}

class _PatientEmailVerificationScreenState extends State<PatientEmailVerificationScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    // Pre-fill email if passed from guardian request
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  Future<void> _sendVerificationCode() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final result = await AuthService.sendPatientVerificationCode(email);
      
      if (result.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate to verify code screen
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.patientVerifyCode,
            arguments: {'email': email},
          );
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result.message;
        });
        
        if (result.locked == true) {
          _showErrorDialog(
            'Account Locked',
            'Too many failed attempts. Please try again in ${result.minutesRemaining} minutes.',
          );
        } else if (result.cooldown == true) {
          _showErrorDialog(
            'Please Wait',
            'Please wait ${result.secondsRemaining} seconds before requesting a new code.',
          );
        } else {
          _showErrorDialog('Error', result.message);
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      _showErrorDialog('Error', 'Failed to send verification code: $e');
    }
  }
  
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // ...existing UI code...
    // Add the email input field and send button
    // Call _sendVerificationCode() when button is pressed
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.email, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Enter Your Email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We\'ll send you a verification code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _sendVerificationCode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Send Verification Code', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
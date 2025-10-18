import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class PatientVerifyCodeScreen extends StatefulWidget {
  final String? email;
  
  const PatientVerifyCodeScreen({Key? key, this.email}) : super(key: key);

  @override
  State<PatientVerifyCodeScreen> createState() => _PatientVerifyCodeScreenState();
}

class _PatientVerifyCodeScreenState extends State<PatientVerifyCodeScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;
  String? _errorMessage;
  String? _email;
  
  @override
  void initState() {
    super.initState();
    _email = widget.email;
  }
  
  @override
  void dispose() {
    _codeController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }
  
  void _startResendCooldown(int seconds) {
    setState(() {
      _resendCooldown = seconds;
    });
    
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCooldown > 0) {
          _resendCooldown--;
        } else {
          timer.cancel();
        }
      });
    });
  }
  
  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    
    if (code.isEmpty || code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the 6-digit verification code';
      });
      return;
    }
    
    if (_email == null) {
      setState(() {
        _errorMessage = 'Email not found. Please go back and try again.';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final result = await AuthService.authenticatePatientWithCode(_email!, code);
      
      if (result.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful! ✓'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Navigate to patient dashboard
          Navigator.of(context).pushReplacementNamed(
            result.dashboardRoute ?? AppRoutes.patientMain,
          );
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result.message;
        });
        
        if (result.message.contains('expired')) {
          _showErrorDialog(
            'Code Expired',
            'Your verification code has expired. Please request a new code.',
          );
        } else {
          _showErrorDialog('Invalid Code', result.message);
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      _showErrorDialog('Error', 'Verification failed: $e');
    }
  }
  
  Future<void> _resendCode() async {
    if (_resendCooldown > 0) {
      _showErrorDialog('Please Wait', 'Please wait $_resendCooldown seconds before resending');
      return;
    }
    
    if (_email == null) {
      _showErrorDialog('Error', 'Email not found. Please go back and try again.');
      return;
    }
    
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });
    
    try {
      final result = await AuthService.sendPatientVerificationCode(_email!);
      
      setState(() {
        _isResending = false;
      });
      
      if (result.success) {
        _startResendCooldown(60);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _showErrorDialog('Error', result.message);
        
        if (result.cooldown == true) {
          _startResendCooldown(result.secondsRemaining ?? 60);
        }
      }
    } catch (e) {
      setState(() {
        _isResending = false;
      });
      _showErrorDialog('Error', 'Failed to resend code: $e');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Verification Code'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.verified_user, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Enter Verification Code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Code sent to $_email',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Verification Code',
                hintText: '000000',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
                  : const Text('Verify & Login', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
            
            TextButton.icon(
              onPressed: _resendCooldown > 0 || _isResending ? null : _resendCode,
              icon: const Icon(Icons.refresh),
              label: Text(
                _resendCooldown > 0 ? 'Resend Code ($_resendCooldown s)' : 'Resend Code',
              ),
            ),
            
            const SizedBox(height: 8),
            const Text(
              'Code expires in 15 minutes',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
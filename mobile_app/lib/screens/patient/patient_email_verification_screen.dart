import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class PatientEmailVerificationScreen extends StatefulWidget {
  const PatientEmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PatientEmailVerificationScreen> createState() => _PatientEmailVerificationScreenState();
}

class _PatientEmailVerificationScreenState extends State<PatientEmailVerificationScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with placeholder email
    _emailController.text = 'patient@email.com';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendVerificationCode() {
    // Navigate to the next screen (replace with your actual route)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VerificationCodeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Welcome Back Title
            const Center(
              child: Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Center(
              child: Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 60),
            // Email Address Label
            const Text(
              'Email Address',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            // Email Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  hintText: 'Enter your email address',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Send Verification Code Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                //onPressed: _sendVerificationCode,
                onPressed: () {
                  // Handle accept connection
                  //_handleAcceptConnection(context);
                  Navigator.of(context).pushNamed(AppRoutes.patientVerifyCode);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA0C4FD),
                  foregroundColor: const Color(0xFF2B3F99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Send Verification Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B3F99),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Description Text
            const Center(
              child: Text(
                "We'll send a code to verify your identity",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for the next screen - replace with your actual verification code screen
class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Code'),
      ),
      body: const Center(
        child: Text(
          'Verification Code Screen\n(Replace with your actual implementation)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
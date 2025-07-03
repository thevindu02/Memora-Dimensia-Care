import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class PatientGuardianRequestScreen extends StatelessWidget {
  final String guardianName;

  const PatientGuardianRequestScreen({
    Key? key,
    this.guardianName = 'Sarah Johnson',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              Image.asset(
                'assets/images/light_logo.png', // Replace with your actual logo path
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              // Connection request text
              const Text(
                'Your guardian has sent you a connection request',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),

              const SizedBox(height: 32),

              // Guardian info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0x80A0C4FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      guardianName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B3F99),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'wants to connect as your guardian',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2B3F99),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // Accept Connection button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle accept connection
                    //_handleAcceptConnection(context);
                    Navigator.of(context).pushNamed(AppRoutes.patientEmailVerification);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA0C4FD),
                    foregroundColor: Color(0xFF2B3F99),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Accept Connection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Learn More button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () {
                    // Handle learn more
                    _handleLearnMore(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0x60A0C4FD),
                    foregroundColor: const Color(0xFF2B3F99),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Learn More',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAcceptConnection(BuildContext context) {
    // Implement your accept connection logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connection accepted!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleLearnMore(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Learn More'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: About Sarah Johnson
                Text(
                  'About Sarah Johnson',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Guardian connection request',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blueGrey),
                ),
                SizedBox(height: 16),

                // Section: Who is Sarah Johnson?
                Text(
                  '👤 Who is Sarah Johnson?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 6),
                Text(
                  'Sarah is your daughter and will be your guardian. She will oversee your care and select caregivers to help you with daily activities.',
                ),
                SizedBox(height: 16),

                // Section: What Sarah Will Do
                Text(
                  '✅ What Sarah Will Do',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 6),
                BulletList([
                  'Choose qualified caregivers for you',
                  'Monitor your overall care and safety',
                  'Receive important health updates',
                  'Make care decisions with your input',
                ]),
                SizedBox(height: 16),

                // Section: About Caregivers
                Text(
                  '👩‍⚕️ About Caregivers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 6),
                Text(
                  'Sarah will assign trained caregivers who will help you daily with medications, tasks, and appointments. You\'ll interact with these caregivers through the app.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;
  const BulletList(this.items, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(item)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

// Usage: Navigate to this screen using:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => const PatientGuardianRequestScreen(
//       guardianName: 'Sarah Johnson',
//     ),
//   ),
// );
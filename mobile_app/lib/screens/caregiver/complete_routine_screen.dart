import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class ScheduleRoutineDialog extends StatefulWidget {
  final String patientName;
  const ScheduleRoutineDialog({Key? key, required this.patientName})
    : super(key: key);

  @override
  State<ScheduleRoutineDialog> createState() => _ScheduleRoutineDialogState();
}

class _ScheduleRoutineDialogState extends State<ScheduleRoutineDialog> {
  int currentIndex = 1; // Set to 1 since we're on Patients tab

  @override
  Widget build(BuildContext context) {
    // Retrieve patientName from arguments if not passed directly
    final args = ModalRoute.of(context)?.settings.arguments;
    String patientName = widget.patientName;
    if (args is Map && args['patientName'] != null) {
      patientName = args['patientName'];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Schedule Routine',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Change to left align
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black, weight: 900),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.caregiverNotification);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Main scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight -
                            80, // Adjusted for BottomNavigationBar
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Patient Info Section
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xFFA0C4FD),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFF2B3F99),
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patientName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Removed Patient ID line
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Complete Daily Routine Section
                          Text(
                            'Complete Daily Routine',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2B3F99),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Are you sure you want to mark today\'s routine as completed?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.3,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // This action will section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'This action will:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildBulletPoint(
                                  'Generate detailed completion report',
                                ),
                                const SizedBox(height: 6),
                                _buildBulletPoint(
                                  'Send reports to guardian and caregiver',
                                ),
                                const SizedBox(height: 6),
                                _buildBulletPoint(
                                  'Mark routine as finalized for today',
                                ),
                                const SizedBox(height: 6),
                                _buildBulletPoint('Cannot be undone'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text('Cancel'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.patientReport,
                                      arguments: {'patientName': patientName},
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFA0C4FD),
                                    foregroundColor: Color(0xFF2B3F99),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Yes, Complete Routine',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  void _completeRoutine(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily routine completed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}

// Usage example:
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Routine App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const ScheduleRoutineDialog(
        patientName: 'Sarah Johnson',
      ), // Pass patientName
      debugShowCheckedModeBanner: false,
    );
  }
}

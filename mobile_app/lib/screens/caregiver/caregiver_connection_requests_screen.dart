import 'package:flutter/material.dart';

class ConnectionRequest {
  final String guardianName;
  final String guardianEmail;
  final String patientName;
  final int patientAge;
  final String patientDiagnosis;
  final DateTime requestTime;

  ConnectionRequest({
    required this.guardianName,
    required this.guardianEmail,
    required this.patientName,
    required this.patientAge,
    required this.patientDiagnosis,
    required this.requestTime,
  });
}

class CaregiverConnectionRequestsScreen extends StatefulWidget {
  const CaregiverConnectionRequestsScreen({Key? key}) : super(key: key);

  @override
  State<CaregiverConnectionRequestsScreen> createState() =>
      _CaregiverConnectionRequestsScreenState();
}

class _CaregiverConnectionRequestsScreenState
    extends State<CaregiverConnectionRequestsScreen> {
  // Mock data
  List<ConnectionRequest> requests = [
    ConnectionRequest(
      guardianName: 'Alice Smith',
      guardianEmail: 'alice.smith@email.com',
      patientName: 'John Smith',
      patientAge: 72,
      patientDiagnosis: 'Alzheimer\'s Disease',
      requestTime: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    ConnectionRequest(
      guardianName: 'Bob Johnson',
      guardianEmail: 'bob.j@email.com',
      patientName: 'Mary Johnson',
      patientAge: 80,
      patientDiagnosis: 'Dementia',
      requestTime: DateTime.now().subtract(const Duration(hours: 30)),
    ),
    ConnectionRequest(
      guardianName: 'Carol Lee',
      guardianEmail: 'carol.lee@email.com',
      patientName: 'Peter Lee',
      patientAge: 68,
      patientDiagnosis: 'Mild Cognitive Impairment',
      requestTime: DateTime.now().subtract(const Duration(hours: 47)),
    ),
  ];

  void _handleAction(int index, bool accepted) {
    final name = requests[index].guardianName;
    setState(() {
      requests.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          accepted
              ? 'Accepted request from $name'
              : 'Rejected request from $name',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _timeLeft(DateTime requestTime) {
    final expiry = requestTime.add(const Duration(days: 2));
    final now = DateTime.now();
    if (now.isAfter(expiry)) return 'Expired';
    final diff = expiry.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (hours > 0) {
      return '$hours hour${hours == 1 ? '' : 's'} ${minutes > 0 ? '$minutes min' : ''} left';
    } else if (minutes > 0) {
      return '$minutes min left';
    } else {
      return 'Less than a minute left';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Connection Requests'),
        centerTitle: true,
      ),
      body: requests.isEmpty
          ? const Center(child: Text('No pending connection requests.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final req = requests[index];
                final expired = DateTime.now().isAfter(
                  req.requestTime.add(const Duration(days: 2)),
                );
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                req.guardianName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              expired ? Icons.timer_off : Icons.timer,
                              color: expired ? Colors.red : Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _timeLeft(req.requestTime),
                              style: TextStyle(
                                color: expired ? Colors.red : Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Guardian Email: ${req.guardianEmail}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Patient Name: ${req.patientName}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Patient Age: ${req.patientAge}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Diagnosis: ${req.patientDiagnosis}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: expired
                                  ? null
                                  : () => _handleAction(index, true),
                              icon: const Icon(Icons.check),
                              label: const Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey[300],
                                disabledForegroundColor: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: expired
                                  ? null
                                  : () => _handleAction(index, false),
                              icon: const Icon(Icons.close),
                              label: const Text('Reject'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey[300],
                                disabledForegroundColor: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

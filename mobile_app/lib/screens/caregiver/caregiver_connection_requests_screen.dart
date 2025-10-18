import 'package:flutter/material.dart';
import '../../services/caregiver_service.dart';
import '../../services/auth_service.dart';

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
  late Future<List<Map<String, dynamic>>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _fetchRequests();
  }

  Future<List<Map<String, dynamic>>> _fetchRequests() async {
    final caregiverId = await AuthService.getCurrentCaregiverId();
    if (caregiverId == null) throw Exception('Caregiver not logged in');
    return await CaregiverService.getPendingRequests(caregiverId);
  }

  void _handleAction(
    int index,
    bool accepted,
    List<Map<String, dynamic>> requests,
  ) async {
    final req = requests[index];
    final name = req['guardianName'] ?? '';
    final connectionId = req['connectionId'];
    try {
      if (accepted) {
        await CaregiverService.acceptConnectionRequest(connectionId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Accepted request from $name'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green, // Make background green for accepted
          ),
        );
      } else {
        await CaregiverService.rejectConnectionRequest(connectionId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rejected request from $name'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      setState(() {
        requests.removeAt(index);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to process request: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Capitalizes the first letter of each word in a name
  String _capitalizeName(String? name) {
    if (name == null || name.isEmpty) return '-';
    return name
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  String _timeLeft(DateTime requestTime) {
    final expiry = requestTime.add(const Duration(hours: 24));
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
        title: const Text(
          'Connection Requests',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load requests: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending connection requests.'));
          }
          final requests = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final req = requests[index];
              final DateTime requestTime =
                  DateTime.tryParse(req['connectedDateTime'] ?? '') ??
                  DateTime.now();
              final expired = DateTime.now().isAfter(
                requestTime.add(const Duration(hours: 24)),
              );
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Standardized friendly message
                      Text(
                        'Caregiver Connection Request',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_capitalizeName(req['guardianName'])} is inviting you to connect and provide care for their ${req['relationship']?.toString().isNotEmpty == true ? req['relationship']!.toLowerCase() : 'family member'}. Please review the details below and respond to the request.',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Guardian Info Section
                      Text(
                        'Guardian Information',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.person, color: Color(0xFF2B3F99)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _capitalizeName(req['guardianName']),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Email: ${req['guardianEmail'] ?? '-'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Phone: ${req['guardianPhone'] ?? '-'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    expired ? Icons.timer_off : Icons.timer,
                                    color: expired
                                        ? Colors.red
                                        : Color(0xFF2B3F99), // Calm Navy
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _timeLeft(requestTime),
                                    style: TextStyle(
                                      color: expired
                                          ? Colors.red
                                          : Color(0xFF2B3F99), // Calm Navy
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Patient Info Section
                      Text(
                        'Patient Information',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Name: ${_capitalizeName(req['patientName'])}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Age: ${req['patientAge'] ?? '-'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dementia Type: ${req['dementiaType'] ?? req['diagnosis'] ?? '-'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dementia Stage: ${req['dementiaStage'] ?? '-'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Accept/Reject buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: expired
                                ? null
                                : () => _handleAction(index, true, requests),
                            icon: const Icon(Icons.check),
                            label: const Text('Accept'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFA0C4FD,
                              ), // Pastel blue
                              foregroundColor: const Color(
                                0xFF2B3F99,
                              ), // Theme blue
                              disabledBackgroundColor: Colors.grey[300],
                              disabledForegroundColor: Colors.grey[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 10,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: expired
                                ? null
                                : () => _handleAction(index, false, requests),
                            icon: const Icon(Icons.close),
                            label: const Text('Reject'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFFFE5E5,
                              ), // Wandering alert background
                              foregroundColor: const Color(
                                0xFFFF5252,
                              ), // Red accent for text
                              disabledBackgroundColor: Colors.grey[300],
                              disabledForegroundColor: Colors.grey[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 10,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

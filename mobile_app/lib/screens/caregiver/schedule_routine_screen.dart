import 'package:flutter/material.dart';
import 'dart:ui';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';

// Remove the nested MaterialApp - this was causing the routing issue
class ScheduleRoutine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScheduleRoutineScreen();
  }
}

class ScheduleTask {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  bool isSelected;
  bool isCompleted;

  ScheduleTask({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.isCompleted = false,
  });
}

class ScheduleRoutineScreen extends StatefulWidget {
  @override
  _ScheduleRoutineScreenState createState() => _ScheduleRoutineScreenState();
}

class _ScheduleRoutineScreenState extends State<ScheduleRoutineScreen> {
  int _currentIndex = 1;
  List<ScheduleTask> tasks = [
    ScheduleTask(
      title: 'Breakfast Time',
      description: 'Morning meal',
      time: '8:00 AM',
      icon: Icons.restaurant,
      color: Colors.orange,
    ),
    ScheduleTask(
      title: 'Dinner Time',
      description: 'Evening meal',
      time: '6:00 PM',
      icon: Icons.dinner_dining,
      color: Colors.purple,
    ),
    ScheduleTask(
      title: 'Bathing Time',
      description: 'Personal hygiene',
      time: '7:00 PM',
      icon: Icons.bathtub,
      color: Colors.blue,
    ),
    ScheduleTask(
      title: 'Sleep Time',
      description: 'Night rest',
      time: '10:00 PM',
      icon: Icons.bed,
      color: Colors.indigo,
    ),
  ];

  String selectedTaskTitle = '';
  String? _patientName;
  bool _isPatientLoading = true;
  String? _patientError;
  int? _patientId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    int? patientId;
    if (args is int) {
      patientId = args;
    } else if (args is Map && args['patientId'] != null) {
      patientId = args['patientId'] as int;
    }
    if (patientId != null) {
      _patientId = patientId;
      _fetchPatientName(patientId);
    } else {
      setState(() {
        _isPatientLoading = false;
        _patientError = 'No patient selected.';
      });
    }
  }

  Future<void> _fetchPatientName(int patientId) async {
    setState(() {
      _isPatientLoading = true;
      _patientError = null;
    });
    final result = await PatientService.getPatient(patientId);
    if (result.success && result.data != null) {
      final data = result.data;
      setState(() {
        _patientName = ((data['fName'] ?? '') + ' ' + (data['lName'] ?? ''))
            .trim();
        _isPatientLoading = false;
      });
    } else {
      setState(() {
        _patientError = 'Failed to load patient info';
        _isPatientLoading = false;
      });
    }
  }

  void _selectTask(ScheduleTask task) {
    setState(() {
      // Deselect all tasks first
      for (var t in tasks) {
        t.isSelected = false;
      }

      // Select the clicked task
      task.isSelected = true;
      selectedTaskTitle = task.title;
    });
  }

  void _toggleTaskCompletion(ScheduleTask task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        task.isSelected = false; // Deselect when completed
      }
    });
  }

  void _showSkipDialog() {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              ),
            ),
            // Dialog
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Skip Task',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'You are about to skip: $selectedTaskTitle',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Reason for skipping:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: reasonController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Please provide a reason...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (reasonController.text.trim().isNotEmpty) {
                              // Handle skip logic here
                              Navigator.of(context).pop();
                              setState(() {
                                // Reset selection
                                for (var task in tasks) {
                                  task.isSelected = false;
                                }
                              });

                              // Show confirmation
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Task "$selectedTaskTitle" skipped',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            } else {
                              // Show error if no reason provided
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please provide a reason for skipping',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Skip Task',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Schedule Routine',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false, // Left align
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.caregiverNotification);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Patient Info
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (_patientId != null) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.careDetails,
                      arguments: _patientId,
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _isPatientLoading
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFA0C4FD),
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF2B3F99),
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 12),
                            CircularProgressIndicator(),
                          ],
                        )
                      : _patientError != null
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFA0C4FD),
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF2B3F99),
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              _patientError!,
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFA0C4FD),
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF2B3F99),
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                (_patientName != null &&
                                        _patientName!.trim().isNotEmpty &&
                                        _patientName != 'Unknown')
                                    ? _patientName!
                                    : 'Unknown',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF390797), // Deep Purple
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            // Daily Activities Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Activities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {
                      // Added debug print to help troubleshoot
                      print('Navigating to: ${AppRoutes.selectType}');
                      Navigator.pushNamed(context, AppRoutes.selectType);
                    },
                    backgroundColor: Color(0xFF9FC3FC),
                    child: Icon(Icons.add, color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Tasks List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _selectTask(task),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: task.isSelected
                              ? Colors.blue.shade50
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: task.isSelected
                                ? Colors.blue
                                : Colors.grey.shade200,
                            width: task.isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: task.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    task.icon,
                                    color: task.color,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        task.description,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      task.time,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () => _toggleTaskCompletion(task),
                                      child: task.isCompleted
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          : Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Skip button for selected task
                            if (task.isSelected && !task.isCompleted)
                              Container(
                                margin: EdgeInsets.only(top: 12),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    selectedTaskTitle = task.title;
                                    _showSkipDialog();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 1,
                                  ),
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Complete Daily Routine Button - Now positioned within scrollable content
            Container(
              margin: EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.completeRoutine,
                    arguments: {'patientName': _patientName ?? 'Unknown'},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9FC3FC),
                  foregroundColor: Color(0xFF2B3F99),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Complete Daily Routine',
                  style: TextStyle(
                    color: Color(0xFF2B3F99),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example of what your SelectRoutine page might look like
class SelectRoutinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Routine Type'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Routine Type',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('This is your SelectRoutine page'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

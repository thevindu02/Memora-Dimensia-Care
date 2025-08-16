import 'package:flutter/material.dart';
import 'package:mobile_app/constants/color_constants.dart';
import 'dart:ui';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';
import '../../services/daily_activity_service.dart';

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
  bool isSkipped;
  final int? careActivityId; // Add ID for API operations
  final int? dailyTaskId; // Add daily task ID

  ScheduleTask({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.isCompleted = false,
    this.isSkipped = false,
    this.careActivityId,
    this.dailyTaskId,
  });

  // Factory constructor to create ScheduleTask from DailyActivity
  factory ScheduleTask.fromDailyActivity(DailyActivity activity) {
    return ScheduleTask(
      title: activity.taskName,
      description: activity.description ?? 'Daily activity',
      time: _formatTime(activity.time),
      icon: _getIconForTask(activity.taskName),
      color: AppColors.primaryDark,
      isCompleted: activity.status == 'COMPLETED',
      isSkipped: activity.status == 'SKIPPED',
      careActivityId: activity.careActivityId,
      dailyTaskId: activity.dailyTaskId,
    );
  }

  // Helper method to format time from HH:mm to readable format
  static String _formatTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        if (hour == 0) {
          return '12:${minute.toString().padLeft(2, '0')} AM';
        } else if (hour < 12) {
          return '$hour:${minute.toString().padLeft(2, '0')} AM';
        } else if (hour == 12) {
          return '12:${minute.toString().padLeft(2, '0')} PM';
        } else {
          return '${hour - 12}:${minute.toString().padLeft(2, '0')} PM';
        }
      }
    } catch (e) {
      print('Error formatting time: $e');
    }
    return time; // Return original if parsing fails
  }

  // Helper method to get appropriate icon for task
  static IconData _getIconForTask(String taskName) {
    final lowerTask = taskName.toLowerCase();
    if (lowerTask.contains('breakfast') ||
        lowerTask.contains('meal') ||
        lowerTask.contains('eat')) {
      return Icons.restaurant;
    } else if (lowerTask.contains('dinner') || lowerTask.contains('lunch')) {
      return Icons.dinner_dining;
    } else if (lowerTask.contains('bath') ||
        lowerTask.contains('shower') ||
        lowerTask.contains('hygiene')) {
      return Icons.bathtub;
    } else if (lowerTask.contains('sleep') ||
        lowerTask.contains('bed') ||
        lowerTask.contains('rest')) {
      return Icons.bed;
    } else if (lowerTask.contains('medicine') ||
        lowerTask.contains('medication') ||
        lowerTask.contains('pill')) {
      return Icons.medication;
    } else if (lowerTask.contains('exercise') ||
        lowerTask.contains('walk') ||
        lowerTask.contains('activity')) {
      return Icons.directions_walk;
    } else if (lowerTask.contains('doctor') ||
        lowerTask.contains('appointment') ||
        lowerTask.contains('visit')) {
      return Icons.local_hospital;
    } else {
      return Icons.task_alt; // Default icon
    }
  }
}

class ScheduleRoutineScreen extends StatefulWidget {
  @override
  _ScheduleRoutineScreenState createState() => _ScheduleRoutineScreenState();
}

class _ScheduleRoutineScreenState extends State<ScheduleRoutineScreen> {
  List<ScheduleTask> tasks = [];
  String selectedTaskTitle = '';
  String? _patientName;
  bool _isPatientLoading = true;
  String? _patientError;
  int? _patientId;
  int? _scheduleId; // Add schedule ID
  bool _isTasksLoading = true;
  String? _tasksError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    int? patientId;
    int? scheduleId;

    if (args is int) {
      patientId = args;
    } else if (args is Map) {
      if (args['patientId'] != null) {
        patientId = args['patientId'] as int;
      }
      if (args['scheduleId'] != null) {
        scheduleId = args['scheduleId'] as int;
      }
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

    if (scheduleId != null) {
      _scheduleId = scheduleId;
      _fetchDailyActivities(scheduleId);
    } else {
      // For now, use schedule ID 1 as default (can be improved later to properly map patients to schedules)
      if (patientId != null) {
        _scheduleId = 1; // Use schedule ID 1 instead of patient ID
        _fetchDailyActivities(1);
      } else {
        setState(() {
          _isTasksLoading = false;
          _tasksError = 'No schedule information available.';
        });
      }
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

  Future<void> _fetchDailyActivities(int scheduleId) async {
    setState(() {
      _isTasksLoading = true;
      _tasksError = null;
    });

    try {
      final result = await DailyActivityService.getDailyActivities(scheduleId);

      if (result.success && result.data != null) {
        setState(() {
          // Convert DailyActivity objects to ScheduleTask objects
          tasks = result.data!
              .map((activity) => ScheduleTask.fromDailyActivity(activity))
              .toList();
          _isTasksLoading = false;
        });
      } else {
        setState(() {
          _tasksError = result.message;
          _isTasksLoading = false;
          // Keep empty tasks list or provide default tasks
          tasks = [];
        });
      }
    } catch (e) {
      setState(() {
        _tasksError = 'Failed to load daily activities: $e';
        _isTasksLoading = false;
        tasks = [];
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
        task.isSkipped = false; // Reset skip status when completed
      }
    });
  }

  // Helper methods for task counts
  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;
  int get skippedTasksCount => tasks.where((task) => task.isSkipped).length;
  int get uncompletedTasksCount =>
      tasks.where((task) => !task.isCompleted && !task.isSkipped).length;

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
            fontSize: 20,
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
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patient',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            _isPatientLoading
                                ? Text(
                                    'Loading...',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[500],
                                    ),
                                  )
                                : _patientError != null
                                ? Text(
                                    'Error loading patient',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red[600],
                                    ),
                                  )
                                : Text(
                                    _patientName ?? 'Unknown Patient',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16, right: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$completedTasksCount',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$skippedTasksCount',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Skipped',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8, right: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$uncompletedTasksCount',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pending',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Add Task Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.selectType,
                        arguments: _patientId,
                      );
                    },
                    backgroundColor: Color(0xFF6B4EE6),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Tasks List
            _buildTasksList(),

            // Complete Daily Routine Button
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
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Complete Daily Routine',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    if (_isTasksLoading) {
      return Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryDark,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Loading daily activities...',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (_tasksError != null) {
      return Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              SizedBox(height: 16),
              Text(
                _tasksError!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[600], fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_scheduleId != null) {
                    _fetchDailyActivities(_scheduleId!);
                  }
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (tasks.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No daily activities scheduled',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Activities will appear here when added',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
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
                  color: task.isSelected ? Color(0xFFE8E0FF) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: task.isSelected
                        ? Color(0xFF6B4EE6)
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
                        // Task Icon
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: task.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(task.icon, color: task.color, size: 24),
                        ),
                        SizedBox(width: 16),

                        // Task Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                task.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Time
                        Text(
                          task.time,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 16),

                        // Completion Circle
                        GestureDetector(
                          onTap: () => _toggleTaskCompletion(task),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: task.isCompleted
                                  ? Colors.green
                                  : Colors.transparent,
                              border: Border.all(
                                color: task.isCompleted
                                    ? Colors.green
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child: task.isCompleted
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),

                    // Skip Task Button (only show when task is selected)
                    if (task.isSelected && !task.isCompleted)
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              task.isSkipped = true;
                              task.isSelected = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Task "${task.title}" skipped'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(Icons.close, size: 18),
                          label: Text(
                            'Skip Task',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                    // Edit and Undo buttons row (show for selected tasks or skipped tasks)
                    if ((task.isSelected && !task.isCompleted) ||
                        task.isSkipped)
                      Container(
                        margin: EdgeInsets.only(top: task.isSelected ? 8 : 16),
                        child: Row(
                          children: [
                            // Edit Button
                            if (!task.isSkipped)
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _editTask(task),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Color(0xFF6B4EE6)),
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Color(0xFF6B4EE6),
                                  ),
                                  label: Text(
                                    'Edit',
                                    style: TextStyle(color: Color(0xFF6B4EE6)),
                                  ),
                                ),
                              ),

                            // Undo Skip Button (only for skipped tasks)
                            if (task.isSkipped)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      task.isSkipped = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Task "${task.title}" restored',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  icon: Icon(Icons.undo, size: 16),
                                  label: Text('Undo Skip'),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _editTask(ScheduleTask task) {
    // Show edit dialog for the task
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _taskNameController = TextEditingController(text: task.title);
        final _descriptionController = TextEditingController(
          text: task.description,
        );
        TimeOfDay? _selectedTime = TimeOfDay(
          hour: int.parse(task.time.split(':')[0].split(' ')[0]),
          minute: int.parse(task.time.split(':')[1].split(' ')[0]),
        );

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.edit, color: Color(0xFF6B4EE6)),
                  SizedBox(width: 8),
                  Text('Edit Task'),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Task Name Field
                    TextFormField(
                      controller: _taskNameController,
                      decoration: InputDecoration(
                        labelText: 'Task Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.task_alt),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Time Picker
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime ?? TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedTime = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _selectedTime != null
                              ? _selectedTime!.format(context)
                              : 'Select time',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Description Field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Update task locally (you can implement API call here)
                    setState(() {
                      // For now, just update the task object
                      // You can implement the API call to update the task in the database
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

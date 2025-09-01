import 'package:flutter/material.dart';
import 'package:mobile_app/constants/color_constants.dart';
import 'dart:ui';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';
import '../../services/daily_activity_service.dart';
import '../../services/task_service.dart' as TaskAPI;
import '../../services/medication_service.dart';
import '../../models/medication_reminder.dart';

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
  String? skipReason; // Add skip reason field
  final int? careActivityId; // Add ID for API operations
  final int? dailyTaskId; // Add daily task ID
  // Additional medication details
  final String? dosage;
  final String? mealTiming;
  final int? numberOfRounds;
  final String? medicationDescription;
  final String? taskType; // 'medication', 'daily_activity', 'game'

  ScheduleTask({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.isCompleted = false,
    this.isSkipped = false,
    this.skipReason,
    this.careActivityId,
    this.dailyTaskId,
    this.dosage,
    this.mealTiming,
    this.numberOfRounds,
    this.medicationDescription,
    this.taskType,
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
      taskType: 'daily_activity',
    );
  }

  // Factory constructor to create ScheduleTask from Task (game tasks)
  factory ScheduleTask.fromTask(TaskAPI.Task task) {
    return ScheduleTask(
      title: task.gameName,
      description: 'Game Activity: ${task.gameName}',
      time: _formatTime(task.time),
      icon: _getIconForGameTask(task.gameName),
      color: AppColors.primaryDark, // Use same color as daily activities
      isCompleted: task.status == 'COMPLETED',
      isSkipped: task.status == 'SKIPPED',
      careActivityId: task.careActivityId,
      dailyTaskId: task.taskId, // Use taskId for game tasks
      taskType: 'game',
    );
  }

  // Factory constructor to create ScheduleTask from MedicationReminder
  factory ScheduleTask.fromMedicationReminder(
    MedicationScheduleItem medication,
  ) {
    return ScheduleTask(
      title: medication.medicationName,
      description:
          'Medication: ${medication.dosage} - ${medication.mealTiming}',
      time: _formatTime(medication.time),
      icon: Icons.medication,
      color: AppColors.primaryDark,
      isCompleted: medication.status == 'TAKEN',
      isSkipped: medication.status == 'SKIPPED',
      careActivityId: medication.careActivityId,
      dailyTaskId: medication.medicationId, // Use medication ID
      taskType: 'medication',
      dosage: medication.dosage,
      mealTiming: medication.mealTiming,
      numberOfRounds: medication.numberOfRounds,
      medicationDescription: medication.description,
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

  // Helper method to get appropriate icon for game tasks
  static IconData _getIconForGameTask(String gameName) {
    final lowerGame = gameName.toLowerCase();
    if (lowerGame.contains('memory') || lowerGame.contains('match')) {
      return Icons.memory;
    } else if (lowerGame.contains('puzzle')) {
      return Icons.extension;
    } else if (lowerGame.contains('word') || lowerGame.contains('trivia')) {
      return Icons.quiz;
    } else if (lowerGame.contains('color') || lowerGame.contains('paint')) {
      return Icons.palette;
    } else if (lowerGame.contains('music') || lowerGame.contains('sound')) {
      return Icons.music_note;
    } else if (lowerGame.contains('number') || lowerGame.contains('math')) {
      return Icons.calculate;
    } else if (lowerGame.contains('story') || lowerGame.contains('reading')) {
      return Icons.book;
    } else {
      return Icons.games; // Default icon for games
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
      _fetchAllTasks(scheduleId);
    } else {
      // For now, use schedule ID 1 as default (can be improved later to properly map patients to schedules)
      if (patientId != null) {
        _scheduleId = 1; // Use schedule ID 1 instead of patient ID
        _fetchAllTasks(1);
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

  Future<void> _fetchAllTasks(int scheduleId) async {
    print('DEBUG: Starting to fetch tasks for schedule ID: $scheduleId');
    setState(() {
      _isTasksLoading = true;
      _tasksError = null;
    });

    try {
      print('DEBUG: Making API calls...');
      // Fetch daily activities, game tasks, and medications concurrently
      final dailyActivitiesResult = DailyActivityService.getDailyActivities(
        scheduleId,
      );
      final gameTasksResult = TaskAPI.TaskService.getTasksByScheduleId(
        scheduleId,
      );
      final medicationsResult = MedicationService.getMedicationSchedule(
        scheduleId,
      );

      print('DEBUG: Waiting for all API calls to complete...');
      final results = await Future.wait([
        dailyActivitiesResult,
        gameTasksResult,
        medicationsResult,
      ]);

      print('DEBUG: All API calls completed');
      // Cast results to their proper types
      final dailyResult = results[0] as dynamic;
      final taskResult = results[1] as TaskAPI.ApiResult<List<TaskAPI.Task>>;
      final medications = results[2] as List<MedicationScheduleItem>;

      print('DEBUG: Processing results...');
      print('DEBUG: Daily result success: ${dailyResult.success}');
      print('DEBUG: Game tasks result success: ${taskResult.success}');
      print('DEBUG: Medications count: ${medications.length}');

      List<ScheduleTask> allTasks = [];

      // Add daily activities
      if (dailyResult.success && dailyResult.data != null) {
        final dailyTasks = (dailyResult.data as List<dynamic>)
            .map((activity) => ScheduleTask.fromDailyActivity(activity))
            .toList();
        allTasks.addAll(dailyTasks);
        print('Loaded ${dailyTasks.length} daily activities');
      } else {
        print('Failed to load daily activities: ${dailyResult.message}');
      }

      // Add game tasks
      if (taskResult.success && taskResult.data != null) {
        final gameTasks = taskResult.data!
            .map((task) => ScheduleTask.fromTask(task))
            .toList();
        allTasks.addAll(gameTasks);
        print('Loaded ${gameTasks.length} game tasks');
      } else {
        print('Failed to load game tasks: ${taskResult.message}');
      }

      // Add medication reminders
      if (medications.isNotEmpty) {
        print('DEBUG: Processing ${medications.length} medications:');
        for (var med in medications) {
          print(
            'DEBUG: Medication - ${med.medicationName}, Time: ${med.time}, Status: ${med.status}',
          );
        }
        final medicationTasks = medications
            .map(
              (medication) => ScheduleTask.fromMedicationReminder(medication),
            )
            .toList();
        allTasks.addAll(medicationTasks);
        print('Loaded ${medications.length} medication reminders');
      } else {
        print('DEBUG: No medications found');
      }

      // Sort tasks by time
      allTasks.sort((a, b) {
        try {
          final timeA = _parseTimeForSorting(a.time);
          final timeB = _parseTimeForSorting(b.time);
          return timeA.compareTo(timeB);
        } catch (e) {
          print('Error sorting tasks by time: $e');
          return 0;
        }
      });

      setState(() {
        tasks = allTasks;
        _isTasksLoading = false;
        print('Total tasks loaded: ${tasks.length}');
      });
    } catch (e) {
      setState(() {
        _tasksError = 'Failed to load tasks: $e';
        _isTasksLoading = false;
        tasks = [];
      });
      print('Error loading tasks: $e');
    }
  }

  // Helper method to parse time for sorting (converts to 24-hour format)
  int _parseTimeForSorting(String timeStr) {
    try {
      // Remove AM/PM and parse
      String cleanTime = timeStr.replaceAll(RegExp(r'\s*(AM|PM)'), '');
      final parts = cleanTime.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        // Convert to 24-hour format for sorting
        if (timeStr.toUpperCase().contains('PM') && hour != 12) {
          hour += 12;
        } else if (timeStr.toUpperCase().contains('AM') && hour == 12) {
          hour = 0;
        }

        return hour * 60 + minute; // Convert to minutes for easy comparison
      }
    } catch (e) {
      print('Error parsing time for sorting: $e');
    }
    return 0;
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
        task.skipReason = null; // Clear skip reason when completed
      }
    });
  }

  // Function to show skip reason popup
  void _showSkipReasonDialog(ScheduleTask task) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Skip Task: ${task.title}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please provide a reason for skipping this task:',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 16),

                // Reason text field
                TextFormField(
                  controller: reasonController,
                  autofocus: true,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Reason for skipping',
                    hintText: 'Enter reason for skipping this task...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                String finalReason = reasonController.text.trim();

                if (finalReason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please provide a reason for skipping'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Skip the task with reason
                setState(() {
                  task.isSkipped = true;
                  task.isSelected = false;
                  task.skipReason = finalReason;
                  task.isCompleted =
                      false; // Ensure it's not marked as completed
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task "${task.title}" skipped: $finalReason'),
                    backgroundColor: Colors.orange,
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          task.isSkipped = false;
                          task.skipReason = null;
                        });
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Skip Task'),
            ),
          ],
        );
      },
    );
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
                    _fetchAllTasks(_scheduleId!);
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

                    // Show skip reason for any skipped task (general display)
                    if (task.isSkipped &&
                        task.skipReason != null &&
                        task.skipReason!.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.cancel,
                                size: 16,
                                color: Colors.red.shade600,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Task Skipped',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Reason: ${task.skipReason}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.red.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Show detailed medication information when selected
                    if (task.isSelected && task.taskType == 'medication')
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Medication Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            // Status indicator
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: task.isCompleted
                                    ? Colors.green.shade100
                                    : task.isSkipped
                                    ? Colors.red.shade100
                                    : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: task.isCompleted
                                      ? Colors.green.shade300
                                      : task.isSkipped
                                      ? Colors.red.shade300
                                      : Colors.orange.shade300,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    task.isCompleted
                                        ? Icons.check_circle
                                        : task.isSkipped
                                        ? Icons.cancel
                                        : Icons.schedule,
                                    size: 14,
                                    color: task.isCompleted
                                        ? Colors.green.shade700
                                        : task.isSkipped
                                        ? Colors.red.shade700
                                        : Colors.orange.shade700,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    task.isCompleted
                                        ? 'Taken'
                                        : task.isSkipped
                                        ? 'Skipped'
                                        : 'Pending',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: task.isCompleted
                                          ? Colors.green.shade700
                                          : task.isSkipped
                                          ? Colors.red.shade700
                                          : Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Show skip reason if task is skipped and has a reason
                            if (task.isSkipped &&
                                task.skipReason != null &&
                                task.skipReason!.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: Colors.red.shade600,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Skip Reason:',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            task.skipReason!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.red.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMedicationDetailItem(
                                    'Medication Name',
                                    task.title,
                                    Icons.medication,
                                  ),
                                ),
                                Expanded(
                                  child: _buildMedicationDetailItem(
                                    'Dosage',
                                    task.dosage ?? 'Not specified',
                                    Icons.local_pharmacy,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMedicationDetailItem(
                                    'Meal Timing',
                                    task.mealTiming ?? 'Not specified',
                                    Icons.restaurant,
                                  ),
                                ),
                                Expanded(
                                  child: _buildMedicationDetailItem(
                                    'Rounds',
                                    '${task.numberOfRounds ?? 1}',
                                    Icons.repeat,
                                  ),
                                ),
                              ],
                            ),
                            if (task.medicationDescription != null &&
                                task.medicationDescription!.isNotEmpty) ...[
                              SizedBox(height: 8),
                              _buildMedicationDetailItem(
                                'Description',
                                task.medicationDescription!,
                                Icons.description,
                                isFullWidth: true,
                              ),
                            ],
                          ],
                        ),
                      ),

                    // Skip Task Button (only show when task is selected)
                    if (task.isSelected && !task.isCompleted)
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showSkipReasonDialog(task),
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
                                      task.skipReason =
                                          null; // Clear skip reason when undoing skip
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

  Widget _buildMedicationDetailItem(
    String label,
    String value,
    IconData icon, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: isFullWidth
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: Colors.blue.shade600),
                    SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 14, color: Colors.blue.shade600),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
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

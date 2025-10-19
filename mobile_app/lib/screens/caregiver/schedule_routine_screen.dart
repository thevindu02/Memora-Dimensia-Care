import 'package:flutter/material.dart';
import 'package:mobile_app/constants/color_constants.dart';
import 'dart:ui';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';
import '../../services/daily_activity_service.dart';
import '../../services/task_service.dart' as TaskAPI;
import '../../services/medication_service.dart';
import '../../services/appointment_service.dart';
import '../../services/care_activity_service.dart';
import '../../services/schedule_service.dart';
import '../../models/medication_reminder.dart';

// Remove the nested MaterialApp - this was causing the routing issue
class ScheduleRoutine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScheduleRoutineScreen();
  }
}

class ScheduleTask {
  String title;
  String description;
  String time;
  final IconData icon;
  final Color color;
  bool isSelected;
  bool isCompleted;
  bool isSkipped;
  String? skipReason; // Add skip reason field
  final int? careActivityId; // Add ID for API operations
  final int? dailyTaskId; // Add daily task ID
  String? status; // Add status field for validation (mutable)
  // Additional medication details
  final String? dosage;
  final String? mealTiming;
  final int? numberOfRounds;
  final String? medicationDescription;
  final String?
  taskType; // 'medication', 'daily_activity', 'game', 'appointment'
  // Appointment-specific fields
  final String? hospital;
  final String? doctorName;
  final String? appointmentDate;

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
    this.status,
    this.dosage,
    this.mealTiming,
    this.numberOfRounds,
    this.medicationDescription,
    this.taskType,
    this.hospital,
    this.doctorName,
    this.appointmentDate,
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
      isSkipped: activity.status == 'SKIPPED' || activity.status == 'CANCELLED',
      careActivityId: activity.careActivityId,
      dailyTaskId: activity.dailyTaskId,
      status: activity.status,
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
      isSkipped: task.status == 'SKIPPED' || task.status == 'CANCELLED',
      careActivityId: task.careActivityId,
      dailyTaskId: task.taskId, // Use taskId for game tasks
      status: task.status,
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
      isSkipped:
          medication.status == 'SKIPPED' || medication.status == 'CANCELLED',
      careActivityId: medication.careActivityId,
      dailyTaskId: medication.medicationId, // Use medication ID
      status: medication.status == 'TAKEN' ? 'COMPLETED' : medication.status,
      taskType: 'medication',
      dosage: medication.dosage,
      mealTiming: medication.mealTiming,
      numberOfRounds: medication.numberOfRounds,
      medicationDescription: medication.description,
    );
  }

  // Factory constructor to create ScheduleTask from Appointment
  factory ScheduleTask.fromAppointment(Appointment appointment) {
    return ScheduleTask(
      title: appointment.taskName,
      description:
          'Appointment at ${appointment.hospital} with Dr. ${appointment.doctorName}',
      time: _formatTime(appointment.time),
      icon: Icons.local_hotel,
      color: AppColors.primaryDark,
      isCompleted: appointment.status == 'COMPLETED',
      isSkipped:
          appointment.status == 'SKIPPED' || appointment.status == 'CANCELLED',
      careActivityId: appointment.careActivityId,
      dailyTaskId: appointment.appointmentId,
      status: appointment.status,
      taskType: 'appointment',
      hospital: appointment.hospital,
      doctorName: appointment.doctorName,
      appointmentDate: appointment.date,
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
      return Icons.local_hotel;
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
  List<Map<String, dynamic>> _gameList = [];
  bool _isGameListLoading = false;
  String? _gameListError;

  Future<void> _fetchGameList() async {
    setState(() {
      _isGameListLoading = true;
      _gameListError = null;
    });
    try {
      final result = await TaskAPI.TaskService.getGames();
      if (result.success && result.data != null) {
        _gameList = (result.data as List<dynamic>)
            .map(
              (game) => {
                'gameId': game['gameid'],
                'name': game['name'],
                'description': game['description'],
              },
            )
            .toList();
      } else {
        _gameListError = result.message;
      }
    } catch (e) {
      _gameListError = 'Error loading games: $e';
    }
    setState(() {
      _isGameListLoading = false;
    });
  }

  List<ScheduleTask> tasks = [];
  String selectedTaskTitle = '';
  String? _patientName;
  bool _isPatientLoading = true;
  String? _patientError;
  int? _patientId;
  int? _scheduleId; // Add schedule ID
  DateTime _selectedDate =
      DateTime.now(); // Currently selected date for schedule
  bool _isTasksLoading = true;
  String? _tasksError;
  // Map to track loading state for each task
  Map<int, bool> _taskLoadingStates = {};

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

    // Fetch tasks for the selected date (defaults to today)
    if (patientId != null) {
      _fetchAllTasks();
    } else {
      setState(() {
        _isTasksLoading = false;
        _tasksError = 'No patient information available.';
      });
    }
  }

  String _capitalizeName(String name) {
    if (name.isEmpty) return name;
    return name
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
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
        // Use patientName if available (backend now returns it), else fall back to FName/LName
        _patientName = (data['patientName'] != null && data['patientName'].toString().trim().isNotEmpty)
            ? data['patientName'].toString().trim()
            : ((data['FName'] ?? data['fName'] ?? '') + ' ' + (data['LName'] ?? data['lName'] ?? '')).trim();
        if (_patientName == null || _patientName!.isEmpty) {
          _patientName = 'Unknown';
        }
        _isPatientLoading = false;
      });
    } else {
      setState(() {
        _patientError = 'Failed to load patient info';
        _isPatientLoading = false;
      });
    }
  }

  Future<void> _fetchAllTasks() async {
    if (_patientId == null) {
      print('DEBUG: Cannot fetch tasks - patient ID is null');
      setState(() {
        _isTasksLoading = false;
        _tasksError = 'Patient information not available';
      });
      return;
    }

    print('DEBUG: Starting to fetch schedule for date: $_selectedDate');
    setState(() {
      _isTasksLoading = true;
      _tasksError = null;
    });

    try {
      // Format date as YYYY-MM-DD
      final dateStr =
          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
      print(
        'DEBUG: Fetching schedule for patient ID: $_patientId, date: $dateStr',
      );

      // Get or create schedule for the selected date
      final scheduleResult = await ScheduleService.getOrCreateSchedule(
        _patientId!,
        dateStr,
      );

      if (!scheduleResult.success || scheduleResult.data == null) {
        setState(() {
          _isTasksLoading = false;
          _tasksError = 'Failed to load schedule: ${scheduleResult.message}';
          tasks = [];
        });
        return;
      }

      final scheduleData = scheduleResult.data as Map<String, dynamic>;
      final scheduleId = scheduleData['scheduleId'] as int;
      final isCompleted = scheduleData['isCompleted'] as bool;

      print('DEBUG: Got schedule ID: $scheduleId, isCompleted: $isCompleted');

      // Update the stored schedule ID
      setState(() {
        _scheduleId = scheduleId;
      });

      // If schedule is completed, show empty state
      if (isCompleted) {
        setState(() {
          tasks = [];
          _isTasksLoading = false;
        });
        return;
      }

      print('DEBUG: Making API calls for schedule ID: $scheduleId');
      // Fetch daily activities, game tasks, medications, and appointments concurrently
      final dailyActivitiesResult = DailyActivityService.getDailyActivities(
        scheduleId,
      );
      final gameTasksResult = TaskAPI.TaskService.getTasksByScheduleId(
        scheduleId,
      );
      final medicationsResult = MedicationService.getMedicationSchedule(
        scheduleId,
      );
      final appointmentsResult = AppointmentService.getAppointments(scheduleId);

      print('DEBUG: Waiting for all API calls to complete...');
      final results = await Future.wait([
        dailyActivitiesResult,
        gameTasksResult,
        medicationsResult,
        appointmentsResult,
      ]);

      print('DEBUG: All API calls completed');
      // Cast results to their proper types
      final dailyResult = results[0] as dynamic;
      final taskResult = results[1] as TaskAPI.ApiResult<List<TaskAPI.Task>>;
      final medications = results[2] as List<MedicationScheduleItem>;
      final appointments = results[3] as List<Appointment>;

      print('DEBUG: Processing results...');
      print('DEBUG: Daily result success: ${dailyResult.success}');
      print('DEBUG: Game tasks result success: ${taskResult.success}');
      print('DEBUG: Medications count: ${medications.length}');
      print('DEBUG: Appointments count: ${appointments.length}');

      // Get today's date in YYYY-MM-DD format
      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      print('DEBUG: Today\'s date: $todayStr');

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

      // Add appointments (only for today's date)
      if (appointments.isNotEmpty) {
        print('DEBUG: Processing ${appointments.length} appointments:');
        final todayAppointments = appointments.where((appointment) {
          print(
            'DEBUG: Appointment - ${appointment.taskName}, Date: ${appointment.date}, Time: ${appointment.time}, Status: ${appointment.status}',
          );
          return appointment.date == todayStr;
        }).toList();

        if (todayAppointments.isNotEmpty) {
          final appointmentTasks = todayAppointments
              .map((appointment) => ScheduleTask.fromAppointment(appointment))
              .toList();
          allTasks.addAll(appointmentTasks);
          print('Loaded ${todayAppointments.length} appointments for today');
        } else {
          print('DEBUG: No appointments scheduled for today');
        }
      } else {
        print('DEBUG: No appointments found');
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

  void _toggleTaskCompletion(ScheduleTask task) async {
    // Prevent multiple simultaneous requests for the same task
    if (_taskLoadingStates[task.careActivityId] == true) {
      return;
    }

    // Check if careActivityId exists
    if (task.careActivityId == null) {
      _showErrorDialog('Cannot update task status: Invalid task ID');
      return;
    }

    final bool isCurrentlyCompleted = task.isCompleted;
    final String newStatus = isCurrentlyCompleted ? 'PENDING' : 'COMPLETED';

    // Validate order before making changes
    if (!isCurrentlyCompleted) {
      // Completing a task - check if all earlier tasks are completed/cancelled
      final validationError = _validateTaskCompletionOrder(task);
      if (validationError != null) {
        _showErrorDialog(validationError);
        return;
      }
    } else {
      // Un-completing a task - check if all later tasks are not completed
      final validationError = _validateTaskUncompletionOrder(task);
      if (validationError != null) {
        _showErrorDialog(validationError);
        return;
      }
    }

    // Set loading state
    setState(() {
      _taskLoadingStates[task.careActivityId!] = true;
    });

    try {
      // Call API to update status
      final result = await CareActivityService.updateStatus(
        task.careActivityId!,
        newStatus,
      );

      if (result.success) {
        // Update UI on success
        setState(() {
          task.isCompleted = !isCurrentlyCompleted;
          if (task.isCompleted) {
            task.isSelected = false; // Deselect when completed
            task.isSkipped = false; // Reset skip status when completed
            task.skipReason = null; // Clear skip reason when completed
          }
          _taskLoadingStates[task.careActivityId!] = false;
        });
      } else {
        // Show error and don't update UI
        setState(() {
          _taskLoadingStates[task.careActivityId!] = false;
        });
        _showErrorDialog(result.message);
      }
    } catch (e) {
      // Handle any unexpected errors
      setState(() {
        _taskLoadingStates[task.careActivityId!] = false;
      });
      _showErrorDialog('An error occurred while updating task status');
    }
  }

  /// Validates if a task can be completed
  /// Returns error message if validation fails, null if validation passes
  String? _validateTaskCompletionOrder(ScheduleTask taskToComplete) {
    // Get the time of the task we want to complete
    final taskTime = _parseTimeForSorting(taskToComplete.time);

    // Check all tasks that come before this task (by time)
    for (var task in tasks) {
      final currentTaskTime = _parseTimeForSorting(task.time);

      // If this task is earlier in time
      if (currentTaskTime < taskTime) {
        // Check if it's completed or cancelled
        // Both COMPLETED and CANCELLED tasks are considered "done" for validation
        if (!task.isCompleted &&
            task.status != 'CANCELLED' &&
            !task.isSkipped) {
          return 'Please complete or cancel earlier tasks first.\n\n"${task.title}" at ${task.time} must be completed before this task.';
        }
      }
    }

    return null; // Validation passed
  }

  /// Validates if a task can be un-completed
  /// Returns error message if validation fails, null if validation passes
  String? _validateTaskUncompletionOrder(ScheduleTask taskToUncomplete) {
    // Get the time of the task we want to uncomplete
    final taskTime = _parseTimeForSorting(taskToUncomplete.time);

    // Check all tasks that come after this task (by time)
    for (var task in tasks) {
      final currentTaskTime = _parseTimeForSorting(task.time);

      // If this task is later in time and is completed
      if (currentTaskTime > taskTime && task.isCompleted) {
        return 'Cannot uncomplete this task.\n\nPlease uncomplete later tasks first.\n\n"${task.title}" at ${task.time} is already completed.';
      }
    }

    return null; // Validation passed
  }

  /// Shows an error dialog with the given message
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Cannot Update Task'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to undo task cancellation
  Future<void> _undoCancelTask(ScheduleTask task) async {
    if (task.careActivityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot undo: Invalid task ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('Undoing cancellation...'),
          ],
        ),
        duration: Duration(seconds: 10),
      ),
    );

    try {
      // Call API to update status back to PENDING (which will also clear skip reason)
      final result = await CareActivityService.updateStatusWithReason(
        task.careActivityId!,
        'PENDING',
        null, // No skip reason for PENDING status
      );

      // Hide loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (result.success) {
        // Update UI on success
        setState(() {
          task.isSkipped = false;
          task.skipReason = null;
          task.isCompleted = false;
          task.status = 'PENDING'; // Update status to PENDING
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${task.title}" restored to pending'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to undo cancellation: ${result.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Hide loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Handle any unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while undoing cancellation'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to show skip reason popup
  void _showSkipReasonDialog(ScheduleTask task) async {
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
              onPressed: () async {
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

                // Check if careActivityId exists
                if (task.careActivityId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cannot skip task: Invalid task ID'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.pop(context);

                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('Cancelling task...'),
                      ],
                    ),
                    duration: Duration(seconds: 10),
                  ),
                );

                try {
                  // Call API to update status to CANCELLED with skip reason
                  final result =
                      await CareActivityService.updateStatusWithReason(
                        task.careActivityId!,
                        'CANCELLED',
                        finalReason,
                      );

                  // Hide loading indicator
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  if (result.success) {
                    // Update UI on success
                    setState(() {
                      task.isSkipped = true;
                      task.isSelected = false;
                      task.skipReason = finalReason;
                      task.isCompleted = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task "${task.title}" cancelled'),
                        backgroundColor: Colors.orange,
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: Colors.white,
                          onPressed: () async {
                            await _undoCancelTask(task);
                          },
                        ),
                      ),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to cancel task: ${result.message}',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  // Hide loading indicator
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  // Handle any unexpected errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('An error occurred while cancelling task'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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

  // Check if all tasks are completed or cancelled (routine can be marked complete)
  bool get canCompleteRoutine {
    if (tasks.isEmpty) return false;

    return tasks.every(
      (task) =>
          task.isCompleted || task.status == 'CANCELLED' || task.isSkipped,
    );
  }

  // Function to complete the daily routine
  Future<void> _completeRoutine() async {
    if (_scheduleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot complete routine: No schedule found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Complete Routine'),
            ],
          ),
          content: Text(
            'Are you sure you want to mark this daily routine as complete?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Complete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Completing routine...'),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      // Call API to mark schedule as completed
      final result = await ScheduleService.completeSchedule(_scheduleId!);

      // Hide loading indicator
      Navigator.of(context).pop();

      if (result.success) {
        // Show success message
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 32),
                  SizedBox(width: 12),
                  Text('Success!'),
                ],
              ),
              content: Text(
                'Daily routine has been completed successfully!',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        // Clear tasks to show empty state
        setState(() {
          tasks.clear();
        });
      } else {
        // Show error message - tasks remain visible
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete routine: ${result.message}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      // Hide loading indicator if still showing
      Navigator.of(context).pop();

      // Handle any unexpected errors - tasks remain visible
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while completing routine'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  // Date Navigation Methods
  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
    _fetchAllTasks(); // Refresh tasks for the new date
  }

  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
    _fetchAllTasks(); // Refresh tasks for the new date
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchAllTasks(); // Refresh tasks for the new date
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Today, ${months[date.month - 1]} ${date.day}';
    } else if (selectedDay == today.subtract(Duration(days: 1))) {
      return 'Yesterday, ${months[date.month - 1]} ${date.day}';
    } else if (selectedDay == today.add(Duration(days: 1))) {
      return 'Tomorrow, ${months[date.month - 1]} ${date.day}';
    } else {
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
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

            // Date Navigation
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Day Button
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: AppColors.primaryDark,
                    ),
                    onPressed: _goToPreviousDay,
                    tooltip: 'Previous Day',
                  ),
                  // Date Display
                  Expanded(
                    child: GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: AppColors.primaryDark,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _formatDate(_selectedDate),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Next Day Button
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: AppColors.primaryDark,
                    ),
                    onPressed: _goToNextDay,
                    tooltip: 'Next Day',
                  ),
                ],
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
                onPressed: canCompleteRoutine ? _completeRoutine : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canCompleteRoutine
                      ? Colors.green
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: canCompleteRoutine ? 2 : 0,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Complete Daily Routine',
                      style: TextStyle(
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
                  _fetchAllTasks();
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
        final bool isCancelled = task.status == 'CANCELLED' || task.isSkipped;

        return Opacity(
          opacity: isCancelled ? 0.5 : 1.0, // Dim cancelled tasks
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isCancelled
                    ? null
                    : () =>
                          _selectTask(task), // Disable tap for cancelled tasks
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCancelled
                        ? Colors
                              .grey
                              .shade200 // Gray background for cancelled tasks
                        : (task.isSelected ? Color(0xFFE8E0FF) : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCancelled
                          ? Colors
                                .grey
                                .shade400 // Gray border for cancelled tasks
                          : (task.isSelected
                                ? Color(0xFF6B4EE6)
                                : Colors.grey.shade200),
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
                                    color: isCancelled
                                        ? Colors.grey[500]
                                        : Colors.black87,
                                    decoration: isCancelled
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  task.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isCancelled
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    decoration: isCancelled
                                        ? TextDecoration.lineThrough
                                        : null,
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
                            onTap: isCancelled
                                ? null
                                : () => _toggleTaskCompletion(
                                    task,
                                  ), // Disable for cancelled tasks
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: task.isCompleted
                                    ? Colors.green
                                    : (isCancelled
                                          ? Colors.grey.shade300
                                          : Colors.transparent),
                                border: Border.all(
                                  color: task.isCompleted
                                      ? Colors.green
                                      : (isCancelled
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade400),
                                  width: 2,
                                ),
                              ),
                              child:
                                  _taskLoadingStates[task.careActivityId] ==
                                      true
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.blue,
                                            ),
                                      ),
                                    )
                                  : task.isCompleted
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

                      // Show skip reason for any cancelled task (general display)
                      if (isCancelled &&
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
                                      'Task Cancelled',
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Medication Details',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_up),
                                    color: Colors.blue.shade800,
                                    iconSize: 24,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    tooltip: 'Minimize',
                                    onPressed: () {
                                      setState(() {
                                        task.isSelected = false;
                                      });
                                    },
                                  ),
                                ],
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

                              // Show cancel reason if task is cancelled and has a reason
                              if (isCancelled &&
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              'Cancellation Reason:',
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

                      // Show detailed appointment information when selected
                      if (task.isSelected && task.taskType == 'appointment')
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_hotel,
                                        color: Colors.purple.shade700,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Appointment Details',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.purple.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_up),
                                    color: Colors.purple.shade800,
                                    iconSize: 24,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    tooltip: 'Minimize',
                                    onPressed: () {
                                      setState(() {
                                        task.isSelected = false;
                                      });
                                    },
                                  ),
                                ],
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
                                          ? 'Completed'
                                          : task.isSkipped
                                          ? 'Skipped'
                                          : 'Scheduled',
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

                              SizedBox(height: 12),
                              _buildMedicationDetailItem(
                                'Hospital/Clinic',
                                task.hospital ?? 'Not specified',
                                Icons.local_hotel,
                                isFullWidth: true,
                              ),
                              SizedBox(height: 8),
                              _buildMedicationDetailItem(
                                'Doctor',
                                'Dr. ${task.doctorName ?? 'Not specified'}',
                                Icons.person,
                                isFullWidth: true,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMedicationDetailItem(
                                      'Date',
                                      _formatDateDisplay(
                                        task.appointmentDate ?? '',
                                      ),
                                      Icons.calendar_today,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildMedicationDetailItem(
                                      'Time',
                                      task.time,
                                      Icons.access_time,
                                    ),
                                  ),
                                ],
                              ),
                              if (task.description.isNotEmpty) ...[
                                SizedBox(height: 8),
                                _buildMedicationDetailItem(
                                  'Notes',
                                  task.description,
                                  Icons.notes,
                                  isFullWidth: true,
                                ),
                              ],
                            ],
                          ),
                        ),

                      // Skip Task Button (only show when task is selected, not completed, and not cancelled)
                      if (task.isSelected &&
                          !task.isCompleted &&
                          !isCancelled &&
                          (task.status == 'PENDING' || task.status == null))
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

                      // Edit and Undo buttons row (show for selected tasks or cancelled tasks)
                      if ((task.isSelected &&
                              !task.isCompleted &&
                              !isCancelled) ||
                          isCancelled)
                        Container(
                          margin: EdgeInsets.only(
                            top: task.isSelected ? 8 : 16,
                          ),
                          child: Row(
                            children: [
                              // Edit Button (only show for non-cancelled tasks)
                              if (!isCancelled)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _editTask(task),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Color(0xFF6B4EE6),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
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
                                      style: TextStyle(
                                        color: Color(0xFF6B4EE6),
                                      ),
                                    ),
                                  ),
                                ),

                              // Undo Skip Button (only for cancelled/skipped tasks)
                              if (task.isSkipped || isCancelled)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await _undoCancelTask(task);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                    ),
                                    icon: Icon(Icons.undo, size: 16),
                                    label: Text('Undo Cancel'),
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
          ), // Close the Opacity child property
        ); // Close the return statement
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
    if (task.taskType == 'game') {
      _fetchGameList().then((_) {
        String selectedGameName = task.title;
        final _descriptionController = TextEditingController(
          text: task.description,
        );
        TimeOfDay? _selectedTime = TimeOfDay(
          hour: int.parse(task.time.split(':')[0].split(' ')[0]),
          minute: int.parse(task.time.split(':')[1].split(' ')[0]),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.edit, color: Color(0xFF6B4EE6)),
                      SizedBox(width: 8),
                      Text('Edit Game Task'),
                    ],
                  ),
                  content: Container(
                    width: double.maxFinite,
                    child: _isGameListLoading
                        ? Center(child: CircularProgressIndicator())
                        : _gameListError != null
                        ? Text(
                            _gameListError!,
                            style: TextStyle(color: Colors.red),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                value: selectedGameName,
                                items: _gameList.map((game) {
                                  return DropdownMenuItem<String>(
                                    value: game['name'],
                                    child: Text(game['name']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedGameName = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Game Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.games),
                                ),
                              ),
                              SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                        context: context,
                                        initialTime:
                                            _selectedTime ?? TimeOfDay.now(),
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
                      onPressed: () async {
                        final String formattedTime = _selectedTime != null
                            ? _selectedTime!.hour.toString().padLeft(2, '0') +
                                  ':' +
                                  _selectedTime!.minute.toString().padLeft(
                                    2,
                                    '0',
                                  )
                            : '';
                        final result = await TaskAPI.TaskService.editGameTask(
                          taskId: task.dailyTaskId!,
                          gameName: selectedGameName,
                          time: formattedTime,
                          description: _descriptionController.text.trim(),
                        );
                        if (result.success) {
                          setState(() {
                            task.title = selectedGameName;
                            task.description = _descriptionController.text
                                .trim();
                            task.time = formattedTime;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Game task updated successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                );
              },
            );
          },
        );
      });
    } else {
      // ...existing code for daily activity edit...
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
                      TextFormField(
                        controller: _taskNameController,
                        decoration: InputDecoration(
                          labelText: 'Task Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.task_alt),
                        ),
                      ),
                      SizedBox(height: 16),
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
                    onPressed: () async {
                      final String formattedTime = _selectedTime != null
                          ? _selectedTime!.hour.toString().padLeft(2, '0') +
                                ':' +
                                _selectedTime!.minute.toString().padLeft(2, '0')
                          : '';
                      final request = DailyActivityRequest(
                        taskName: _taskNameController.text.trim(),
                        time: formattedTime,
                        description: _descriptionController.text.trim(),
                      );
                      final result =
                          await DailyActivityService.updateDailyActivity(
                            task.dailyTaskId!,
                            request,
                          );
                      if (result.success) {
                        setState(() {
                          task.title = request.taskName;
                          task.description = request.description ?? '';
                          task.time = formattedTime;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Task updated successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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

  /// Helper method to format date from YYYY-MM-DD to DD/MM/YYYY
  String _formatDateDisplay(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }
}

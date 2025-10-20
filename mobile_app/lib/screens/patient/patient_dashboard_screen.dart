import 'package:flutter/material.dart';
import 'dart:ui';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';
import '../../services/schedule_service.dart';
import '../../services/care_activity_service.dart';
import '../../models/patient_profile.dart';
import '../../models/schedule_task.dart';
import 'package:intl/intl.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({Key? key}) : super(key: key);

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  int currentBottomNavIndex = 0;
  
  // State variables for API data
  PatientProfile? patientProfile;
  List<ScheduleTask> tasks = [];
  bool isLoading = true;
  bool isLoadingTasks = false;
  String? errorMessage;
  DateTime selectedDate = DateTime.now();
  int? _scheduleId; // Track current schedule ID
  bool _isScheduleCompleted = false; // Track if schedule is already completed
  Map<int, bool> _taskLoadingStates = {}; // Track loading state for each task
  
  // Patient ID - will be loaded from user session
  int? patientId;

  @override
  void initState() {
    super.initState();
    _initializePatientData();
  }

  Future<void> _initializePatientData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Get user ID from auth
      final userId = await AuthService.getCurrentUserId();
      
      if (userId == null) {
        setState(() {
          errorMessage = 'User not logged in';
          isLoading = false;
        });
        return;
      }

      // Get patient ID from user ID
      final fetchedPatientId = await PatientService.getPatientIdByUserId(userId);
      
      if (fetchedPatientId == null) {
        setState(() {
          errorMessage = 'Patient profile not found';
          isLoading = false;
        });
        return;
      }

      setState(() {
        patientId = fetchedPatientId;
      });

      // Now load patient data
      await _loadPatientData();
    } catch (e) {
      setState(() {
        errorMessage = 'Error initializing: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadPatientData() async {
    if (patientId == null) {
      setState(() {
        errorMessage = 'Patient ID not available';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Load patient profile
      final profile = await PatientService.getPatientProfile(patientId!);
      
      // Get or create schedule for selected date
      final dateStr = PatientService.formatDateForApi(selectedDate);
      
      // Get schedule ID and completion status
      final scheduleResult = await ScheduleService.getOrCreateSchedule(
        patientId!,
        dateStr,
      );
      
      if (!scheduleResult.success || scheduleResult.data == null) {
        throw Exception('Failed to load schedule: ${scheduleResult.message}');
      }
      
      final scheduleData = scheduleResult.data as Map<String, dynamic>;
      final scheduleId = scheduleData['scheduleId'] as int;
      final isCompleted = scheduleData['isCompleted'] as bool;
      
      // Load tasks for the schedule
      final scheduleTasks = await PatientService.getScheduleForDate(patientId!, dateStr);
      
      setState(() {
        patientProfile = profile;
        tasks = scheduleTasks;
        _scheduleId = scheduleId;
        _isScheduleCompleted = isCompleted;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _refreshSchedule() async {
    if (patientId == null) return;
    
    setState(() {
      isLoadingTasks = true;
    });
    
    try {
      final dateStr = PatientService.formatDateForApi(selectedDate);
      
      // Get schedule ID and completion status
      final scheduleResult = await ScheduleService.getOrCreateSchedule(
        patientId!,
        dateStr,
      );
      
      if (!scheduleResult.success || scheduleResult.data == null) {
        throw Exception('Failed to load schedule: ${scheduleResult.message}');
      }
      
      final scheduleData = scheduleResult.data as Map<String, dynamic>;
      final scheduleId = scheduleData['scheduleId'] as int;
      final isCompleted = scheduleData['isCompleted'] as bool;
      
      // Load tasks
      final scheduleTasks = await PatientService.getScheduleForDate(patientId!, dateStr);
      
      setState(() {
        tasks = scheduleTasks;
        _scheduleId = scheduleId;
        _isScheduleCompleted = isCompleted;
        isLoadingTasks = false;
      });
    } catch (e) {
      setState(() {
        isLoadingTasks = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh schedule: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    _refreshSchedule();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _refreshSchedule();
    }
  }

  String _formatDateNavigation(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final tomorrow = today.add(Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Today, ${DateFormat('MMM d').format(date)}';
    } else if (targetDate == yesterday) {
      return 'Yesterday, ${DateFormat('MMM d').format(date)}';
    } else if (targetDate == tomorrow) {
      return 'Tomorrow, ${DateFormat('MMM d').format(date)}';
    } else {
      return DateFormat('EEEE, MMM d').format(date);
    }
  }

  // Check if the Complete Daily Routine button should be enabled
  bool get canCompleteRoutine {
    if (tasks.isEmpty) return false;
    if (_isScheduleCompleted) return false;
    
    // Check if selected date is today
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    if (selectedDay != today) return false;
    
    // Check if all tasks are completed or cancelled
    return tasks.every((task) => 
      task.status == 'COMPLETED' || 
      task.status == 'CANCELLED'
    );
  }

  // Check if selected date is today
  bool get _isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    return selectedDay == today;
  }

  // Complete the daily routine
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

        // Update state to show schedule is completed
        setState(() {
          _isScheduleCompleted = true;
        });
      } else {
        // Show error message
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
      
      // Handle any unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while completing routine'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  int get completedTasksCount {
    return tasks.where((task) => task.isCompleted).length;
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
        if (task.status != 'COMPLETED' && task.status != 'CANCELLED') {
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
      if (currentTaskTime > taskTime && task.status == 'COMPLETED') {
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

  void _showSkipDialog(ScheduleTask task) {
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
                        Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.orange, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Skip Task',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close, color: Colors.grey),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'You are about to skip: ${task.title}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This task will be marked as skipped and needs caregiver confirmation.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Reason for skipping (required):',
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
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Please provide a reason...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.orange, width: 2),
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
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text('Skipping task...'),
                                  ],
                                ),
                                duration: Duration(seconds: 10),
                              ),
                            );

                            try {
                              // Call API to update status to SKIPPED with skip reason
                              final result = await CareActivityService.updateStatusWithReason(
                                task.careActivityId!,
                                'SKIPPED',
                                finalReason,
                              );

                              // Hide loading indicator
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();

                              if (result.success) {
                                // Refresh the schedule to get updated task list
                                await _refreshSchedule();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Task "${task.title}" has been skipped. Waiting for caregiver confirmation.'),
                                    backgroundColor: Colors.orange,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to skip task: ${result.message}'),
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
                                  content: Text('An error occurred while skipping task'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Skip Task',
                            style: TextStyle(
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: PatientColors.backgroundWhite,
        automaticallyImplyLeading: false, // ← disables back icon
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/light_logo.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'Memora',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.patientNotifications);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text('Error: $errorMessage'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPatientData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshSchedule,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage('assets/images/profile_avatar.png'),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good ${_getGreeting()}, ${patientProfile?.firstName ?? 'User'}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('EEEE, MMM d').format(selectedDate),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Task Summary Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightAccent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Today\'s Tasks',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(
                                            Icons.list,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${tasks.length}',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.successBackground,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Completed',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.success,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: AppColors.success,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '$completedTasksCount',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Date Navigation
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.chevron_left, color: AppColors.primary),
                                  onPressed: isLoadingTasks ? null : () => _changeDate(-1),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: isLoadingTasks ? null : _pickDate,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                                        SizedBox(width: 8),
                                        isLoadingTasks
                                            ? SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                                ),
                                              )
                                            : Text(
                                                _formatDateNavigation(selectedDate),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.chevron_right, color: AppColors.primary),
                                  onPressed: isLoadingTasks ? null : () => _changeDate(1),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Daily Activities Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Daily Activities',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    AppRoutes.patientSelectRoutine,
                                    arguments: selectedDate,
                                  );
                                  if (result == true) {
                                    // Refresh schedule after task creation
                                    _refreshSchedule();
                                  }
                                },
                                icon: const Icon(Icons.add, size: 20),
                                label: const Text('Add Task'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.lightAccent,
                                  foregroundColor: AppColors.primary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Activities List
                        tasks.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    children: [
                                      Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                                      SizedBox(height: 16),
                                      Text(
                                        'No tasks scheduled for this date',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  return Opacity(
                                    opacity: _isScheduleCompleted ? 0.5 : 1.0,
                                    child: IgnorePointer(
                                      ignoring: _isScheduleCompleted,
                                      child: ScheduleTaskCard(
                                        task: task,
                                        isToday: _isToday,
                                        onToggle: () async {
                                          // Prevent multiple simultaneous requests for the same task
                                          if (_taskLoadingStates[task.careActivityId] == true) {
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
                                            _taskLoadingStates[task.careActivityId] = true;
                                          });

                                          try {
                                            await PatientService.updateTaskStatus(
                                              task.careActivityId,
                                              newStatus,
                                            );
                                            await _refreshSchedule();
                                            
                                            // Clear loading state
                                            setState(() {
                                              _taskLoadingStates[task.careActivityId] = false;
                                            });
                                            
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  isCurrentlyCompleted
                                                      ? 'Task marked as pending'
                                                      : 'Task completed!',
                                                ),
                                                backgroundColor: AppColors.success,
                                              ),
                                            );
                                          } catch (e) {
                                            // Clear loading state on error
                                            setState(() {
                                              _taskLoadingStates[task.careActivityId] = false;
                                            });
                                            
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Failed to update task: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        onSkip: () => _showSkipDialog(task),
                                      ),
                                    ),
                                  );
                                },
                              ),

                        const SizedBox(height: 30),

                        // Complete Daily Routine Button (only show for today)
                        if (_isToday && !_isScheduleCompleted)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: canCompleteRoutine ? _completeRoutine : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: canCompleteRoutine ? Colors.green : Colors.grey,
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

                        const SizedBox(height: 30),

                        // Quick Actions (filtered by dementia stage)
                        if (patientProfile != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quick Actions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 15,
                                  runSpacing: 15,
                                  children: [
                                    // Daily Activity - Available for all stages
                                    QuickActionCard(
                                      icon: Icons.schedule,
                                      title: 'Daily Activity',
                                      color: Colors.orange[100]!,
                                      onTap: () async {
                                        final result = await Navigator.pushNamed(
                                          context,
                                          AppRoutes.patientSelectRoutine,
                                        );
                                        if (result == true) {
                                          // Refresh schedule after task creation
                                          _refreshSchedule();
                                        }
                                      },
                                    ),
                                    // Game - Available for all stages
                                    QuickActionCard(
                                      icon: Icons.games,
                                      title: 'Schedule Game',
                                      color: Colors.purple[100]!,
                                      onTap: () async {
                                        final result = await Navigator.pushNamed(
                                          context,
                                          AppRoutes.patientSelectRoutine,
                                        );
                                        if (result == true) {
                                          // Refresh schedule after task creation
                                          _refreshSchedule();
                                        }
                                      },
                                    ),
                                    // Medication - Only for MILD/MODERATE
                                    if (patientProfile!.canAddAllTaskTypes)
                                      QuickActionCard(
                                        icon: Icons.medication,
                                        title: 'Add Medication',
                                        color: Colors.blue[100]!,
                                        onTap: () async {
                                          final result = await Navigator.pushNamed(
                                            context,
                                            AppRoutes.patientSelectRoutine,
                                          );
                                          if (result == true) {
                                            // Refresh schedule after task creation
                                            _refreshSchedule();
                                          }
                                        },
                                      ),
                                    // Appointment - Only for MILD/MODERATE
                                    if (patientProfile!.canAddAllTaskTypes)
                                      QuickActionCard(
                                        icon: Icons.event,
                                        title: 'Appointment',
                                        color: Colors.green[100]!,
                                        onTap: () async {
                                          final result = await Navigator.pushNamed(
                                            context,
                                            AppRoutes.patientSelectRoutine,
                                          );
                                          if (result == true) {
                                            // Refresh schedule after task creation
                                            _refreshSchedule();
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 100), // Bottom padding for navigation
                      ],
                    ),
                  ),
                ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

class ScheduleTaskCard extends StatefulWidget {
  final ScheduleTask task;
  final VoidCallback onToggle;
  final VoidCallback onSkip;
  final bool isToday;

  const ScheduleTaskCard({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onSkip,
    required this.isToday,
  }) : super(key: key);

  @override
  State<ScheduleTaskCard> createState() => _ScheduleTaskCardState();
}

class _ScheduleTaskCardState extends State<ScheduleTaskCard> {
  bool isSelected = false;

  IconData _getTaskIcon() {
    switch (widget.task.taskType) {
      case 'DAILY_ACTIVITY':
        return Icons.task_alt;
      case 'GAME':
        return Icons.games;
      case 'MEDICATION':
        return Icons.medication;
      case 'APPOINTMENT':
        return Icons.local_hospital;
      default:
        return Icons.checklist;
    }
  }

  Color _getTaskColor() {
    switch (widget.task.taskType) {
      case 'DAILY_ACTIVITY':
        return Colors.blue;
      case 'GAME':
        return Colors.purple;
      case 'MEDICATION':
        return Colors.green;
      case 'APPOINTMENT':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskColor = _getTaskColor();
    final isSkipped = widget.task.status == 'SKIPPED';
    final isCancelled = widget.task.status == 'CANCELLED';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Opacity(
            opacity: isCancelled ? 0.5 : (isSkipped ? 0.7 : 1.0),
            child: IgnorePointer(
              ignoring: isCancelled,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.lightAccent
                      : isSkipped 
                          ? Colors.orange.shade50 
                          : isCancelled
                              ? Colors.grey.shade100
                              : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : isSkipped 
                            ? Colors.orange.shade300
                            : isCancelled
                                ? Colors.grey.shade300
                                : Colors.grey.shade200,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: taskColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTaskIcon(),
                        color: taskColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.task.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                                    color: (isSkipped || isCancelled) ? Colors.grey : Colors.black87,
                                  ),
                                ),
                              ),
                              if (isSkipped) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'WAITING',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                              ],
                              if (isCancelled) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'CANCELLED',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (widget.task.description != null)
                            Text(
                              widget.task.description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: (isSkipped || isCancelled) ? Colors.grey.shade400 : Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          // Show skip reason for skipped tasks
                          if (isSkipped && widget.task.skipReason != null && widget.task.skipReason!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Reason: ${widget.task.skipReason}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTime(widget.task.time),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: (isSkipped || isCancelled) ? Colors.grey : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: (isSkipped || isCancelled) ? null : widget.onToggle,
                          child: widget.task.isCompleted
                              ? Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 20,
                                )
                              : Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: (isSkipped || isCancelled)
                                          ? Colors.grey.shade300
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Action buttons section - only show for selected tasks on today's date
                if (isSelected && widget.isToday)
                  Column(
                    children: [
                      // Play Game button for game tasks
                      if (widget.task.taskType == 'GAME' &&
                          widget.task.gameName != null &&
                          !widget.task.isCompleted &&
                          !isSkipped && 
                          !isCancelled)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _navigateToGame(widget.task.gameName!),
                            icon: const Icon(Icons.play_arrow, size: 20),
                            label: const Text(
                              'Play Game',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 1,
                            ),
                          ),
                        ),
                      // Skip button for all task types
                      if (!widget.task.isCompleted && 
                          !isSkipped && 
                          !isCancelled)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onSkip,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 1,
                            ),
                            child: const Text(
                              'Skip Task',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                // Show detailed medication information when selected
                if (isSelected && widget.task.taskType == 'MEDICATION')
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.medication, color: Colors.green.shade700, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Medication Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        
                        // Medication details grid
                        if (widget.task.dosage != null || widget.task.mealTiming != null)
                          Column(
                            children: [
                              if (widget.task.dosage != null)
                                _buildMedicationDetailItem(
                                  'Dosage',
                                  widget.task.dosage!,
                                  Icons.medication_liquid,
                                ),
                              SizedBox(height: 8),
                              if (widget.task.mealTiming != null)
                                _buildMedicationDetailItem(
                                  'Meal Timing',
                                  widget.task.mealTiming!,
                                  Icons.restaurant,
                                ),
                            ],
                          ),
                        
                        // Description if available
                        if (widget.task.description != null && widget.task.description!.isNotEmpty)
                          Column(
                            children: [
                              SizedBox(height: 8),
                              _buildMedicationDetailItem(
                                'Instructions',
                                widget.task.description!,
                                Icons.info_outline,
                                isFullWidth: true,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                // Show detailed appointment information when selected
                if (isSelected && widget.task.taskType == 'APPOINTMENT')
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_hospital, color: Colors.orange.shade700, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Appointment Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        
                        // Appointment details
                        if (widget.task.hospital != null || widget.task.doctorName != null || widget.task.appointmentDate != null)
                          Column(
                            children: [
                              if (widget.task.hospital != null)
                                _buildDetailItem(
                                  'Hospital',
                                  widget.task.hospital!,
                                  Icons.local_hospital,
                                  Colors.orange,
                                ),
                              if (widget.task.hospital != null && widget.task.doctorName != null)
                                SizedBox(height: 8),
                              if (widget.task.doctorName != null)
                                _buildDetailItem(
                                  'Doctor',
                                  'Dr. ${widget.task.doctorName}',
                                  Icons.person,
                                  Colors.orange,
                                ),
                              if (widget.task.doctorName != null && widget.task.appointmentDate != null)
                                SizedBox(height: 8),
                              if (widget.task.appointmentDate != null)
                                _buildDetailItem(
                                  'Date',
                                  _formatAppointmentDate(widget.task.appointmentDate!),
                                  Icons.calendar_today,
                                  Colors.orange,
                                ),
                            ],
                          ),
                        
                        // Description if available
                        if (widget.task.description != null && widget.task.description!.isNotEmpty)
                          Column(
                            children: [
                              SizedBox(height: 8),
                              _buildDetailItem(
                                'Notes',
                                widget.task.description!,
                                Icons.notes,
                                Colors.orange,
                                isFullWidth: true,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                // Show detailed daily activity information when selected
                if (isSelected && widget.task.taskType == 'DAILY_ACTIVITY')
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.task_alt, color: Colors.blue.shade700, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Activity Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                        
                        // Description/Instructions
                        if (widget.task.description != null && widget.task.description!.isNotEmpty)
                          Column(
                            children: [
                              SizedBox(height: 12),
                              _buildDetailItem(
                                'Instructions',
                                widget.task.description!,
                                Icons.info_outline,
                                Colors.blue,
                                isFullWidth: true,
                              ),
                            ],
                          ),
                        
                        // Show time
                        Column(
                          children: [
                            SizedBox(height: 8),
                            _buildDetailItem(
                              'Scheduled Time',
                              widget.task.time,
                              Icons.access_time,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToGame(String gameName) {
    String? route;
    
    // Map game name to route
    switch (gameName) {
      case 'Sudoku':
        route = AppRoutes.patientSudoku;
        break;
      case 'Memory Match':
        route = AppRoutes.patientMemoryMatch;
        break;
      default:
        // Unknown game
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Game "$gameName" is not available'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
    }
    
    // Navigate to the game
    Navigator.of(context).pushNamed(route);
  }

  Widget _buildMedicationDetailItem(
    String label,
    String value,
    IconData icon, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: isFullWidth
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: Colors.green.shade700),
                    SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
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
          : Row(
              children: [
                Icon(icon, size: 16, color: Colors.green.shade700),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    MaterialColor colorScheme, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.shade200),
      ),
      child: isFullWidth
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: colorScheme.shade700),
                    SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
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
          : Row(
              children: [
                Icon(icon, size: 16, color: colorScheme.shade700),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  String _formatAppointmentDate(String dateStr) {
    try {
      // Assuming date is in YYYY-MM-DD format
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        
        final months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        
        final monthIndex = int.parse(month) - 1;
        if (monthIndex >= 0 && monthIndex < 12) {
          return '${months[monthIndex]} $day, $year';
        }
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '$hour:$minute $period';
    } catch (e) {
      return time;
    }
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const QuickActionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 55) / 2, // Fixed width for consistent card size
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.blue[700],
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
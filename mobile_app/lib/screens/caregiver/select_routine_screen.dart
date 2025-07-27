// Fixed Error Handling System for Flutter Caregiving App

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

// 1. Error Types and Models
enum ErrorType {
  network,
  validation,
  navigation,
  storage,
  permission,
  unknown
}

class AppError {
  final ErrorType type;
  final String message;
  final String? details;
  final int? code;
  final DateTime timestamp;

  AppError({
    required this.type,
    required this.message,
    this.details,
    this.code,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => 'AppError(type: $type, message: $message)';
}

// 2. Global Error Handler with Context
class ErrorHandler {
  static BuildContext? _context;

  static void initialize(BuildContext context) {
    _context = context;
  }

  static void handleError(AppError error) {
    // Log error
    print('Error: ${error.toString()}');

    // You can integrate with crash reporting services like Firebase Crashlytics
    // FirebaseCrashlytics.instance.recordError(error.message, null);

    // Show user-friendly message based on error type
    switch (error.type) {
      case ErrorType.network:
        _showNetworkError();
        break;
      case ErrorType.validation:
        _showValidationError(error.message);
        break;
      case ErrorType.navigation:
        _showNavigationError();
        break;
      case ErrorType.storage:
        _showStorageError();
        break;
      case ErrorType.permission:
        _showPermissionError();
        break;
      default:
        _showGenericError();
    }
  }

  static void _showNetworkError() {
    _showSnackBar('No internet connection. Please check your network.', Colors.red);
  }

  static void _showValidationError(String message) {
    _showSnackBar(message, Colors.orange);
  }

  static void _showNavigationError() {
    _showSnackBar('Navigation failed. Please try again.', Colors.red);
  }

  static void _showStorageError() {
    _showSnackBar('Data storage error. Please try again.', Colors.red);
  }

  static void _showPermissionError() {
    _showSnackBar('Permission denied. Please grant required permissions.', Colors.red);
  }

  static void _showGenericError() {
    _showSnackBar('Something went wrong. Please try again.', Colors.red);
  }

  static void _showSnackBar(String message, Color backgroundColor) {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// 3. RoutineCard Model (Missing from original code)
class RoutineCard {
  final String title;
  final String buttonText;
  final Color backgroundColor;
  final Color buttonColor;
  final IconData icon;

  RoutineCard({
    required this.title,
    required this.buttonText,
    required this.backgroundColor,
    required this.buttonColor,
    required this.icon,
  });
}

// 4. App Routes (Missing from original code)
class Approute {
  static const String caregiverDashboard = '/caregiver-dashboard';
  static const String viewArticleList = '/view-article-list';
  static const String caregiverProfile = '/caregiver-profile';
  static const String addDailyActivity = '/add-daily-activity';
  static const String addTask = '/add-task';
  static const String addMedication = '/add-medication';
  static const String addAppointment = '/add-appointment';
  static const String todayRoutine = '/today-routine';
}

// 5. Enhanced SelectType Widget with Error Handling
class SelectTypeWithErrorHandling extends StatefulWidget {
  @override
  _SelectTypeWithErrorHandlingState createState() => _SelectTypeWithErrorHandlingState();
}

class _SelectTypeWithErrorHandlingState extends State<SelectTypeWithErrorHandling> {
  int _currentIndex = 1;
  bool _isLoading = false;
  String? _errorMessage;

  final List<RoutineCard> routineCards = [
    RoutineCard(
      title: 'Daily Activities',
      buttonText: 'Add Daily Activities',
      backgroundColor: Color(0xFFE3F2FD),
      buttonColor: Color(0xFF2196F3),
      icon: Icons.calendar_today,
    ),
    RoutineCard(
      title: 'Task Management',
      buttonText: 'Add Task',
      backgroundColor: Color(0xFFFCE4EC),
      buttonColor: Color(0xFFE91E63),
      icon: Icons.radio_button_unchecked,
    ),
    RoutineCard(
      title: 'Medication',
      buttonText: 'Add Medication Reminders',
      backgroundColor: Color(0xFFE8F5E8),
      buttonColor: Color(0xFF4CAF50),
      icon: Icons.calendar_today,
    ),
    RoutineCard(
      title: 'Appointment',
      buttonText: 'Add Appointments',
      backgroundColor: Color(0xFFFFEBEE),
      buttonColor: Color(0xFFF44336),
      icon: Icons.radio_button_unchecked,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize error handler with context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ErrorHandler.initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => _safeNavigateBack(context),
        ),
        title: Text(
          'Add Task',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.caregiverNotification);
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: routineCards.length,
              itemBuilder: (context, index) {
                return _buildRoutineCard(routineCards[index]);
              },
            ),
          ),
          SizedBox(height: 16),
          _buildTodayRoutineButton(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Unknown error occurred',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _retry(),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(RoutineCard card) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: card.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => _handleRoutineCardPress(card),
                style: ElevatedButton.styleFrom(
                  backgroundColor: card.buttonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      card.icon,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      card.buttonText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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

  Widget _buildTodayRoutineButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.patientRoutine);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF9FC3FC),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: Colors.black,
            ),
            SizedBox(width: 12),
            Text(
              'Today Routine',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) { // Patients tab
            // Navigate to detailed patients screen
            Navigator.pushNamed(context, AppRoutes.caregiverDashboard);
          }else if(index==3){
            Navigator.pushNamed(context, AppRoutes.caregiverProfile);
          }
          else if(index==2){
            Navigator.pushNamed(context, AppRoutes.viewArticleList);
          }
          else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2B3F99),
        unselectedItemColor: Color(0xFF2B3F99),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  // Error handling methods
  void _safeNavigateBack(BuildContext context) {
    try {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        // Handle case where there's no previous route
        _showErrorSnackBar('Cannot go back from this screen');
      }
    } catch (e) {
      ErrorHandler.handleError(AppError(
        type: ErrorType.navigation,
        message: 'Failed to navigate back',
        details: e.toString(),
      ));
    }
  }

  void _handleNotifications() {
    try {
      // Implement notification handling with error checking
      print('Notifications clicked');
    } catch (e) {
      ErrorHandler.handleError(AppError(
        type: ErrorType.unknown,
        message: 'Failed to open notifications',
        details: e.toString(),
      ));
    }
  }

  void _handleRoutineCardPress(RoutineCard card) {
    try {
      // Show popup dialog based on card type
      switch (card.title) {
        case 'Daily Activities':
          _showDailyActivitiesDialog();
          break;
        case 'Task Management':
          _showTaskManagementDialog();
          break;
        case 'Medication':
          _showMedicationDialog();
          break;
        case 'Appointment':
          _showAppointmentDialog();
          break;
      }
    } catch (e) {
      ErrorHandler.handleError(AppError(
        type: ErrorType.unknown,
        message: 'Failed to show ${card.title} dialog',
        details: e.toString(),
      ));
    }
  }



  // Dialog methods
  void _showDailyActivitiesDialog() {
    final _formKey = GlobalKey<FormState>();
    final _taskNameController = TextEditingController();
    final _descriptionController = TextEditingController();
    TimeOfDay? _selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.calendar_today, color: Color(0xFF2196F3)),
                  SizedBox(width: 8),
                  Text('Daily Activities'),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Schedule your daily activities and routines.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),

                      // Task Name Field
                      TextFormField(
                        controller: _taskNameController,
                        decoration: InputDecoration(
                          labelText: 'Task Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.task_alt),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a task name';
                          }
                          return null;
                        },
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
                            style: TextStyle(
                              color: _selectedTime != null
                                  ? Colors.black87
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Description Field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description (Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                        maxLength: 200,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _taskNameController.dispose();
                    _descriptionController.dispose();
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a time')),
                        );
                        return;
                      }

                      // Create the activity data
                      final activityData = {
                        'taskName': _taskNameController.text.trim(),
                        'time': _selectedTime!.format(context),
                        'description': _descriptionController.text.trim(),
                      };

                      // Clean up controllers
                      _taskNameController.dispose();
                      _descriptionController.dispose();

                      Navigator.pop(context);

                      // Option 1: Pass data directly via Navigator
                      Navigator.pushNamed(
                        context,
                        Approute.addDailyActivity,
                        arguments: activityData,
                      );

                      // Option 2: If you want to use _safeNavigate, modify it to accept arguments
                      // _safeNavigate(Approute.addDailyActivity, arguments: activityData);
                    }
                  },
                  child: Text('Add Activity'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _showTaskManagementDialog() {
    final _formKey = GlobalKey<FormState>();
    final _descriptionController = TextEditingController();
    String? _selectedGame;
    TimeOfDay? _selectedTime;

    // Dementia patient-related games/activities
    final List<String> _dementiaGames = [
      'Memory Card Matching',
      'Photo Recognition',
      'Simple Puzzle Games',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFE91E63).withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.task_alt, color: Color(0xFFE91E63)),
                          SizedBox(width: 8),
                          Text(
                            'Task Management',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Create and manage your tasks efficiently.',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                              SizedBox(height: 12),

                              // Game/Activity Dropdown
                              DropdownButtonFormField<String>(
                                value: _selectedGame,
                                decoration: InputDecoration(
                                  labelText: 'Game/Activity',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.games, size: 20),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: _dementiaGames.map((String game) {
                                  return DropdownMenuItem<String>(
                                    value: game,
                                    child: Text(game, style: TextStyle(fontSize: 14)),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGame = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a game/activity';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

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
                                    prefixIcon: Icon(Icons.access_time, size: 20),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  child: Text(
                                    _selectedTime != null
                                        ? _selectedTime!.format(context)
                                        : 'Select time',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedTime != null
                                          ? Colors.black87
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),

                              // Description Field
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.description, size: 20),
                                  hintText: 'Add notes...',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                maxLines: 2,
                                maxLength: 100,
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please add a description';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Action Buttons
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _descriptionController.dispose();
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedTime == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please select a time')),
                                  );
                                  return;
                                }

                                // Create the task data
                                final taskData = {
                                  'game': _selectedGame!,
                                  'time': _selectedTime!.format(context),
                                  'description': _descriptionController.text.trim(),
                                  'type': 'dementia_care_task',
                                };

                                // Clean up controllers
                                _descriptionController.dispose();

                                Navigator.pop(context);

                                // Navigate with the collected data
                                Navigator.pushNamed(
                                  context,
                                  Approute.addTask,
                                  arguments: taskData,
                                );
                              }
                            },
                            child: Text('Add Task'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMedicationDialog() {
    final _formKey = GlobalKey<FormState>();
    final _taskNameController = TextEditingController();
    final _medicationNameController = TextEditingController();
    final _roundsController = TextEditingController();
    final _dosageController = TextEditingController();
    final _descriptionController = TextEditingController();
    String? _selectedMealTiming;

    // Meal timing options
    final List<String> _mealTimings = [
      'Before Meal',
      'After Meal',
      'With Meal',
      'Empty Stomach',
      'Anytime',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.medical_services, color: Color(0xFF4CAF50)),
                          SizedBox(width: 8),
                          Text(
                            'Medication Reminders',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Set up medication schedules and reminders.',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                              SizedBox(height: 12),

                              // Task Name Field
                              TextFormField(
                                controller: _taskNameController,
                                decoration: InputDecoration(
                                  labelText: 'Task Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.assignment, size: 20),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a task name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

                              // Medication Name Field
                              TextFormField(
                                controller: _medicationNameController,
                                decoration: InputDecoration(
                                  labelText: 'Medication Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.medication, size: 20),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter medication name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

                              // Number of Rounds Field
                              TextFormField(
                                controller: _roundsController,
                                decoration: InputDecoration(
                                  labelText: 'Number of Rounds (per day)',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.repeat, size: 20),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter number of rounds';
                                  }
                                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

                              // Dosage Field
                              TextFormField(
                                controller: _dosageController,
                                decoration: InputDecoration(
                                  labelText: 'Dosage (e.g., 1 tablet, 5ml)',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.colorize, size: 20),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter dosage';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

                              // Meal Timing Dropdown
                              DropdownButtonFormField<String>(
                                value: _selectedMealTiming,
                                decoration: InputDecoration(
                                  labelText: 'Meal Timing',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.restaurant, size: 20),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: _mealTimings.map((String timing) {
                                  return DropdownMenuItem<String>(
                                    value: timing,
                                    child: Text(timing, style: TextStyle(fontSize: 14)),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedMealTiming = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select meal timing';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

                              // Description Field
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description/Notes',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.description, size: 20),
                                  hintText: 'Special instructions...',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                maxLines: 2,
                                maxLength: 150,
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please add a description';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Action Buttons
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _taskNameController.dispose();
                              _medicationNameController.dispose();
                              _roundsController.dispose();
                              _dosageController.dispose();
                              _descriptionController.dispose();
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Create the medication data
                                final medicationData = {
                                  'taskName': _taskNameController.text.trim(),
                                  'medicationName': _medicationNameController.text.trim(),
                                  'rounds': int.parse(_roundsController.text.trim()),
                                  'dosage': _dosageController.text.trim(),
                                  'mealTiming': _selectedMealTiming!,
                                  'description': _descriptionController.text.trim(),
                                  'type': 'medication_reminder',
                                };

                                // Clean up controllers
                                _taskNameController.dispose();
                                _medicationNameController.dispose();
                                _roundsController.dispose();
                                _dosageController.dispose();
                                _descriptionController.dispose();

                                Navigator.pop(context);

                                // Navigate with the collected data
                                Navigator.pushNamed(
                                  context,
                                  Approute.addMedication,
                                  arguments: medicationData,
                                );
                              }
                            },
                            child: Text('Add Medication'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAppointmentDialog() {
    final _formKey = GlobalKey<FormState>();
    final _taskNameController = TextEditingController();
    final _hospitalController = TextEditingController();
    final _doctorNameController = TextEditingController();
    final _descriptionController = TextEditingController();
    TimeOfDay? _selectedTime;
    DateTime? _selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF44336).withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event, color: Color(0xFFF44336)),
                          SizedBox(width: 8),
                          Text(
                            'Appointments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Schedule and manage your appointments.',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                              SizedBox(height: 12),

                              // Task Name Field
                              TextFormField(
                                controller: _taskNameController,
                                decoration: InputDecoration(
                                  labelText: 'Task Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.assignment, size: 20),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a task name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

                              // Hospital Field
                              TextFormField(
                                controller: _hospitalController,
                                decoration: InputDecoration(
                                  labelText: 'Hospital/Clinic',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.local_hospital, size: 20),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter hospital/clinic name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

                              // Doctor Name Field
                              TextFormField(
                                controller: _doctorNameController,
                                decoration: InputDecoration(
                                  labelText: 'Doctor Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person, size: 20),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter doctor name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

                              // Date Picker
                              InkWell(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(Duration(days: 365)),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedDate = picked;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Date',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today, size: 20),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  child: Text(
                                    _selectedDate != null
                                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                        : 'Select date',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedDate != null
                                          ? Colors.black87
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),

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
                                    prefixIcon: Icon(Icons.access_time, size: 20),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  child: Text(
                                    _selectedTime != null
                                        ? _selectedTime!.format(context)
                                        : 'Select time',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedTime != null
                                          ? Colors.black87
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),

                              // Description Field
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description/Notes',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.description, size: 20),
                                  hintText: 'Appointment details...',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                maxLines: 2,
                                maxLength: 150,
                                style: TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please add a description';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Action Buttons
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _taskNameController.dispose();
                              _hospitalController.dispose();
                              _doctorNameController.dispose();
                              _descriptionController.dispose();
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please select a date')),
                                  );
                                  return;
                                }
                                if (_selectedTime == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please select a time')),
                                  );
                                  return;
                                }

                                // Create the appointment data
                                final appointmentData = {
                                  'taskName': _taskNameController.text.trim(),
                                  'hospital': _hospitalController.text.trim(),
                                  'doctorName': _doctorNameController.text.trim(),
                                  'date': '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                  'time': _selectedTime!.format(context),
                                  'description': _descriptionController.text.trim(),
                                  'type': 'appointment',
                                };

                                // Clean up controllers
                                _taskNameController.dispose();
                                _hospitalController.dispose();
                                _doctorNameController.dispose();
                                _descriptionController.dispose();

                                Navigator.pop(context);

                                // Navigate with the collected data
                                Navigator.pushNamed(
                                  context,
                                  Approute.addAppointment,
                                  arguments: appointmentData,
                                );
                              }
                            },
                            child: Text('Add Appointment'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTodayRoutineDialog() {
    _showCustomDialog(
      title: 'Today\'s Routine',
      content: 'View and manage your routine for today.',
      icon: Icons.today,
      iconColor: Color(0xFF6C9BD1),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigate to today's routine page
            _safeNavigate('/today-routine');
          },
          child: Text('View Routine'),
        ),
      ],
    );
  }

  void _showCustomDialog({
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
    required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          actions: actions,
        );
      },
    );
  }

  void _handleBottomNavigation(int index) {
    try {
      if (index == 0) {
        _safeNavigate(Approute.caregiverDashboard);
      } else if (index == 2) {
        _safeNavigate(Approute.viewArticleList);
      } else if (index == 3) {
        _safeNavigate(Approute.caregiverProfile);
      } else {
        setState(() {
          _currentIndex = index;
        });
      }
    } catch (e) {
      ErrorHandler.handleError(AppError(
        type: ErrorType.navigation,
        message: 'Failed to navigate to tab',
        details: e.toString(),
      ));
    }
  }

  void _safeNavigate(String route) {
    try {
      Navigator.pushNamed(context, route);
    } catch (e) {
      ErrorHandler.handleError(AppError(
        type: ErrorType.navigation,
        message: 'Failed to navigate to $route',
        details: e.toString(),
      ));
      _showErrorSnackBar('Navigation failed. Please try again.');
    }
  }

  // These methods are now replaced by dialog methods above
  // but kept for backward compatibility if needed elsewhere

  void _retry() {
    setState(() {
      _errorMessage = null;
      _isLoading = false;
    });
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// 6. Form Validation Helper
class FormValidator {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateMedicationName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Medication name is required';
    }
    if (value.length < 2) {
      return 'Medication name must be at least 2 characters';
    }
    return null;
  }

  static String? validateDosage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Dosage is required';
    }
    // Add more specific dosage validation
    return null;
  }

  static String? validateRounds(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Number of rounds is required';
    }
    final rounds = int.tryParse(value);
    if (rounds == null || rounds <= 0) {
      return 'Please enter a valid number of rounds';
    }
    return null;
  }

  static String? validateTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Time is required';
    }
    // Add time format validation
    return null;
  }
}

// 7. Network Error Handling
class NetworkService {
  static Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on SocketException {
      throw AppError(
        type: ErrorType.network,
        message: 'No internet connection',
        details: 'Please check your network connection and try again',
      );
    } on TimeoutException {
      throw AppError(
        type: ErrorType.network,
        message: 'Request timeout',
        details: 'The request took too long to complete',
      );
    } on HttpException catch (e) {
      throw AppError(
        type: ErrorType.network,
        message: 'Server error',
        details: e.message,
      );
    } catch (e) {
      throw AppError(
        type: ErrorType.unknown,
        message: 'Unexpected error occurred',
        details: e.toString(),
      );
    }
  }
}

// 8. Usage Example for Form Screens
class AddMedicationScreen extends StatefulWidget {
  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _medicationController = TextEditingController();
  final _roundsController = TextEditingController();
  final _dosageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedMealTiming;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize error handler with context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ErrorHandler.initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _safeNavigateBack(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Task Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 16),

                      TextFormField(
                        controller: _taskController,
                        decoration: InputDecoration(
                          labelText: 'Task',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => FormValidator.validateRequired(value, 'Task'),
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        controller: _medicationController,
                        decoration: InputDecoration(
                          labelText: 'Medication Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormValidator.validateMedicationName,
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        controller: _roundsController,
                        decoration: InputDecoration(
                          labelText: 'No of rounds',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: FormValidator.validateRounds,
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        controller: _dosageController,
                        decoration: InputDecoration(
                          labelText: 'Dosage',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormValidator.validateDosage,
                      ),
                      SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedMealTiming,
                        decoration: InputDecoration(
                          labelText: 'Before/After Meal',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Before Meal', 'After Meal'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMealTiming = value;
                          });
                        },
                        validator: (value) => FormValidator.validateRequired(value, 'Meal timing'),
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAdd,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Add'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _handleSaveDraft,
                      child: Text('Save Draft'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _safeNavigateBack() {
    try {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      ErrorHandler.handleError(AppError(
        type: ErrorType.navigation,
        message: 'Failed to navigate back',
        details: e.toString(),
      ));
    }
  }

  void _handleAdd() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await NetworkService.safeApiCall(() async {
          // Simulate API call
          await Future.delayed(Duration(seconds: 2));

          // Add your actual API call here
          print('Adding medication...');
        });

        if (mounted) {
          _showSuccessSnackBar('Medication added successfully!');
          Navigator.pop(context);
        }
      } catch (e) {
        if (e is AppError) {
          ErrorHandler.handleError(e);
        } else {
          ErrorHandler.handleError(AppError(
            type: ErrorType.unknown,
            message: 'Failed to add medication',
            details: e.toString(),
          ));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _handleSaveDraft() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await NetworkService.safeApiCall(() async {
        // Simulate saving draft
        await Future.delayed(Duration(seconds: 1));
        print('Saving draft...');
      });

      if (mounted) {
        _showSuccessSnackBar('Draft saved successfully!');
      }
    } catch (e) {
      if (e is AppError) {
        ErrorHandler.handleError(e);
      } else {
        ErrorHandler.handleError(AppError(
          type: ErrorType.unknown,
          message: 'Failed to save draft',
          details: e.toString(),
        ));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _medicationController.dispose();
    _roundsController.dispose();
    _dosageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import '../../services/daily_activity_service.dart' as DailyActivityAPI;
import '../../services/game_service.dart' as GameAPI;
import '../../services/task_service.dart' as TaskAPI;
import '../../services/medication_service.dart' as MedicationAPI;
import '../../services/appointment_service.dart';
import '../../services/schedule_service.dart' as ScheduleAPI;
import '../../models/medication_reminder.dart';
import '../../models/api_result.dart' as Models;

// 1. Error Types and Models
enum ErrorType { network, validation, navigation, storage, permission, unknown }

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
    _showSnackBar(
      'No internet connection. Please check your network.',
      Colors.red,
    );
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
    _showSnackBar(
      'Permission denied. Please grant required permissions.',
      Colors.red,
    );
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
  final int? patientId;

  const SelectTypeWithErrorHandling({Key? key, this.patientId}) : super(key: key);

  @override
  _SelectTypeWithErrorHandlingState createState() =>
      _SelectTypeWithErrorHandlingState();
}

class _SelectTypeWithErrorHandlingState
    extends State<SelectTypeWithErrorHandling> {
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
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
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
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
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
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(onPressed: () => _retry(), child: Text('Retry')),
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
                    Icon(card.icon, size: 18, color: Colors.white),
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
            Icon(Icons.calendar_today, size: 20, color: AppColors.primaryDark),
            SizedBox(width: 12),
            Text(
              'Today Routine',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
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
          if (index == 0) {
            // Patients tab
            // Navigate to detailed patients screen
            Navigator.pushNamed(context, AppRoutes.caregiverDashboard);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.caregiverProfile);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.viewArticleList);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2B3F99),
        unselectedItemColor: Color(0xFF2B3F99),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
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
      ErrorHandler.handleError(
        AppError(
          type: ErrorType.navigation,
          message: 'Failed to navigate back',
          details: e.toString(),
        ),
      );
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
      ErrorHandler.handleError(
        AppError(
          type: ErrorType.unknown,
          message: 'Failed to show ${card.title} dialog',
          details: e.toString(),
        ),
      );
    }
  }

  // Dialog methods
  void _showDailyActivitiesDialog() {
    final _formKey = GlobalKey<FormState>();
    final _taskNameController = TextEditingController();
    final _descriptionController = TextEditingController();
    DateTime _selectedDate = DateTime.now(); // Default to today
    TimeOfDay? _selectedTime;
    bool _isSubmitting = false;

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

                      // Date Picker
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xFF2196F3),
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: child!,
                              );
                            },
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
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
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
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedTime == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select a time')),
                              );
                              return;
                            }

                            setState(() {
                              _isSubmitting = true;
                            });

                            try {
                              // First, check if patient ID is available
                              if (widget.patientId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Patient information not available'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                setState(() {
                                  _isSubmitting = false;
                                });
                                return;
                              }

                              // Format date as YYYY-MM-DD
                              String dateString =
                                  '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

                              // Get or create schedule for the selected date
                              final scheduleResult =
                                  await ScheduleAPI.ScheduleService.getOrCreateSchedule(
                                widget.patientId!,
                                dateString,
                              );

                              if (!scheduleResult.success || scheduleResult.data == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to get schedule: ${scheduleResult.message}',
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                setState(() {
                                  _isSubmitting = false;
                                });
                                return;
                              }

                              final scheduleData = scheduleResult.data as Map<String, dynamic>;
                              final scheduleId = scheduleData['scheduleId'] as int;

                              // Format time as HH:mm
                              String timeString =
                                  '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

                              // Create request
                              DailyActivityAPI.DailyActivityRequest request =
                                  DailyActivityAPI.DailyActivityRequest(
                                    taskName: _taskNameController.text.trim(),
                                    time: timeString,
                                    description:
                                        _descriptionController.text
                                            .trim()
                                            .isNotEmpty
                                        ? _descriptionController.text.trim()
                                        : null,
                                  );

                              // Make API call
                              DailyActivityAPI.ApiResult<
                                DailyActivityAPI.DailyActivity
                              >
                              result =
                                  await DailyActivityAPI
                                      .DailyActivityService.addDailyActivity(
                                    scheduleId,
                                    request,
                                  );

                              if (result.success && result.data != null) {
                                // Close dialog first
                                Navigator.pop(context);

                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Daily activity added successfully!',
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result.message),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to add daily activity. Please try again.',
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              print('Error adding daily activity: $e');
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isSubmitting = false;
                                });
                              }
                            }
                          }
                        },
                  child: _isSubmitting
                      ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text('Add Activity'),
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
    DateTime _selectedDate = DateTime.now(); // Default to today
    TimeOfDay? _selectedTime;
    List<GameAPI.Game> _games = [];
    bool _loadingGames = true;
    String? _gamesError;

    // Function to load games from database
    Future<void> _loadGames() async {
      try {
        final result = await GameAPI.GameService.getAllGames();
        if (result.success && result.data != null) {
          _games = result.data!;
          _loadingGames = false;
          _gamesError = null;
        } else {
          _gamesError = result.message;
          _loadingGames = false;
        }
      } catch (e) {
        _gamesError = 'Failed to load games: $e';
        _loadingGames = false;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Load games when dialog opens
            if (_loadingGames && _games.isEmpty) {
              _loadGames().then((_) {
                setState(() {});
              });
            }

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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 12),

                              // Game/Activity Dropdown
                              _loadingGames
                                  ? Container(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text('Loading games...'),
                                        ],
                                      ),
                                    )
                                  : _gamesError != null
                                  ? Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.red.shade200,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Failed to load games',
                                            style: TextStyle(
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _loadingGames = true;
                                                _gamesError = null;
                                              });
                                              _loadGames().then((_) {
                                                setState(() {});
                                              });
                                            },
                                            child: Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : DropdownButtonFormField<String>(
                                      value: _selectedGame,
                                      decoration: InputDecoration(
                                        labelText: 'Game/Activity',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.games, size: 20),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                      items: _games.map((GameAPI.Game game) {
                                        return DropdownMenuItem<String>(
                                          value: game.name,
                                          child: Text(
                                            game.name,
                                            style: TextStyle(fontSize: 14),
                                          ),
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

                              // Date Picker
                              InkWell(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Color(0xFFE91E63),
                                            onPrimary: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
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
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: Text(
                                    '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),

                              // Time Picker
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
                                    prefixIcon: Icon(
                                      Icons.access_time,
                                      size: 20,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedTime == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select a time'),
                                    ),
                                  );
                                  return;
                                }

                                if (_selectedGame == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select a game'),
                                    ),
                                  );
                                  return;
                                }

                                // Show loading indicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Row(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(width: 20),
                                          Text('Creating task...'),
                                        ],
                                      ),
                                    );
                                  },
                                );

                                try {
                                  // First, check if patient ID is available
                                  if (widget.patientId == null) {
                                    Navigator.pop(context); // Close loading dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Patient information not available'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  // Format date as YYYY-MM-DD
                                  String dateString =
                                      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

                                  // Get or create schedule for the selected date
                                  final scheduleResult =
                                      await ScheduleAPI.ScheduleService.getOrCreateSchedule(
                                    widget.patientId!,
                                    dateString,
                                  );

                                  if (!scheduleResult.success || scheduleResult.data == null) {
                                    Navigator.pop(context); // Close loading dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to get schedule: ${scheduleResult.message}',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  final scheduleData = scheduleResult.data as Map<String, dynamic>;
                                  final scheduleId = scheduleData['scheduleId'] as int;

                                  // Format time as HH:mm for the backend
                                  String timeString =
                                      '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

                                  // Call the TaskService to create the task
                                  final result =
                                      await TaskAPI.TaskService.createTask(
                                        scheduleId: scheduleId,
                                        gameName: _selectedGame!,
                                        time: timeString,
                                      );

                                  // Close loading dialog
                                  Navigator.pop(context);

                                  if (result.success) {
                                    // Clean up controllers
                                    _descriptionController.dispose();

                                    // Close task creation dialog
                                    Navigator.pop(context);

                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Task created successfully!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    print(
                                      'Task created: ${result.data?.toJson()}',
                                    );
                                  } else {
                                    // Show error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to create task: ${result.message}',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  // Close loading dialog
                                  Navigator.pop(context);

                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error creating task: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
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
    final _medicationNameController = TextEditingController();
    final _dosageController = TextEditingController();
    final _descriptionController = TextEditingController();

    // Create dedicated controllers for date fields
    final _fromDateController = TextEditingController();
    final _dueDateController = TextEditingController();

    String? _selectedMealTiming;
    TimeOfDay? _selectedTime;
    DateTime? _fromDate;
    DateTime? _dueDate;
    bool _isSubmitting = false;

    // Meal timing options
    final List<String> _mealTimings = [
      'Before Meal',
      'After Meal',
      'With Meal',
      'Empty Stomach',
      'Anytime',
    ];

    // Helper function to format date
    String _formatDate(DateTime date) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    // Helper function to format date for display
    String _formatDateDisplay(DateTime date) {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }

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
                          Icon(
                            Icons.medical_services,
                            color: Color(0xFF4CAF50),
                          ),
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 16),

                              // Medication Name Field
                              TextFormField(
                                controller: _medicationNameController,
                                decoration: InputDecoration(
                                  labelText: 'Medication Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.medication, size: 20),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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

                              // Dosage Field
                              TextFormField(
                                controller: _dosageController,
                                decoration: InputDecoration(
                                  labelText: 'Dosage (e.g., 1 tablet, 5ml)',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.colorize, size: 20),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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

                              // From Date Picker
                              TextFormField(
                                controller: _fromDateController,
                                decoration: InputDecoration(
                                  labelText: 'From Date',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.date_range, size: 20),
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                style: TextStyle(fontSize: 14),
                                readOnly: true,
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _fromDate ?? DateTime.now(),
                                    firstDate: DateTime.now().subtract(
                                      Duration(days: 365),
                                    ),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 365 * 2),
                                    ),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _fromDate = picked;
                                      _fromDateController.text =
                                          _formatDateDisplay(picked);
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (_fromDate == null) {
                                    return 'Please select from date';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12),

                              // Due Date Picker
                              TextFormField(
                                controller: _dueDateController,
                                decoration: InputDecoration(
                                  labelText: 'Due Date',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.event, size: 20),
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                style: TextStyle(fontSize: 14),
                                readOnly: true,
                                onTap: () async {
                                  DateTime initialDate =
                                      _dueDate ?? DateTime.now();

                                  // If from date is selected, due date should be after from date
                                  if (_fromDate != null &&
                                      initialDate.isBefore(_fromDate!)) {
                                    initialDate = _fromDate!;
                                  }

                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: initialDate,
                                    firstDate: _fromDate ?? DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 365 * 2),
                                    ),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _dueDate = picked;
                                      _dueDateController.text =
                                          _formatDateDisplay(picked);
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (_dueDate == null) {
                                    return 'Please select due date';
                                  }
                                  if (_fromDate != null &&
                                      _dueDate!.isBefore(_fromDate!)) {
                                    return 'Due date must be after from date';
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: _mealTimings.map((String timing) {
                                  return DropdownMenuItem<String>(
                                    value: timing,
                                    child: Text(
                                      timing,
                                      style: TextStyle(fontSize: 14),
                                    ),
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

                              // Time Picker
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Time',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.access_time, size: 20),
                                  suffixIcon: Icon(Icons.schedule, size: 20),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                style: TextStyle(fontSize: 14),
                                readOnly: true,
                                controller: TextEditingController(
                                  text: _selectedTime != null
                                      ? _selectedTime!.format(context)
                                      : '',
                                ),
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
                                validator: (value) {
                                  if (_selectedTime == null) {
                                    return 'Please select time';
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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
                            onPressed: _isSubmitting
                                ? null
                                : () {
                                    // Dispose controllers
                                    _medicationNameController.dispose();
                                    _dosageController.dispose();
                                    _descriptionController.dispose();
                                    _fromDateController.dispose();
                                    _dueDateController.dispose();
                                    Navigator.pop(context);
                                  },
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isSubmitting = true;
                                      });

                                      try {
                                        // Format time as HH:mm
                                        String timeString =
                                            '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

                                        // Format dates for API (YYYY-MM-DD)
                                        String fromDateString =
                                            _fromDate != null
                                            ? _formatDate(_fromDate!)
                                            : '';
                                        String dueDateString = _dueDate != null
                                            ? _formatDate(_dueDate!)
                                            : '';

                                        print('Medication Data:');
                                        print(
                                          'Medication: ${_medicationNameController.text.trim()}',
                                        );
                                        print(
                                          'Dosage: ${_dosageController.text.trim()}',
                                        );
                                        print('From Date: $fromDateString');
                                        print('Due Date: $dueDateString');
                                        print(
                                          'Meal Timing: $_selectedMealTiming',
                                        );
                                        print('Time: $timeString');
                                        print(
                                          'Description: ${_descriptionController.text.trim()}',
                                        );

                                        // Check if patient ID is available
                                        if (widget.patientId == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Patient information not available'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          setState(() {
                                            _isSubmitting = false;
                                          });
                                          return;
                                        }

                                        // Use from date as the schedule date (default to today if not set)
                                        DateTime scheduleDate = _fromDate ?? DateTime.now();
                                        String scheduleDateString =
                                            '${scheduleDate.year}-${scheduleDate.month.toString().padLeft(2, '0')}-${scheduleDate.day.toString().padLeft(2, '0')}';

                                        // Get or create schedule for the date
                                        final scheduleResult =
                                            await ScheduleAPI.ScheduleService.getOrCreateSchedule(
                                          widget.patientId!,
                                          scheduleDateString,
                                        );

                                        if (!scheduleResult.success || scheduleResult.data == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to get schedule: ${scheduleResult.message}',
                                              ),
                                              backgroundColor: Colors.red,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                          setState(() {
                                            _isSubmitting = false;
                                          });
                                          return;
                                        }

                                        final scheduleData = scheduleResult.data as Map<String, dynamic>;
                                        final scheduleId = scheduleData['scheduleId'] as int;

                                        MedicationReminderRequest
                                        medicationRequest =
                                            MedicationReminderRequest(
                                              medicationName:
                                                  _medicationNameController.text
                                                      .trim(),
                                              dosage: _dosageController.text
                                                  .trim(),
                                              mealTiming:
                                                  _selectedMealTiming ?? '',
                                              description:
                                                  _descriptionController.text
                                                      .trim(),
                                              time: timeString,
                                              patientId: widget.patientId!,
                                              fromDate: fromDateString,
                                              dueDate: dueDateString,
                                            );

                                        Models.ApiResult<MedicationReminder>
                                        result =
                                            await MedicationAPI
                                                .MedicationService.createMedicationReminder(
                                              scheduleId,
                                              medicationRequest,
                                            );

                                        print(
                                          'API Response: success=${result.success}, message=${result.message}, data=${result.data}',
                                        );

                                        if (result.success &&
                                            result.data != null) {
                                          Navigator.pop(
                                            context,
                                          ); // Close dialog
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Medication reminder added successfully!',
                                              ),
                                              backgroundColor: Colors.green,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        } else {
                                          print(
                                            'DEBUG: Medication API request: ${medicationRequest.toJson()}',
                                          );
                                          print(
                                            'DEBUG: Medication API error message: ${result.message}',
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                result.message.isNotEmpty
                                                    ? result.message
                                                    : 'Failed to add medication reminder.',
                                              ),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        print('Error adding medication: $e');
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Failed to add medication reminder. Please try again.',
                                            ),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            _isSubmitting = false;
                                          });
                                        }
                                      }
                                    }
                                  },
                            child: _isSubmitting
                                ? SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text('Add Medication'),
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 12),

                              // Task Name Field
                              TextFormField(
                                controller: _taskNameController,
                                decoration: InputDecoration(
                                  labelText: 'Task Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.assignment, size: 20),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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
                                  prefixIcon: Icon(
                                    Icons.local_hospital,
                                    size: 20,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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
                                    initialDate:
                                        _selectedDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 365),
                                    ),
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
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
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
                                    prefixIcon: Icon(
                                      Icons.access_time,
                                      size: 20,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select a date'),
                                    ),
                                  );
                                  return;
                                }
                                if (_selectedTime == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select a time'),
                                    ),
                                  );
                                  return;
                                }

                                // Show loading indicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );

                                try {
                                  // Check if patient ID is available
                                  if (widget.patientId == null) {
                                    Navigator.pop(context); // Close loading dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Patient information not available'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  // Format date for backend (YYYY-MM-DD)
                                  String formattedDate =
                                      '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

                                  // Get or create schedule for the selected date
                                  final scheduleResult =
                                      await ScheduleAPI.ScheduleService.getOrCreateSchedule(
                                    widget.patientId!,
                                    formattedDate,
                                  );

                                  if (!scheduleResult.success || scheduleResult.data == null) {
                                    Navigator.pop(context); // Close loading dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to get schedule: ${scheduleResult.message}',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  final scheduleData = scheduleResult.data as Map<String, dynamic>;
                                  final scheduleId = scheduleData['scheduleId'] as int;

                                  // Format time for backend (HH:mm)
                                  String formattedTime =
                                      '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

                                  // Create appointment
                                  AppointmentRequest appointmentRequest = AppointmentRequest(
                                    taskName: _taskNameController.text.trim(),
                                    hospital: _hospitalController.text.trim(),
                                    doctorName: _doctorNameController.text.trim(),
                                    description: _descriptionController.text.trim(),
                                    date: formattedDate,
                                    time: formattedTime,
                                  );

                                  final result =
                                      await AppointmentService.createAppointment(
                                        scheduleId,
                                        appointmentRequest,
                                      );

                                  // Hide loading indicator
                                  Navigator.pop(context);

                                  if (result.success) {
                                    // Close dialog
                                    Navigator.pop(context);

                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Appointment created successfully!',
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    // Show error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          result.message.isNotEmpty
                                              ? result.message
                                              : 'Failed to create appointment',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  // Hide loading indicator
                                  Navigator.pop(context);

                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
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
  int? selectedPatientId;
  String? selectedFromDate;
  String? selectedDueDate;
  String? selectedTime;
  final _formKey = GlobalKey<FormState>();
  final _medicationController = TextEditingController();
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
                      Text(
                        'Task Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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
                        items: ['Before Meal', 'After Meal'].map((
                          String value,
                        ) {
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
                        validator: (value) => FormValidator.validateRequired(
                          value,
                          'Meal timing',
                        ),
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
                      SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: selectedPatientId,
                        decoration: InputDecoration(
                          labelText: 'Patient',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(value: 1, child: Text('Patient 1')),
                          DropdownMenuItem(value: 2, child: Text('Patient 2')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedPatientId = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select a patient' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'From Date',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: selectedFromDate ?? '',
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedFromDate = picked
                                  .toIso8601String()
                                  .substring(0, 10);
                            });
                          }
                        },
                        validator: (value) =>
                            (selectedFromDate == null ||
                                selectedFromDate!.isEmpty)
                            ? 'Select from date'
                            : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: selectedDueDate ?? '',
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDueDate = picked
                                  .toIso8601String()
                                  .substring(0, 10);
                            });
                          }
                        },
                        validator: (value) =>
                            (selectedDueDate == null ||
                                selectedDueDate!.isEmpty)
                            ? 'Select due date'
                            : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: selectedTime ?? '',
                        ),
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedTime = picked.format(context);
                            });
                          }
                        },
                        validator: (value) =>
                            (selectedTime == null || selectedTime!.isEmpty)
                            ? 'Select time'
                            : null,
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
      ErrorHandler.handleError(
        AppError(
          type: ErrorType.navigation,
          message: 'Failed to navigate back',
          details: e.toString(),
        ),
      );
    }
  }

  void _handleAdd() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validate patientId, fromDate, dueDate, and time
      if ((selectedPatientId ?? 0) == 0) {
        ErrorHandler.handleError(
          AppError(
            type: ErrorType.validation,
            message: 'Please select a valid patient.',
          ),
        );
        return;
      }
      if ((selectedFromDate ?? '').isEmpty) {
        ErrorHandler.handleError(
          AppError(
            type: ErrorType.validation,
            message: 'Please select a valid from date.',
          ),
        );
        return;
      }
      if ((selectedDueDate ?? '').isEmpty) {
        ErrorHandler.handleError(
          AppError(
            type: ErrorType.validation,
            message: 'Please select a valid due date.',
          ),
        );
        return;
      }
      if ((selectedTime ?? '').isEmpty) {
        ErrorHandler.handleError(
          AppError(
            type: ErrorType.validation,
            message: 'Please select a valid time.',
          ),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        // Build MedicationReminderRequest
        // Format time as HH:mm:ss for backend
        String formattedTime = '';
        if (selectedTime != null && selectedTime!.isNotEmpty) {
          // If selectedTime is already in HH:mm, add :00 for seconds
          if (RegExp(r'^\d{2}:\d{2}$').hasMatch(selectedTime!)) {
            formattedTime = selectedTime! + ':00';
          } else {
            formattedTime = selectedTime!;
          }
        }
        MedicationReminderRequest request = MedicationReminderRequest(
          medicationName: _medicationController.text,
          dosage: _dosageController.text,
          mealTiming: _selectedMealTiming ?? '',
          description: _descriptionController.text,
          time: formattedTime,
          patientId: selectedPatientId ?? 0,
          fromDate: selectedFromDate ?? '',
          dueDate: selectedDueDate ?? '',
        );
        // Call your API here
        final result =
            await MedicationAPI.MedicationService.createMedicationReminder(
              1, // TODO: Replace with actual scheduleId
              request,
            );
        if (result.success) {
          if (mounted) {
            _showSuccessSnackBar('Medication added successfully!');
            Navigator.pop(context);
          }
        } else {
          ErrorHandler.handleError(
            AppError(type: ErrorType.unknown, message: result.message),
          );
        }
        if (mounted) {
          _showSuccessSnackBar('Medication added successfully!');
          Navigator.pop(context);
        }
      } catch (e) {
        if (e is AppError) {
          ErrorHandler.handleError(e);
        } else {
          ErrorHandler.handleError(
            AppError(
              type: ErrorType.unknown,
              message: 'Failed to add medication',
              details: e.toString(),
            ),
          );
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
        ErrorHandler.handleError(
          AppError(
            type: ErrorType.unknown,
            message: 'Failed to save draft',
            details: e.toString(),
          ),
        );
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
    _medicationController.dispose();
    _dosageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

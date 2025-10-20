import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';
import '../../services/game_service.dart' as GameAPI;
import '../../models/patient_profile.dart';
import 'package:intl/intl.dart';

/// Patient Task Selection Screen
/// Shows task creation options based on patient's dementia stage
/// MILD/MODERATE: Can add all 4 task types
/// SEVERE/VERY_SEVERE: Can only add Daily Activities and Games
class PatientTaskSelectionScreen extends StatefulWidget {
  const PatientTaskSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PatientTaskSelectionScreen> createState() => _PatientTaskSelectionScreenState();
}

class _PatientTaskSelectionScreenState extends State<PatientTaskSelectionScreen> {
  PatientProfile? patientProfile;
  int? patientId;
  bool isLoading = true;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the selected date from route arguments
    if (selectedDate == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is DateTime) {
        selectedDate = args;
      } else {
        selectedDate = DateTime.now();
      }
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Future<void> _loadPatientData() async {
    try {
      final userId = await AuthService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final fetchedPatientId = await PatientService.getPatientIdByUserId(userId);
      if (fetchedPatientId == null) {
        throw Exception('Patient ID not found');
      }
      
      final profile = await PatientService.getPatientProfile(fetchedPatientId);

      setState(() {
        patientId = fetchedPatientId;
        patientProfile = profile;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading patient data: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load patient data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Add Task',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (patientProfile == null || patientId == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Add Task',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Failed to load patient profile'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Task',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Daily Activity - Available for all stages
            _buildTaskCard(
              title: 'Daily Activities',
              buttonText: 'Add Daily Activity',
              backgroundColor: const Color(0xFFE3F2FD),
              buttonColor: const Color(0xFF2196F3),
              icon: Icons.calendar_today,
              onTap: () => _showDailyActivityDialog(),
            ),
            const SizedBox(height: 16),

            // Play Game - Available for all stages
            _buildTaskCard(
              title: 'Play Game',
              buttonText: 'Schedule a Game',
              backgroundColor: const Color(0xFFF3E5F5),
              buttonColor: const Color(0xFF9C27B0),
              icon: Icons.games,
              onTap: () => _showGameTaskDialog(),
            ),
            const SizedBox(height: 16),

            // Medication - Only for MILD/MODERATE
            if (patientProfile!.canAddAllTaskTypes)
              _buildTaskCard(
                title: 'Medication',
                buttonText: 'Add Medication Reminder',
                backgroundColor: const Color(0xFFE8F5E9),
                buttonColor: const Color(0xFF4CAF50),
                icon: Icons.medication,
                onTap: () => _showMedicationDialog(),
              ),
            if (patientProfile!.canAddAllTaskTypes) const SizedBox(height: 16),

            // Appointment - Only for MILD/MODERATE
            if (patientProfile!.canAddAllTaskTypes)
              _buildTaskCard(
                title: 'Appointment',
                buttonText: 'Schedule Appointment',
                backgroundColor: const Color(0xFFFFEBEE),
                buttonColor: const Color(0xFFF44336),
                icon: Icons.event,
                onTap: () => _showAppointmentDialog(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String buttonText,
    required Color backgroundColor,
    required Color buttonColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      buttonText,
                      style: const TextStyle(
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

  // ==================== DAILY ACTIVITY DIALOG ====================
  void _showDailyActivityDialog() {
    final formKey = GlobalKey<FormState>();
    final taskNameController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime dialogSelectedDate = selectedDate ?? DateTime.now();
    TimeOfDay? selectedTime;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.calendar_today, color: Color(0xFF2196F3)),
                  SizedBox(width: 8),
                  Text('Add Daily Activity'),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Schedule your daily activities and routines.',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),

                        // Activity Name
                        TextFormField(
                          controller: taskNameController,
                          decoration: const InputDecoration(
                            labelText: 'Activity Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.task_alt),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an activity name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Date Picker
                        InkWell(
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: dialogSelectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                dialogSelectedDate = pickedDate;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(dialogSelectedDate),
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Time Picker
                        InkWell(
                          onTap: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                selectedTime = pickedTime;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            child: Text(
                              selectedTime != null
                                  ? selectedTime!.format(context)
                                  : 'Select time',
                              style: TextStyle(
                                color: selectedTime != null
                                    ? Colors.black87
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
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
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                          // Dispose after dialog is closed
                          Future.microtask(() {
                            taskNameController.dispose();
                            descriptionController.dispose();
                          });
                        },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            if (selectedTime == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a time'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            setState(() {
                              isSubmitting = true;
                            });

                            try {
                              // Call API to create daily activity
                              final taskData = {
                                'taskType': 'DAILY_ACTIVITY',
                                'title': taskNameController.text.trim(),
                                'date': DateFormat('yyyy-MM-dd').format(dialogSelectedDate),
                                'time': '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                                if (descriptionController.text.trim().isNotEmpty)
                                  'description': descriptionController.text.trim(),
                              };

                              await PatientService.createTask(patientId!, taskData);

                              if (mounted) {
                                Navigator.pop(dialogContext);
                                Navigator.pop(context, true); // Go back to dashboard with refresh signal
                                
                                // Dispose after navigation completes
                                Future.delayed(const Duration(milliseconds: 300), () {
                                  taskNameController.dispose();
                                  descriptionController.dispose();
                                });
                                
                                // Show confirmation with date
                                final String dateMessage = _isToday(dialogSelectedDate) 
                                    ? 'today' 
                                    : 'on ${DateFormat('MMM d').format(dialogSelectedDate)}';
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Daily activity added successfully for $dateMessage!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                Navigator.pop(dialogContext);
                                
                                // Dispose after dialog closes
                                Future.delayed(const Duration(milliseconds: 300), () {
                                  taskNameController.dispose();
                                  descriptionController.dispose();
                                });
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Add Activity'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==================== GAME TASK DIALOG ====================
  void _showGameTaskDialog() {
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    GameAPI.Game? selectedGame;
    DateTime dialogSelectedDate = selectedDate ?? DateTime.now();
    TimeOfDay? selectedTime;
    List<GameAPI.Game> games = [];
    bool loadingGames = true;
    String? gamesError;
    bool isSubmitting = false;

    // Load games from database
    Future<void> loadGames() async {
      try {
        final result = await GameAPI.GameService.getAllGames();
        if (result.success && result.data != null) {
          games = result.data!;
          loadingGames = false;
          gamesError = null;
        } else {
          gamesError = result.message;
          loadingGames = false;
        }
      } catch (e) {
        gamesError = 'Failed to load games: $e';
        loadingGames = false;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Load games when dialog opens
            if (loadingGames && games.isEmpty) {
              loadGames().then((_) {
                setState(() {});
              });
            }

            return Dialog(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9C27B0).withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.games, color: Color(0xFF9C27B0)),
                          SizedBox(width: 8),
                          Text(
                            'Schedule a Game',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Text(
                                'Choose a game to schedule for later.',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 16),

                              // Game Dropdown
                              if (loadingGames)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (gamesError != null)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline, color: Colors.red[700]),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          gamesError!,
                                          style: TextStyle(color: Colors.red[700]),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                DropdownButtonFormField<GameAPI.Game>(
                                  value: selectedGame,
                                  decoration: const InputDecoration(
                                    labelText: 'Select Game',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.sports_esports),
                                  ),
                                  items: games.map((game) {
                                    return DropdownMenuItem(
                                      value: game,
                                      child: Text(game.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGame = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a game';
                                    }
                                    return null;
                                  },
                                ),
                              const SizedBox(height: 16),

                              // Date Picker
                              InkWell(
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: dialogSelectedDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      dialogSelectedDate = pickedDate;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Date',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(dialogSelectedDate),
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Time Picker
                              InkWell(
                                onTap: () async {
                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTime ?? TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      selectedTime = pickedTime;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Time',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.access_time),
                                  ),
                                  child: Text(
                                    selectedTime != null
                                        ? selectedTime!.format(context)
                                        : 'Select time',
                                    style: TextStyle(
                                      color: selectedTime != null
                                          ? Colors.black87
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Description
                              TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Notes (Optional)',
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
                    ),

                    // Actions
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    Navigator.pop(dialogContext);
                                    // Dispose after dialog is closed
                                    Future.microtask(() {
                                      descriptionController.dispose();
                                    });
                                  },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      if (selectedTime == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Please select a time'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() {
                                        isSubmitting = true;
                                      });

                                      try {
                                        // Call API to create game task
                                        final taskData = {
                                          'taskType': 'GAME',
                                          'title': selectedGame!.name,
                                          'date': DateFormat('yyyy-MM-dd').format(dialogSelectedDate),
                                          'time': '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                                          'gameId': selectedGame!.gameId,
                                          if (descriptionController.text.trim().isNotEmpty)
                                            'description': descriptionController.text.trim(),
                                        };

                                        await PatientService.createTask(patientId!, taskData);

                                        if (mounted) {
                                          Navigator.pop(dialogContext);
                                          Navigator.pop(context, true);
                                          
                                          // Dispose after navigation completes
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            descriptionController.dispose();
                                          });
                                          
                                          // Show confirmation with date
                                          final String dateMessage = _isToday(dialogSelectedDate) 
                                              ? 'today' 
                                              : 'on ${DateFormat('MMM d').format(dialogSelectedDate)}';
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Game scheduled successfully for $dateMessage!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          Navigator.pop(dialogContext);
                                          
                                          // Dispose after dialog closes
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            descriptionController.dispose();
                                          });
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: ${e.toString()}'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Schedule Game'),
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

  // ==================== MEDICATION DIALOG ====================
  void _showMedicationDialog() {
    final formKey = GlobalKey<FormState>();
    final medicationNameController = TextEditingController();
    final dosageController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedMealTiming;
    TimeOfDay? selectedTime;
    DateTime fromDate = selectedDate ?? DateTime.now();
    DateTime dueDate = (selectedDate ?? DateTime.now()).add(const Duration(days: 7));
    bool isSubmitting = false;

    final mealTimings = [
      'Before Meal',
      'After Meal',
      'With Meal',
      'Empty Stomach',
      'Anytime',
    ];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.medication, color: Color(0xFF4CAF50)),
                          SizedBox(width: 8),
                          Text(
                            'Add Medication Reminder',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              // Medication Name
                              TextFormField(
                                controller: medicationNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Medication Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.medical_services),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter medication name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Dosage
                              TextFormField(
                                controller: dosageController,
                                decoration: const InputDecoration(
                                  labelText: 'Dosage',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.monitor_weight),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter dosage';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Meal Timing
                              DropdownButtonFormField<String>(
                                value: selectedMealTiming,
                                decoration: const InputDecoration(
                                  labelText: 'Meal Timing',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.restaurant),
                                ),
                                items: mealTimings.map((timing) {
                                  return DropdownMenuItem(
                                    value: timing,
                                    child: Text(timing),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMealTiming = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select meal timing';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Time Picker
                              InkWell(
                                onTap: () async {
                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTime ?? TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      selectedTime = pickedTime;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Time',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.access_time),
                                  ),
                                  child: Text(
                                    selectedTime != null
                                        ? selectedTime!.format(context)
                                        : 'Select time',
                                    style: TextStyle(
                                      color: selectedTime != null
                                          ? Colors.black87
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // From Date
                              InkWell(
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: fromDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      fromDate = pickedDate;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'From Date',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(fromDate),
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Due Date
                              InkWell(
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: dueDate,
                                    firstDate: fromDate,
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      dueDate = pickedDate;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Due Date',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.event),
                                  ),
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(dueDate),
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Description
                              TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
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
                    ),

                    // Actions
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    Navigator.pop(dialogContext);
                                    // Dispose after dialog is closed
                                    Future.microtask(() {
                                      medicationNameController.dispose();
                                      dosageController.dispose();
                                      descriptionController.dispose();
                                    });
                                  },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      if (selectedTime == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Please select a time'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() {
                                        isSubmitting = true;
                                      });

                                      try {
                                        // Call API to create medication reminder
                                        final taskData = {
                                          'taskType': 'MEDICATION',
                                          'title': medicationNameController.text.trim(),
                                          'date': DateFormat('yyyy-MM-dd').format(fromDate),
                                          'time': '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                                          'dosage': dosageController.text.trim(),
                                          'mealTiming': selectedMealTiming,
                                          'fromDate': DateFormat('yyyy-MM-dd').format(fromDate),
                                          'toDate': DateFormat('yyyy-MM-dd').format(dueDate),
                                          if (descriptionController.text.trim().isNotEmpty)
                                            'description': descriptionController.text.trim(),
                                        };

                                        await PatientService.createTask(patientId!, taskData);

                                        if (mounted) {
                                          Navigator.pop(dialogContext);
                                          Navigator.pop(context, true);
                                          
                                          // Dispose after navigation completes
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            medicationNameController.dispose();
                                            dosageController.dispose();
                                            descriptionController.dispose();
                                          });
                                          
                                          // Show confirmation with date
                                          final String dateMessage = _isToday(fromDate) 
                                              ? 'today' 
                                              : 'on ${DateFormat('MMM d').format(fromDate)}';
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Medication reminder added successfully for $dateMessage!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          Navigator.pop(dialogContext);
                                          
                                          // Dispose after dialog closes
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            medicationNameController.dispose();
                                            dosageController.dispose();
                                            descriptionController.dispose();
                                          });
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: ${e.toString()}'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Add Medication'),
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

  // ==================== APPOINTMENT DIALOG ====================
  void _showAppointmentDialog() {
    final formKey = GlobalKey<FormState>();
    final taskNameController = TextEditingController();
    final hospitalController = TextEditingController();
    final doctorNameController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime dialogSelectedDate = selectedDate ?? DateTime.now();
    TimeOfDay? selectedTime;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF44336).withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.event, color: Color(0xFFF44336)),
                          SizedBox(width: 8),
                          Text(
                            'Schedule Appointment',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              // Appointment Title
                              TextFormField(
                                controller: taskNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Appointment Title',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.title),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter appointment title';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Hospital/Clinic Name
                              TextFormField(
                                controller: hospitalController,
                                decoration: const InputDecoration(
                                  labelText: 'Hospital/Clinic Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.local_hospital),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter hospital/clinic name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Doctor Name
                              TextFormField(
                                controller: doctorNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Doctor Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter doctor name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Date Picker
                              InkWell(
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: dialogSelectedDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      dialogSelectedDate = pickedDate;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Date',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(dialogSelectedDate),
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Time Picker
                              InkWell(
                                onTap: () async {
                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTime ?? TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      selectedTime = pickedTime;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Time',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.access_time),
                                  ),
                                  child: Text(
                                    selectedTime != null
                                        ? selectedTime!.format(context)
                                        : 'Select time',
                                    style: TextStyle(
                                      color: selectedTime != null
                                          ? Colors.black87
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Description
                              TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
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
                    ),

                    // Actions
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    Navigator.pop(dialogContext);
                                    // Dispose after dialog is closed
                                    Future.microtask(() {
                                      taskNameController.dispose();
                                      hospitalController.dispose();
                                      doctorNameController.dispose();
                                      descriptionController.dispose();
                                    });
                                  },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      if (selectedTime == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Please select a time'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() {
                                        isSubmitting = true;
                                      });

                                      try {
                                        // Call API to create appointment
                                        final taskData = {
                                          'taskType': 'APPOINTMENT',
                                          'title': taskNameController.text.trim(),
                                          'date': DateFormat('yyyy-MM-dd').format(dialogSelectedDate),
                                          'time': '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                                          if (descriptionController.text.trim().isNotEmpty)
                                            'description': descriptionController.text.trim(),
                                          'hospital': hospitalController.text.trim(),
                                          'doctorName': doctorNameController.text.trim(),
                                        };

                                        await PatientService.createTask(patientId!, taskData);

                                        if (mounted) {
                                          Navigator.pop(dialogContext);
                                          Navigator.pop(context, true);
                                          
                                          // Dispose after navigation completes
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            taskNameController.dispose();
                                            hospitalController.dispose();
                                            doctorNameController.dispose();
                                            descriptionController.dispose();
                                          });
                                          
                                          // Show confirmation with date
                                          final String dateMessage = _isToday(dialogSelectedDate) 
                                              ? 'today' 
                                              : 'on ${DateFormat('MMM d').format(dialogSelectedDate)}';
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Appointment scheduled successfully for $dateMessage!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          Navigator.pop(dialogContext);
                                          
                                          // Dispose after dialog closes
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            taskNameController.dispose();
                                            hospitalController.dispose();
                                            doctorNameController.dispose();
                                            descriptionController.dispose();
                                          });
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: ${e.toString()}'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Schedule'),
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
}

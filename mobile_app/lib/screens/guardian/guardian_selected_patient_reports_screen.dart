import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';

class GuardianSelectedPatientReportsScreen extends StatefulWidget {
  @override
  _GuardianSelectedPatientReportsScreenState createState() => _GuardianSelectedPatientReportsScreenState();
}

class _GuardianSelectedPatientReportsScreenState extends State<GuardianSelectedPatientReportsScreen> {
  Map<String, dynamic>? patient;
  List<Map<String, dynamic>> allReports = [];
  List<Map<String, dynamic>> filteredReports = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      patient = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _loadReports();
    });
  }

  void _loadReports() {
    // Mock data for daily reports - in real app, this would come from API/database
    allReports = [
      {
        'date': '2024-07-04',
        'time': '11:45 PM',
        'routineSummary': {
          'completed': ['Morning medication', 'Breakfast', 'Physical therapy'],
          'notCompleted': ['Evening walk'],
          'skipped': ['Afternoon snack'],
          'completionRate': 75,
        },
        'biometricsSummary': {
          'heartRate': {'avg': 72, 'min': 58, 'max': 89, 'status': 'Normal'},
          'bloodPressure': {'systolic': 120, 'diastolic': 80, 'status': 'Normal'},
          'steps': 8500,
          'sleepHours': 7.5,
          'anomalies': [],
          'overallStatus': 'Good',
        },
      },
      {
        'date': '2024-07-03',
        'time': '11:30 PM',
        'routineSummary': {
          'completed': ['Morning medication', 'Breakfast', 'Physical therapy', 'Evening walk'],
          'notCompleted': [],
          'skipped': ['Afternoon snack'],
          'completionRate': 100,
        },
        'biometricsSummary': {
          'heartRate': {'avg': 68, 'min': 55, 'max': 85, 'status': 'Normal'},
          'bloodPressure': {'systolic': 118, 'diastolic': 78, 'status': 'Normal'},
          'steps': 9200,
          'sleepHours': 8.0,
          'anomalies': [],
          'overallStatus': 'Excellent',
        },
      },
      {
        'date': '2024-07-02',
        'time': '11:20 PM',
        'routineSummary': {
          'completed': ['Morning medication', 'Breakfast'],
          'notCompleted': ['Physical therapy', 'Evening walk'],
          'skipped': ['Afternoon snack'],
          'completionRate': 40,
        },
        'biometricsSummary': {
          'heartRate': {'avg': 78, 'min': 62, 'max': 95, 'status': 'Normal'},
          'bloodPressure': {'systolic': 135, 'diastolic': 88, 'status': 'Elevated'},
          'steps': 4200,
          'sleepHours': 6.2,
          'anomalies': ['Elevated blood pressure detected at 3:15 PM'],
          'overallStatus': 'Needs Attention',
        },
      },
      {
        'date': '2024-07-01',
        'time': '11:55 PM',
        'routineSummary': {
          'completed': ['Morning medication', 'Breakfast', 'Physical therapy', 'Evening walk'],
          'notCompleted': [],
          'skipped': [],
          'completionRate': 100,
        },
        'biometricsSummary': {
          'heartRate': {'avg': 70, 'min': 56, 'max': 87, 'status': 'Normal'},
          'bloodPressure': {'systolic': 115, 'diastolic': 75, 'status': 'Normal'},
          'steps': 10500,
          'sleepHours': 8.5,
          'anomalies': [],
          'overallStatus': 'Excellent',
        },
      },
    ];

    setState(() {
      filteredReports = List.from(allReports);
    });
  }

  void _filterReportsByDate(DateTime? date) {
    setState(() {
      _selectedDate = date;
      if (date == null) {
        filteredReports = List.from(allReports);
      } else {
        String dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        filteredReports = allReports.where((report) {
          return report['date'] == dateString;
        }).toList();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF2B3F99),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF2B3F99),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _filterReportsByDate(picked);
    }
  }

  void _clearDateFilter() {
    _filterReportsByDate(null);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'needs attention':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final routine = report['routineSummary'];
    final biometrics = report['biometricsSummary'];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: EdgeInsets.all(16),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report - ${report['date']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Generated at ${report['time']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(biometrics['overallStatus']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                biometrics['overallStatus'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(biometrics['overallStatus']),
                ),
              ),
            ),
          ],
        ),
        children: [
          // Routine Summary Section
          Container(
            padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Routine Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${routine['completionRate']}% Complete',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Completed tasks
                if (routine['completed'].isNotEmpty) ...[
                  Text(
                    'Completed (${routine['completed'].length}):',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  for (var task in routine['completed'])
                    Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 2),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.green, size: 16),
                          SizedBox(width: 8),
                          Text(
                            task,
                            style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 8),
                ],

                // Not completed tasks
                if (routine['notCompleted'].isNotEmpty) ...[
                  Text(
                    'Not Completed (${routine['notCompleted'].length}):',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  for (var task in routine['notCompleted'])
                    Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 2),
                      child: Row(
                        children: [
                          Icon(Icons.close, color: Colors.orange, size: 16),
                          SizedBox(width: 8),
                          Text(
                            task,
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 8),
                ],

                // Skipped tasks
                if (routine['skipped'].isNotEmpty) ...[
                  Text(
                    'Skipped (${routine['skipped'].length}):',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  for (var task in routine['skipped'])
                    Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 2),
                      child: Row(
                        children: [
                          Icon(Icons.remove, color: Colors.red, size: 16),
                          SizedBox(width: 8),
                          Text(
                            task,
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),

          SizedBox(height: 16),

          // Biometrics Summary Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Biometrics Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Heart Rate
                Row(
                  children: [
                    Text(
                      'Heart Rate:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${biometrics['heartRate']['avg']} bpm avg (${biometrics['heartRate']['min']}-${biometrics['heartRate']['max']})',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),

                // Blood Pressure
                Row(
                  children: [
                    Text(
                      'Blood Pressure:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${biometrics['bloodPressure']['systolic']}/${biometrics['bloodPressure']['diastolic']} mmHg',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),

                // Steps
                Row(
                  children: [
                    Text(
                      'Steps:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${biometrics['steps']} steps',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),

                // Sleep
                Row(
                  children: [
                    Text(
                      'Sleep:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${biometrics['sleepHours']} hours',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                // Anomalies
                if (biometrics['anomalies'].isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    'Anomalies Detected:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  for (var anomaly in biometrics['anomalies'])
                    Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 2),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              anomaly,
                              style: TextStyle(fontSize: 13, color: Colors.red[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                ] else ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'No anomalies detected',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
                     icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          patient != null ? '${patient!['name']} Reports' : 'Patient Reports',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Date filter section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, color: Colors.grey[600]),
                        SizedBox(width: 12),
                        Text(
                          _selectedDate == null
                              ? 'Select a date to filter reports'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedDate == null ? Colors.grey[600] : Colors.black87,
                            fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF2B3F99),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                if (_selectedDate != null) ...[
                  SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _clearDateFilter,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Reports list
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (filteredReports.isEmpty)
                    Container(
                      padding: EdgeInsets.all(40),
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
                      child: Column(
                        children: [
                          Icon(
                            _selectedDate == null ? Icons.calendar_today : Icons.search_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _selectedDate == null
                                ? 'Select a date to view reports'
                                : 'No reports found for selected date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _selectedDate == null
                                ? 'Use the calendar button to choose a date'
                                : 'Try selecting a different date',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (var report in filteredReports) _buildReportCard(report),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
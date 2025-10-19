import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../utils/name_utils.dart';
import '../../services/daily_report_service.dart';

class GuardianSelectedPatientReportsScreen extends StatefulWidget {
  @override
  _GuardianSelectedPatientReportsScreenState createState() =>
      _GuardianSelectedPatientReportsScreenState();
}

class _GuardianSelectedPatientReportsScreenState
    extends State<GuardianSelectedPatientReportsScreen> {
  Map<String, dynamic>? patient;
  List<Map<String, dynamic>> allReports = [];
  List<Map<String, dynamic>> filteredReports = [];
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      patient =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _loadReports();
    });
  }

  void _loadReports() async {
    if (patient == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final reports = await DailyReportService.getReportsByPatientId(
        patient!['patientId'],
      );

      setState(() {
        allReports = reports;
        filteredReports = List.from(allReports);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading reports: $e');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load reports. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterReportsByDate(DateTime? date) {
    setState(() {
      _selectedDate = date;
      if (date == null) {
        filteredReports = List.from(allReports);
      } else {
        String dateString =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
              style: TextButton.styleFrom(foregroundColor: Color(0xFF2B3F99)),
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

  Color _getCompletionColor(int completionRate) {
    if (completionRate >= 80) {
      return Colors.green;
    } else if (completionRate >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  int _countTotalActivities(List taskGroups) {
    int total = 0;
    for (var group in taskGroups) {
      final details = group['details'] as List? ?? [];
      total += details.length;
    }
    return total;
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final routine = report['routineSummary'] as Map<String, dynamic>?;
    final completionRate = report['completionRate'] ?? 0;
    final generatedAt = report['generatedAt'] ?? 'N/A';

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
                    'Generated at $generatedAt',
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
                color: _getCompletionColor(completionRate).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$completionRate% Complete',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getCompletionColor(completionRate),
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
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
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
                      '$completionRate% Complete',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _getCompletionColor(completionRate),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                if (routine == null || routine.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'No routine data available',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  )
                else ...[
                  // Completed tasks
                  if (routine['completed'] != null &&
                      (routine['completed'] as List).isNotEmpty) ...[
                    Text(
                      'Completed (${_countTotalActivities(routine['completed'] as List)}):',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    for (var taskGroup in (routine['completed'] as List))
                      ...() {
                        final time = taskGroup['time'] ?? '';
                        final details = taskGroup['details'] as List? ?? [];
                        return details.map(
                          (detail) => Padding(
                            padding: EdgeInsets.only(left: 16, bottom: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    time.isNotEmpty
                                        ? '$time - $detail'
                                        : detail.toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }(),
                    SizedBox(height: 8),
                  ],

                  // Not completed tasks
                  if (routine['notCompleted'] != null &&
                      (routine['notCompleted'] as List).isNotEmpty) ...[
                    Text(
                      'Not Completed (${_countTotalActivities(routine['notCompleted'] as List)}):',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    for (var taskGroup in (routine['notCompleted'] as List))
                      ...() {
                        final time = taskGroup['time'] ?? '';
                        final details = taskGroup['details'] as List? ?? [];
                        return details.map(
                          (detail) => Padding(
                            padding: EdgeInsets.only(left: 16, bottom: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    time.isNotEmpty
                                        ? '$time - $detail'
                                        : detail.toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }(),
                    SizedBox(height: 8),
                  ],

                  // Skipped tasks
                  if (routine['skipped'] != null &&
                      (routine['skipped'] as List).isNotEmpty) ...[
                    Text(
                      'Skipped (${_countTotalActivities(routine['skipped'] as List)}):',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    for (var taskGroup in (routine['skipped'] as List))
                      ...() {
                        final time = taskGroup['time'] ?? '';
                        final details = taskGroup['details'] as List? ?? [];
                        return details.map(
                          (detail) => Padding(
                            padding: EdgeInsets.only(left: 16, bottom: 2),
                            child: Row(
                              children: [
                                Icon(Icons.remove, color: Colors.red, size: 16),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    time.isNotEmpty
                                        ? '$time - $detail'
                                        : detail.toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }(),
                  ],
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
          patient != null
              ? 'Reports: ${NameUtils.formatPatientName(patient!)}'
              : 'Patient Reports',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Date filter section
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
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
                                  color: _selectedDate == null
                                      ? Colors.grey[600]
                                      : Colors.black87,
                                  fontWeight: _selectedDate == null
                                      ? FontWeight.normal
                                      : FontWeight.w500,
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(milliseconds: 500));
                      _loadReports();
                    },
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
                                    _selectedDate == null
                                        ? Icons.calendar_today
                                        : Icons.search_off,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    _selectedDate == null
                                        ? 'No reports available yet'
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
                                        ? 'Reports will appear here when routines are completed'
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
                                for (var report in filteredReports)
                                  _buildReportCard(report),
                              ],
                            ),
                        ],
                      ),
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

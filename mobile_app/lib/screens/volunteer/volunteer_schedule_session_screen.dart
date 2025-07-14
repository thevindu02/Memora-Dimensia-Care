import 'package:flutter/material.dart';


class VolunteerScheduleSessionScreen extends StatefulWidget {
  const VolunteerScheduleSessionScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerScheduleSessionScreen> createState() => _VolunteerScheduleSessionScreenState();
}

class _VolunteerScheduleSessionScreenState extends State<VolunteerScheduleSessionScreen> {
  final TextEditingController _sessionTopicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _meetingLinkController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _sessionTopicController.dispose();
    _descriptionController.dispose();
    _meetingLinkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _scheduleSession() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time')),
      );
      return;
    }

    // Handle scheduling logic here
    print('Session scheduled for: ${_formatDate(_selectedDate!)} at ${_formatTime(_selectedTime!)}');
    print('Topic: ${_sessionTopicController.text}');
    print('Description: ${_descriptionController.text}');
    print('Meeting Link: ${_meetingLinkController.text}');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Session scheduled successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Schedule Session',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildDateField(),
                  SizedBox(height: 24),
                  _buildTimeField(),
                  SizedBox(height: 24),
                  _buildInputField('Session Topic', null, _sessionTopicController, 'Enter Topic'),
                  SizedBox(height: 24),
                  _buildInputField('Description', null, _descriptionController, 'Enter Description'),
                  SizedBox(height: 24),
                  _buildInputField('Meeting Link', Icons.link, _meetingLinkController, 'Enter Link'),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _scheduleSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Bottom spacing instead of Spacer
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate != null ? _formatDate(_selectedDate!) : 'Select Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedDate != null ? Colors.black : Colors.grey[500],
                    ),
                  ),
                ),
                Icon(Icons.calendar_today_outlined, color: Colors.grey[500], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedTime != null ? _formatTime(_selectedTime!) : 'Select Time',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedTime != null ? Colors.black : Colors.grey[500],
                    ),
                  ),
                ),
                Icon(Icons.access_time_outlined, color: Colors.grey[500], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, IconData? icon, TextEditingController controller, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              if (icon != null)
                Icon(icon, color: Colors.grey[500], size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
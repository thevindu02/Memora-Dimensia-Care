import 'package:flutter/material.dart';
import '../../services/schedule_session_service.dart';

class VolunteerScheduleSessionScreen extends StatefulWidget {
  final int volunteerId; // <-- Add this line

  const VolunteerScheduleSessionScreen({Key? key, required this.volunteerId}) : super(key: key); // <-- Update constructor

  @override
  State<VolunteerScheduleSessionScreen> createState() =>
      _VolunteerScheduleSessionScreenState();
}

class _VolunteerScheduleSessionScreenState
    extends State<VolunteerScheduleSessionScreen> {
  final TextEditingController _sessionTopicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _meetingLinkController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Focus nodes for highlighting borders
  final FocusNode _sessionTopicFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _meetingLinkFocus = FocusNode();

  // Validation states
  bool _isLoading = false;
  String? _sessionTopicError;
  String? _dateError;
  String? _timeError;
  String? _meetingLinkError;

  @override
  void initState() {
    super.initState();
    // Add focus listeners
    _sessionTopicFocus.addListener(() => setState(() {}));
    _descriptionFocus.addListener(() => setState(() {}));
    _meetingLinkFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _sessionTopicController.dispose();
    _descriptionController.dispose();
    _meetingLinkController.dispose();
    _sessionTopicFocus.dispose();
    _descriptionFocus.dispose();
    _meetingLinkFocus.dispose();
    super.dispose();
  }

  // Validation methods
  bool _validateSessionTopic() {
    if (_sessionTopicController.text.trim().isEmpty) {
      setState(() {
        _sessionTopicError = 'Session topic is required';
      });
      return false;
    }
    if (_sessionTopicController.text.trim().length < 3) {
      setState(() {
        _sessionTopicError = 'Session topic must be at least 3 characters';
      });
      return false;
    }
    setState(() {
      _sessionTopicError = null;
    });
    return true;
  }

  bool _validateDate() {
    if (_selectedDate == null) {
      setState(() {
        _dateError = 'Please select a date';
      });
      return false;
    }
    // Check if selected date is not in the past
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDateOnly = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );

    if (selectedDateOnly.isBefore(today)) {
      setState(() {
        _dateError = 'Cannot schedule sessions in the past';
      });
      return false;
    }
    setState(() {
      _dateError = null;
    });
    return true;
  }

  bool _validateTime() {
    if (_selectedTime == null) {
      setState(() {
        _timeError = 'Please select a time';
      });
      return false;
    }
    setState(() {
      _timeError = null;
    });
    return true;
  }

  bool _validateMeetingLink() {
    if (_meetingLinkController.text.trim().isNotEmpty) {
      // Basic URL validation
      final urlPattern = RegExp(
        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      );
      if (!urlPattern.hasMatch(_meetingLinkController.text.trim())) {
        setState(() {
          _meetingLinkError = 'Please enter a valid URL';
        });
        return false;
      }
    }
    setState(() {
      _meetingLinkError = null;
    });
    return true;
  }

  bool _validateForm() {
    bool isValid = true;

    isValid &= _validateSessionTopic();
    isValid &= _validateDate();
    isValid &= _validateTime();
    isValid &= _validateMeetingLink();

    return isValid;
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
        _dateError = null; // Clear error when user selects date
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
        _timeError = null; // Clear error when user selects time
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _scheduleSession() async {
    // Clear previous errors
    setState(() {
      _sessionTopicError = null;
      _dateError = null;
      _timeError = null;
      _meetingLinkError = null;
    });

    // Validate form
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ScheduleSessionService.createScheduleSession(
        sessionDate: _selectedDate!,
        sessionTime: _formatTime(_selectedTime!),
        sessionTopic: _sessionTopicController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        meetingLink: _meetingLinkController.text.trim().isEmpty
            ? null
            : _meetingLinkController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (result.success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _sessionTopicController.clear();
        _descriptionController.clear();
        _meetingLinkController.clear();
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
        });

        // Navigate back after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void someMethod() {
    final id = widget.volunteerId;
    // Use id as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Schedule Session',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                _buildDateField(),
                SizedBox(height: 24),
                _buildTimeField(),
                SizedBox(height: 24),
                _buildInputField(
                  'Session Topic',
                  null,
                  _sessionTopicController,
                  'Enter Topic',
                  _sessionTopicFocus,
                  errorText: _sessionTopicError,
                ),
                SizedBox(height: 24),
                _buildInputField(
                  'Description',
                  null,
                  _descriptionController,
                  'Enter Description',
                  _descriptionFocus,
                  isRequired: false,
                ),
                SizedBox(height: 24),
                _buildInputField(
                  'Meeting Link',
                  Icons.link,
                  _meetingLinkController,
                  'Enter Link (optional)',
                  _meetingLinkFocus,
                  isRequired: false,
                  errorText: _meetingLinkError,
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _scheduleSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA0C4FD),
                      foregroundColor: Color(0xFF2B3F99),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2B3F99),
                              ),
                            ),
                          )
                        : Text(
                            'Schedule',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),
              ],
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
          'Session Date *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: _dateError != null
                  ? Border.all(color: Colors.red, width: 2.0)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : 'Select Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedDate != null
                          ? Colors.black
                          : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey[500],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_dateError != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              _dateError!,
              style: TextStyle(color: Colors.red, fontSize: 12),
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
          'Session Time *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: _timeError != null
                  ? Border.all(color: Colors.red, width: 2.0)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedTime != null
                        ? _formatTime(_selectedTime!)
                        : 'Select Time',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedTime != null
                          ? Colors.black
                          : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(
                  Icons.access_time_outlined,
                  color: Colors.grey[500],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_timeError != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              _timeError!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    IconData? icon,
    TextEditingController controller,
    String placeholder,
    FocusNode focusNode, {
    bool isRequired = true,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label *' : label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: (focusNode.hasFocus || errorText != null)
                ? Border.all(
                    color: errorText != null ? Colors.red : Colors.black,
                    width: 2.0,
                  )
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  onChanged: (value) {
                    // Clear error when user starts typing
                    if (errorText != null && value.trim().isNotEmpty) {
                      setState(() {
                        if (label == 'Session Topic') {
                          _sessionTopicError = null;
                        } else if (label == 'Meeting Link') {
                          _meetingLinkError = null;
                        }
                      });
                    }
                  },
                ),
              ),
              if (icon != null) Icon(icon, color: Colors.grey[500], size: 20),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

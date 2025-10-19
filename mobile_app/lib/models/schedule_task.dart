class ScheduleTask {
  final int careActivityId;
  final String taskType;
  final int taskId;
  final String time;
  final String status;
  final String? skipReason;
  final String title;
  final String? description;

  // Game-specific fields
  final int? gameId;
  final String? gameName;

  // Medication-specific fields
  final int? medicationId;
  final String? medicationName;
  final String? dosage;
  final String? mealTiming;

  // Appointment-specific fields
  final String? hospital;
  final String? doctorName;
  final String? appointmentDate;

  ScheduleTask({
    required this.careActivityId,
    required this.taskType,
    required this.taskId,
    required this.time,
    required this.status,
    this.skipReason,
    required this.title,
    this.description,
    this.gameId,
    this.gameName,
    this.medicationId,
    this.medicationName,
    this.dosage,
    this.mealTiming,
    this.hospital,
    this.doctorName,
    this.appointmentDate,
  });

  factory ScheduleTask.fromJson(Map<String, dynamic> json) {
    return ScheduleTask(
      careActivityId: json['careActivityId'] as int,
      taskType: json['taskType'] as String? ?? 'DAILY_ACTIVITY',
      taskId: json['taskId'] as int? ?? 0,
      time: json['time'] as String? ?? '00:00',
      status: json['status'] as String? ?? 'PENDING',
      skipReason: json['skipReason'] as String?,
      title: json['title'] as String? ?? 'Untitled Task',
      description: json['description'] as String?,
      gameId: json['gameId'] as int?,
      gameName: json['gameName'] as String?,
      medicationId: json['medicationId'] as int?,
      medicationName: json['medicationName'] as String?,
      dosage: json['dosage'] as String?,
      mealTiming: json['mealTiming'] as String?,
      hospital: json['hospital'] as String?,
      doctorName: json['doctorName'] as String?,
      appointmentDate: json['appointmentDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'careActivityId': careActivityId,
      'taskType': taskType,
      'taskId': taskId,
      'time': time,
      'status': status,
      'skipReason': skipReason,
      'title': title,
      'description': description,
      'gameId': gameId,
      'gameName': gameName,
      'medicationId': medicationId,
      'medicationName': medicationName,
      'dosage': dosage,
      'mealTiming': mealTiming,
      'hospital': hospital,
      'doctorName': doctorName,
      'appointmentDate': appointmentDate,
    };
  }

  ScheduleTask copyWith({
    int? careActivityId,
    String? taskType,
    int? taskId,
    String? time,
    String? status,
    String? skipReason,
    String? title,
    String? description,
    int? gameId,
    String? gameName,
    int? medicationId,
    String? medicationName,
    String? dosage,
    String? mealTiming,
    String? hospital,
    String? doctorName,
    String? appointmentDate,
  }) {
    return ScheduleTask(
      careActivityId: careActivityId ?? this.careActivityId,
      taskType: taskType ?? this.taskType,
      taskId: taskId ?? this.taskId,
      time: time ?? this.time,
      status: status ?? this.status,
      skipReason: skipReason ?? this.skipReason,
      title: title ?? this.title,
      description: description ?? this.description,
      gameId: gameId ?? this.gameId,
      gameName: gameName ?? this.gameName,
      medicationId: medicationId ?? this.medicationId,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      mealTiming: mealTiming ?? this.mealTiming,
      hospital: hospital ?? this.hospital,
      doctorName: doctorName ?? this.doctorName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
    );
  }

  String get taskIcon {
    switch (taskType) {
      case 'DAILY_ACTIVITY':
        return '📋';
      case 'GAME':
        return '🎮';
      case 'MEDICATION':
        return '💊';
      case 'APPOINTMENT':
        return '🏥';
      default:
        return '📌';
    }
  }

  bool get isCompleted => status == 'COMPLETED';
  bool get isPending => status == 'PENDING';
  bool get isSkipped => status == 'SKIPPED';
  bool get isInProgress => status == 'IN_PROGRESS';
}

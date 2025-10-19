// Medication reminder models based on backend DTOs and entities

class MedicationReminderRequest {
  final String medicationName;
  final String dosage;
  final String mealTiming;
  final String description;
  final String time; // Format: "HH:mm"
  final int patientId;
  final String fromDate; // Format: "YYYY-MM-DD"
  final String dueDate; // Format: "YYYY-MM-DD"

  MedicationReminderRequest({
    required this.medicationName,
    required this.dosage,
    required this.mealTiming,
    required this.description,
    required this.time,
    required this.patientId,
    required this.fromDate,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicationName': medicationName,
      'dosage': dosage,
      'mealTiming': mealTiming,
      'description': description,
      'time': time,
      'patientId': patientId,
      'fromDate': fromDate,
      'dueDate': dueDate,
    };
  }

  factory MedicationReminderRequest.fromJson(Map<String, dynamic> json) {
    return MedicationReminderRequest(
      medicationName: json['medicationName'] ?? '',
      dosage: json['dosage'] ?? '',
      mealTiming: json['mealTiming'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      patientId: json['patientId'] ?? 0,
      fromDate: json['fromDate'] ?? '',
      dueDate: json['dueDate'] ?? '',
    );
  }
}

class MedicationReminder {
  final int medicationId;
  final int careActivityId;
  final String taskName;
  final String medicationName;
  final int numberOfRounds;
  final String dosage;
  final String mealTiming;
  final String description;
  final String reminderTime;
  final String status;

  MedicationReminder({
    required this.medicationId,
    required this.careActivityId,
    required this.taskName,
    required this.medicationName,
    required this.numberOfRounds,
    required this.dosage,
    required this.mealTiming,
    required this.description,
    required this.reminderTime,
    required this.status,
  });

  factory MedicationReminder.fromJson(Map<String, dynamic> json) {
    return MedicationReminder(
      medicationId: json['medicationId'] ?? 0,
      careActivityId: json['careActivityId'] ?? 0,
      taskName: json['taskName'] ?? '',
      medicationName: json['medicationName'] ?? '',
      numberOfRounds: json['numberOfRounds'] ?? 1,
      dosage: json['dosage'] ?? '',
      mealTiming: json['mealTiming'] ?? '',
      description: json['description'] ?? '',
      reminderTime: json['reminderTime'] ?? '',
      status: json['status'] ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicationId': medicationId,
      'careActivityId': careActivityId,
      'taskName': taskName,
      'medicationName': medicationName,
      'numberOfRounds': numberOfRounds,
      'dosage': dosage,
      'mealTiming': mealTiming,
      'description': description,
      'reminderTime': reminderTime,
      'status': status,
    };
  }
}

class MedicationScheduleItem {
  final int medicationId;
  final int careActivityId;
  final String medicationName;
  final String dosage;
  final String mealTiming;
  final String time;
  final String status;
  final int numberOfRounds;
  final String description;
  final String taskName;

  MedicationScheduleItem({
    required this.medicationId,
    required this.careActivityId,
    required this.medicationName,
    required this.dosage,
    required this.mealTiming,
    required this.time,
    required this.status,
    required this.numberOfRounds,
    required this.description,
    required this.taskName,
  });

  factory MedicationScheduleItem.fromJson(Map<String, dynamic> json) {
    return MedicationScheduleItem(
      medicationId: json['medicationId'] ?? 0,
      careActivityId: json['careActivityId'] ?? 0,
      medicationName: json['medicationName'] ?? '',
      dosage: json['dosage'] ?? '',
      mealTiming: json['mealTiming'] ?? '',
      time: json['reminderTime'] ?? json['time'] ?? '',
      status: json['status'] ?? 'PENDING',
      numberOfRounds: json['numberOfRounds'] ?? 1,
      description: json['description'] ?? '',
      taskName: json['taskName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicationId': medicationId,
      'careActivityId': careActivityId,
      'medicationName': medicationName,
      'dosage': dosage,
      'mealTiming': mealTiming,
      'time': time,
      'status': status,
      'numberOfRounds': numberOfRounds,
      'description': description,
      'taskName': taskName,
    };
  }
}

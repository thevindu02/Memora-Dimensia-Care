class PatientProfile {
  final int patientId;
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String dementiaStage;
  final String dementiaType;
  final String? dateOfDiagnosis;
  final int? guardianId;
  final int? caregiverId;

  PatientProfile({
    required this.patientId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dementiaStage,
    required this.dementiaType,
    this.dateOfDiagnosis,
    this.guardianId,
    this.caregiverId,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      patientId: json['patientId'] as int,
      userId: json['userId'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      dementiaStage: json['dementiaStage'] as String,
      dementiaType: json['dementiaType'] as String,
      dateOfDiagnosis: json['dateOfDiagnosis'] as String?,
      guardianId: json['guardianId'] as int?,
      caregiverId: json['caregiverId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dementiaStage': dementiaStage,
      'dementiaType': dementiaType,
      'dateOfDiagnosis': dateOfDiagnosis,
      'guardianId': guardianId,
      'caregiverId': caregiverId,
    };
  }

  bool get canNavigateDates {
    return dementiaStage == 'MILD' || dementiaStage == 'MODERATE';
  }

  bool get canAddAllTaskTypes {
    return dementiaStage == 'MILD' || dementiaStage == 'MODERATE';
  }
}

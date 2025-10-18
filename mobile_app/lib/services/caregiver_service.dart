import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class CaregiverService {
  static final String baseUrl = '${ApiConstants.baseUrl}/api/caregivers';
  static final String guardianEndpoint = '${ApiConstants.baseUrl}/api/guardians';

  /// Primary: call backend endpoint added: GET /api/guardians/{guardianId}/expired-caregivers
  /// Fallback: try multiple endpoint variants and flexible JSON parsing.
  static Future<List<Map<String, dynamic>>> getExpiredInactiveCaregiversByGuardianId(int guardianId) async {
    final primaryUrl = '$guardianEndpoint/$guardianId/expired-caregivers';
    try {
      final resp = await http.get(Uri.parse(primaryUrl), headers: {'Content-Type': 'application/json'});
      if (resp.statusCode == 200 && resp.body.trim().isNotEmpty) {
        final parsed = jsonDecode(resp.body);
        if (parsed is List) {
          return parsed.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
        if (parsed is Map<String, dynamic>) {
          // accept wrapper { data: [...] }
          for (final key in ['data', 'caregivers', 'items', 'results']) {
            if (parsed.containsKey(key) && parsed[key] is List) {
              return List<Map<String, dynamic>>.from(parsed[key].map((e) => Map<String, dynamic>.from(e as Map)));
            }
          }
          return [Map<String, dynamic>.from(parsed)];
        }
      } else {
        print('CaregiverService: primary endpoint returned ${resp.statusCode} - ${resp.body}');
      }
    } catch (e) {
      print('CaregiverService: primary endpoint error: $e');
    }

    // Primary endpoint failed — use robust candidates search
    return _getExpiredInactiveCaregiversCandidates(guardianId);
  }

  /// Internal: try multiple candidate URLs and flexible JSON parsing.
  static Future<List<Map<String, dynamic>>> _getExpiredInactiveCaregiversCandidates(int guardianId) async {
    final candidates = <String>[
      '$baseUrl/expired-inactive?guardianId=$guardianId',
      '$baseUrl/expired-inactive?guardian_id=$guardianId',
      '${ApiConstants.baseUrl}/api/guardians/$guardianId/caregivers/expired',
      '$baseUrl/expired-inactive/$guardianId',
      '$baseUrl/by-guardian/$guardianId/expired',
    ];

    for (final url in candidates) {
      try {
        print('CaregiverService: trying $url');
        final resp = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

        if (resp.statusCode == 200) {
          final body = resp.body.trim();
          if (body.isEmpty) continue;

          final parsed = jsonDecode(body);
          if (parsed is List) {
            return parsed.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map)).toList();
          }
          if (parsed is Map<String, dynamic>) {
            for (final key in ['data', 'caregivers', 'items', 'results']) {
              if (parsed.containsKey(key) && parsed[key] is List) {
                return List<Map<String, dynamic>>.from(parsed[key].map((e) => Map<String, dynamic>.from(e as Map)));
              }
            }
            return [Map<String, dynamic>.from(parsed)];
          }
        } else {
          print('CaregiverService: $url returned ${resp.statusCode}');
          continue;
        }
      } catch (e) {
        print('CaregiverService: request to $url failed: $e');
        continue;
      }
    }

    return <Map<String, dynamic>>[];
  }

  /// Backwards-compatible method used previously in the app.
  static Future<List<Map<String, dynamic>>> getExpiredInactiveCaregivers() async {
    final uri = Uri.parse('$baseUrl/expired-inactive');
    final resp = await http.get(uri, headers: {'Content-Type': 'application/json'});
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data.map((e) => Map<String, dynamic>.from(e as Map)));
      }
      if (data is Map<String, dynamic>) {
        for (final key in ['data', 'caregivers', 'items', 'results']) {
          if (data.containsKey(key) && data[key] is List) {
            return List<Map<String, dynamic>>.from(data[key].map((e) => Map<String, dynamic>.from(e as Map)));
          }
        }
        return [Map<String, dynamic>.from(data)];
      }
    }
    return <Map<String, dynamic>>[];
  }

  static Future<List<Map<String, dynamic>>> getCaregiversByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/by-city/$city'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load caregivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregivers: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllCaregivers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<Map<String, dynamic>>((c) {
          final map = Map<String, dynamic>.from(c);
          final fName = map['fName'] ?? '';
          final lName = map['lName'] ?? '';
          map['name'] = (fName + ' ' + lName).trim();
          return map;
        }).toList();
      } else {
        throw Exception('Failed to load caregivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregivers: $e');
    }
  }

  static Future<Map<String, dynamic>> getCaregiverById(int caregiverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$caregiverId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load caregiver: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregiver: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getPendingRequests(int caregiverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$caregiverId/pending-requests'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load pending requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load pending requests: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getConnectedRequests(int caregiverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$caregiverId/connected-requests'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load connected requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load connected requests: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAvailableCaregiversForPatient(int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/available-for-patient/$patientId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<Map<String, dynamic>>((c) {
          final map = Map<String, dynamic>.from(c);
          final fName = map['fName'] ?? '';
          final lName = map['lName'] ?? '';
          map['name'] = (fName + ' ' + lName).trim();
          return map;
        }).toList();
      } else {
        throw Exception('Failed to load caregivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregivers: $e');
    }
  }

  static Future<int?> getCaregiverIdByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/by-user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return int.tryParse(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> acceptConnectionRequest(int connectionId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/connection-request/$connectionId/accept'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to accept request');
    }
  }

  static Future<void> rejectConnectionRequest(int connectionId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/connection-request/$connectionId/reject'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to reject request');
    }
  }

  static Future<Map<String, dynamic>?> getPatientDetails(int patientId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/patients/$patientId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<bool> updateProfile({
    required int caregiverId,
    required String fName,
    required String lName,
    required String email,
    required String phoneNumber,
    required String gender,
    required String birthdate,
    required String street,
    required String city,
    required String state,
    required String profilePic,
    required String experience,
    required String qualifications,
    required List<String> skills,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/caregivers/$caregiverId/edit-profile');
    final body = {
      'fName': fName,
      'lName': lName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'birthdate': birthdate,
      'street': street,
      'city': city,
      'state': state,
      'profilePic': profilePic,
      'experience': experience,
      'qualifications': qualifications,
      'skills': skills,
    };
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  static Future<List<Map<String, dynamic>>> getCaregiverReviews(int caregiverId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/caregivers/$caregiverId/reviews'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}

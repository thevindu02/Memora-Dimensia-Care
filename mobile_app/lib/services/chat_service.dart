import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/api_constants.dart';

class ChatService {
  static final String _base = ApiConstants.baseUrl;

  // Get conversation list for a guardian (tries several common endpoints)
  static Future<List<Map<String, dynamic>>> getConversationsForGuardian(int guardianId) async {
    final candidates = <String>[
      '$_base/api/guardians/$guardianId/conversations',
      '$_base/api/chats/guardian/$guardianId',
      '$_base/api/conversations?guardianId=$guardianId',
    ];

    for (final url in candidates) {
      try {
        final resp = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
        if (resp.statusCode != 200) continue;
        final body = resp.body.trim();
        if (body.isEmpty) continue;
        final parsed = jsonDecode(body);
        List<dynamic> raw = [];
        if (parsed is List) raw = parsed;
        else if (parsed is Map<String, dynamic>) {
          for (final k in ['data','items','conversations','results']) {
            if (parsed.containsKey(k) && parsed[k] is List) {
              raw = parsed[k];
              break;
            }
          }
          if (raw.isEmpty && parsed.containsKey('conversation')) {
            raw = [parsed['conversation']];
          }
        }
        if (raw.isEmpty) continue;
        return raw.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map)).toList();
      } catch (_) {
        continue;
      }
    }

    return <Map<String, dynamic>>[];
  }
}
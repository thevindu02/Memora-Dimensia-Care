import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class Game {
  final int gameId;
  final String name;
  final String description;

  Game({required this.gameId, required this.name, required this.description});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameId: json['gameId'] is int
          ? json['gameId']
          : int.tryParse(json['gameId'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'gameId': gameId, 'name': name, 'description': description};
  }
}

class ApiResult<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResult({required this.success, required this.message, this.data});
}

class GameService {
  static const String baseUrl = ApiConstants.baseUrl;

  /// Get all games
  static Future<ApiResult<List<Game>>> getAllGames() async {
    try {
      final url = Uri.parse('$baseUrl/api/games');
      print('Getting games from: $url');

      final response = await http
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(Duration(seconds: 10));

      print('Games response status: ${response.statusCode}');
      print('Games response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final games = jsonList.map((json) => Game.fromJson(json)).toList();

        // If no games from API, return default games
        if (games.isEmpty) {
          return _getDefaultGames();
        }

        return ApiResult<List<Game>>(
          success: true,
          message: 'Games retrieved successfully',
          data: games,
        );
      } else {
        print('Failed to get games, using defaults');
        return _getDefaultGames();
      }
    } catch (e) {
      print('Error getting games: $e, using defaults');
      return _getDefaultGames();
    }
  }

  /// Fallback method to return default games if API fails
  static ApiResult<List<Game>> _getDefaultGames() {
    final defaultGames = [
      Game(
        gameId: 1,
        name: 'Memory Card Matching',
        description:
            'A classic memory game where patients match pairs of cards to improve cognitive function and memory recall',
      ),
      Game(
        gameId: 2,
        name: 'Photo Recognition',
        description:
            'Interactive photo recognition activities to help maintain visual memory and recall of familiar faces and places',
      ),
      Game(
        gameId: 3,
        name: 'Simple Puzzle Games',
        description:
            'Easy-to-solve puzzles designed to enhance problem-solving skills and maintain cognitive abilities',
      ),
      Game(
        gameId: 4,
        name: 'Word Association',
        description:
            'Word games to help maintain language skills and cognitive associations',
      ),
      Game(
        gameId: 5,
        name: 'Color Matching',
        description:
            'Simple color matching activities to improve visual recognition and cognitive processing',
      ),
    ];

    return ApiResult<List<Game>>(
      success: true,
      message: 'Using default games',
      data: defaultGames,
    );
  }

  /// Get game by ID
  static Future<ApiResult<Game>> getGameById(int gameId) async {
    try {
      final url = Uri.parse('$baseUrl/api/games/$gameId');
      print('Getting game from: $url');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Game response status: ${response.statusCode}');
      print('Game response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final game = Game.fromJson(jsonData);

        return ApiResult<Game>(
          success: true,
          message: 'Game retrieved successfully',
          data: game,
        );
      } else {
        return ApiResult<Game>(
          success: false,
          message: 'Failed to retrieve game: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting game: $e');
      return ApiResult<Game>(success: false, message: 'Network error: $e');
    }
  }
}

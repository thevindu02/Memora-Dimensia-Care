class Game {
  final int gameId;
  final String name;
  final String? description;

  Game({required this.gameId, required this.name, this.description});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameId: json['gameId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'gameId': gameId, 'name': name, 'description': description};
  }

  @override
  String toString() {
    return 'Game(gameId: $gameId, name: $name, description: $description)';
  }
}

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/chat_message.dart';

class ChatDb {
  static final ChatDb _instance = ChatDb._internal();
  factory ChatDb() => _instance;
  ChatDb._internal();

  Database? _db;
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'memora_chat.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE messages (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          conversation_id TEXT NOT NULL,
          sender TEXT NOT NULL,
          text TEXT NOT NULL,
          timestamp INTEGER NOT NULL
        )
        ''');
      },
    );
  }

  Future<int> saveMessage(String conversationId, ChatMessage msg) async {
    final database = await db;
    return await database.insert('messages', {
      'conversation_id': conversationId,
      'sender': msg.sender,
      'text': msg.text,
      'timestamp': msg.timestamp.millisecondsSinceEpoch,
    });
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final database = await db;
    final rows = await database.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp ASC',
    );
    return rows.map((r) => ChatMessage(
      sender: r['sender'] as String,
      text: r['text'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(r['timestamp'] as int),
    )).toList();
  }

  Future<void> clearConversation(String conversationId) async {
    final database = await db;
    await database.delete('messages', where: 'conversation_id = ?', whereArgs: [conversationId]);
  }

  // Delete all messages for a conversation id. Tries common column names.
  Future<void> deleteConversation(String conversationId) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_db.db');
    final db = await openDatabase(path);
    try {
      // try common column names
      await db.delete('messages', where: 'conversationId = ?', whereArgs: [conversationId]);
    } catch (_) {}
    try {
      await db.delete('messages', where: 'conversation_id = ?', whereArgs: [conversationId]);
    } catch (_) {}
    try {
      await db.delete('messages', where: 'conversation = ?', whereArgs: [conversationId]);
    } catch (_) {}
    await db.close();
  }
}
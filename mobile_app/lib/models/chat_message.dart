class ChatMessage {
  final String sender; // 'guardian' or 'caregiver'
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}
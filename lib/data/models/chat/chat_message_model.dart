import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String? id;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp? timestamp;

  const ChatMessage({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.timestamp,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    Timestamp? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map, [String? id]) {
    return ChatMessage(
      // id: map['id'] as String?,
      id: id,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp'] as Timestamp?,
    );
  }

  Map<String, dynamic> toDocument() => toMap();

  factory ChatMessage.fromSnapshot(DocumentSnapshot snapshot) =>
      ChatMessage.fromMap(snapshot.data() as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      senderId,
      receiverId,
      message,
      timestamp ?? FieldValue.serverTimestamp(),
    ];
  }
}

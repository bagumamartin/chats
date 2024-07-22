import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String? id;
  final List<String> memberIds;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  // final CollectionReference messages;
  final Timestamp? lastMessageTimestamp;
  final String? lastMessageText;

  const Chat({
    this.id,
    required this.memberIds,
    required this.createdAt,
    this.updatedAt,
    // required this.messages,
    this.lastMessageTimestamp,
    this.lastMessageText,
  });

  get lastMessage => lastMessageText ?? 'No messages yet';

  Chat copyWith({
    String? id,
    List<String>? memberIds,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    // CollectionReference? messages,
    Timestamp? lastMessageTimestamp,
    String? lastMessageText,
  }) {
    return Chat(
      id: id ?? this.id,
      memberIds: memberIds ?? this.memberIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      // messages: messages ?? this.messages,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      lastMessageText: lastMessageText ?? this.lastMessageText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberIds': memberIds,
      'createdAt': createdAt,
      // 'messages': messages,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'lastMessageTimestamp': lastMessageTimestamp,
      'lastMessageText': lastMessageText,
    };
  }

  Map<String, dynamic> toDocument() => toMap();

  factory Chat.fromMap(Map<String, dynamic> map, String id) {
    return Chat(
      id: id,
      memberIds: List<String>.from(map['memberIds']),
      // messages: map['messages'] as CollectionReference,
      createdAt: map['createdAt'] as Timestamp,
      updatedAt: map['updatedAt'] as Timestamp?,
      lastMessageTimestamp: map['lastMessageTimestamp'] as Timestamp?,
      lastMessageText: map['lastMessageText'] as String?,
    );
  }

  factory Chat.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Chat.fromMap(data, snapshot.id);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        memberIds,
        createdAt,
        updatedAt,
        lastMessageTimestamp,
        lastMessageText
      ];
}

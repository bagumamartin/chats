import 'package:chats/data/models/chat/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import 'package:chats/data/models/chat/chat_model.dart';

class ChatProvider {
  final firestore.FirebaseFirestore _firebaseFirestore;
  final String _chatsCollection = 'chats';
  final String _chatMessagesCollection = 'messages';

  ChatProvider({
    firestore.FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore =
            firebaseFirestore ?? firestore.FirebaseFirestore.instance;

  Future<String> createChat({
    required Chat chat,
  }) async {
    try {
      await _firebaseFirestore
          .collection(_chatsCollection)
          .doc(chat.id)
          .set(chat.toMap());

      final firestore.DocumentReference chatDocRef =
          _firebaseFirestore.collection(_chatsCollection).doc(chat.id);
      return chatDocRef.id;
    } catch (e) {
      // Handle error
      rethrow; // Rethrow the error for higher-level handling
    }
  }

  // Check if the chat exists
  Future<bool> checkChat({required String chatId}) async {
    final chatDoc =
        await _firebaseFirestore.collection(_chatsCollection).doc(chatId).get();
    return chatDoc.exists;
  }

  Stream<List<Chat>> getUserChatsStream(String userId) {
    return _firebaseFirestore
        .collection(_chatsCollection)
        .where('memberIds', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Chat.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<List<Chat>> getChats({
    required String userId,
  }) async {
    try {
      final firestore.QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(_chatsCollection)
          .where('members', arrayContains: userId)
          .get();

      return querySnapshot.docs.map((doc) => Chat.fromSnapshot(doc)).toList();
    } catch (e) {
      // Handle error
      rethrow; // Rethrow the error for higher-level handling
    }
  }

  // Future<ChatMessage> sendMessage(
  //     {required ChatMessage message, required String chatId}) async {
  //   try {
  //     final firestore.DocumentReference messageRef = await _firebaseFirestore
  //         .collection(_chatsCollection)
  //         .doc(chatId)
  //         .collection(_chatMessagesCollection)
  //         .add(message.toMap());

  //     // Fetch the message from Firestore using its reference
  //     final firestore.DocumentSnapshot messageSnapshot = await messageRef.get();
  //     final Map<String, dynamic> messageData =
  //         messageSnapshot.data()! as Map<String, dynamic>;

  //     // Convert the fetched data back to a ChatMessage object and include the document ID
  //     final ChatMessage sentMessage =
  //         ChatMessage.fromMap(messageData).copyWith(id: messageRef.id);
  //     print(
  //         'ChatProvider: Message sent and retrieved successfully: ${sentMessage.toMap()}');

  //     return sentMessage;
  //   } catch (e) {
  //     // Handle error
  //     print('Error sending message: $e');
  //     rethrow; // Rethrow the error for higher-level handling
  //   }
  // }

  Future<ChatMessage> sendMessage({
    required String chatId,
    required ChatMessage message,
  }) async {
    final messageRef = await _firebaseFirestore
        .collection(_chatsCollection)
        .doc(chatId)
        .collection(_chatMessagesCollection)
        .add(message.toMap());

    await _firebaseFirestore.collection(_chatsCollection).doc(chatId).update({
      'updatedAt': firestore.FieldValue.serverTimestamp(),
      'lastMessageText': message.message,
      'lastMessageTimestamp': message.timestamp
    });

    final messageSnapshot = await messageRef.get();
    return ChatMessage.fromMap(messageSnapshot.data()!, messageSnapshot.id);
  }

  Stream<List<ChatMessage>> getChatMessagesStream(String chatId) {
    try {
      return _firebaseFirestore
          .collection(_chatsCollection)
          .doc(chatId)
          .collection(_chatMessagesCollection)
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => ChatMessage.fromSnapshot(doc))
              .toList());
    } catch (e) {
      // Handle error
      rethrow; // Rethrow the error for higher-level handling
    }
  }

  Future<String> getChatId(String userId1, String userId2) async {
    final querySnapshot = await _firebaseFirestore
        .collection(_chatsCollection)
        .where('memberIds', arrayContains: userId1)
        .get();

    for (var doc in querySnapshot.docs) {
      List<String> memberIds = List<String>.from(doc.data()['memberIds']);
      if (memberIds.contains(userId2)) {
        return doc.id;
      }
    }

    return '';
  }
}

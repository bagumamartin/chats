import 'package:chats/data/models/chat/chat_message_model.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final ChatMessage message;
  final String userid;
  // final void Function()? onTap;

  const MessageTile({
    super.key,
    required this.message,
    required this.userid,
  });

  @override
  Widget build(BuildContext context) {
    bool isSentByMe = message.senderId == userid;

    return ListTile(
      // onTap: onTap,
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            // width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isSentByMe ? Colors.blue : Colors.grey[600],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              message.message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

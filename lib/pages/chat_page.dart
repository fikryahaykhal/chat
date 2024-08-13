import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final userMessage = _messageController.text;
      await FirebaseFirestore.instance.collection('messages').add({
        'text': userMessage,
        'createdAt': Timestamp.now(),
        'sender': _userEmail,
        'senderId': _userId
      });

      final reply = _generateChatbotResponse(userMessage);
      await FirebaseFirestore.instance.collection('messages').add({
        'text': reply,
        'createdAt': Timestamp.now(),
        'sender': 'chatbot',
        'senderId': 'chatbot' + _userId
      });

      _messageController.clear();
    }
  }

  String get _userEmail {
    final user = _auth.currentUser;
    return user?.email ?? 'Anonymous';
  }

  String get _userId {
    final user = _auth.currentUser;
    return user?.uid ?? 'anonymous';
  }

  String _generateChatbotResponse(String userMessage) {
    return "You said: $userMessage";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy('createdAt')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  final messages = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message['text']),
                        subtitle: Text(message['sender']),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration:
                          const InputDecoration(labelText: 'Send a message'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

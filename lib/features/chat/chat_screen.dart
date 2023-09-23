import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void _onLogout() {
    _firebase.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _onLogout,
            icon: const Icon(Icons.exit_to_app),
          )
        ],
        title: const Text('FlutterChat'),
      ),
      body: const Center(child: Text('Chat')),
    );
  }
}

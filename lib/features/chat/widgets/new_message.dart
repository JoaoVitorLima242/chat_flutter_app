import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';

final _firebaseFirestore = FirebaseFirestore.instance;
final _firebaseAuth = FirebaseAuth.instance;
// final _firebaseStorage = FirebaseStorage.instance;

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessage();
  }
}

class _NewMessage extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onSubmitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();

    final user = _firebaseAuth.currentUser!;
    _messageController.clear();

    try {
      final userData =
          await _firebaseFirestore.collection('users').doc(user.uid).get();

      if (userData.data()?['username'] == null &&
          userData.data()?['image_url'] == null) {
        print(userData);

        return;
      }

      await _firebaseFirestore.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['username'],
        'user_image': userData.data()!['image_url'],
      });
    } on FirebaseException catch (error) {
      print(error);
      openErrorSnackBar();
      _messageController.clear();
    }
  }

  void openErrorSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error sending the message')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, bottom: 40),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
              onPressed: _onSubmitMessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
    );
  }
}

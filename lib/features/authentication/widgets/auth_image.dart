import 'package:flutter/material.dart';

class AuthImage extends StatelessWidget {
  const AuthImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      width: 100,
      child: Image.asset('assets/chat.png'),
    );
  }
}

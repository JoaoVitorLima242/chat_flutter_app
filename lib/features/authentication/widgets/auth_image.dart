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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.0),
      ),
      width: 130,
      height: 130,
      padding: const EdgeInsets.all(20),
      child: Image.asset('assets/chat.png'),
    );
  }
}

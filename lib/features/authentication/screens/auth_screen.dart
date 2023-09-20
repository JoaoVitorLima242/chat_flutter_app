import 'package:chat_app/features/authentication/widgets/auth_image.dart';
import 'package:chat_app/features/authentication/widgets/auth_card.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthImage(),
              AuthCard(),
            ],
          ),
        ),
      ),
    );
  }
}

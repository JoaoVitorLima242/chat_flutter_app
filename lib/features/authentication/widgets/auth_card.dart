import 'package:flutter/material.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() {
    return _AuthCard();
  }
}

class _AuthCard extends State<AuthCard> {
  bool _isLogin = true;

  void switchAuthentication() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    minimumSize: const Size.fromHeight(35)),
                child: Text(_isLogin ? "Login" : 'Signup'),
              ),
              TextButton(
                onPressed: switchAuthentication,
                child: Text(_isLogin
                    ? 'Create an account'
                    : 'I already have an account'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

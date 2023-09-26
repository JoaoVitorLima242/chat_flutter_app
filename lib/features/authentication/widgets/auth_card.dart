import 'dart:io';

import 'package:chat_app/common_widgets/user_image_picker/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() {
    return _AuthCard();
  }
}

class _AuthCard extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  String _enteredEmail = '';
  String _enteredPassword = '';
  File? _selectedImage;

  void _switchAuthentication() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void onPickImage(File pickedImage) {
    _selectedImage = pickedImage;
  }

  void _onFormSubmit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (!_isLogin && _selectedImage == null) {
      return;
    }

    _formKey.currentState!.save();

    try {
      UserCredential userCredentials;

      if (_isLogin) {
        userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      }
      print(userCredentials);
    } on FirebaseAuthException {
      openErrorSnackBar();
    }
  }

  void openErrorSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Authentication failed.')),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.trim().length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isLogin) UserImagePicker(onPickImage: onPickImage),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                validator: _emailValidator,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onSaved: (value) {
                  _enteredEmail = value!;
                },
              ),
              TextFormField(
                obscureText: true,
                validator: _passwordValidator,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onSaved: (value) {
                  _enteredPassword = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onFormSubmit,
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    minimumSize: const Size.fromHeight(36)),
                child: Text(_isLogin ? "Login" : 'Signup'),
              ),
              TextButton(
                onPressed: _switchAuthentication,
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

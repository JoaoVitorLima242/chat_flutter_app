import 'dart:io';

import 'package:chat_app/common_widgets/user_image_picker/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebaseAuth = FirebaseAuth.instance;
final _firebaseStorage = FirebaseStorage.instance;
final _firebaseFirestore = FirebaseFirestore.instance;

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
  String _enteredUsername = '';
  String _enteredPassword = '';
  File? _selectedImage;
  var _isAuthenticating = false;

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

    setState(() {
      _isAuthenticating = true;
    });

    try {
      UserCredential userCredentials;

      if (_isLogin) {
        userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        final userId = userCredentials.user!.uid;

        final storageRef =
            _firebaseStorage.ref().child('user_images').child('$userId.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await _firebaseFirestore.collection('users').doc(userId).set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl
        });
      }
    } on FirebaseAuthException catch (error) {
      openErrorSnackBar();
      setState(() {
        _isAuthenticating = false;
      });

      print(error);
    }
  }

  void openErrorSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Authentication failed.')),
    );
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty || value.trim().length < 4) {
      return 'Please enter at least 4 characters.';
    }
    return null;
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
              if (!_isLogin)
                TextFormField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: _usernameValidator,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  onSaved: (value) {
                    _enteredUsername = value!;
                  },
                ),
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
                onPressed: _isAuthenticating ? null : _onFormSubmit,
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    minimumSize: const Size.fromHeight(36)),
                child: _isAuthenticating
                    ? const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.grey,
                        )),
                      )
                    : Text(_isLogin ? "Login" : 'Signup'),
              ),
              TextButton(
                onPressed: _isAuthenticating ? null : _switchAuthentication,
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

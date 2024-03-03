import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/routes/constants.dart';
import 'package:notes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final pass = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: pass,
                );
              } on FirebaseAuthException catch (e) {
                if (!context.mounted) {
                  log("Context Error");
                } else {
                  if (e.code == 'weak-password') {
                    await showErrorDialog(
                      context,
                      'Weak Password',
                    );
                  } else if (e.code == 'email-already-in-use') {
                    await showErrorDialog(
                      context,
                      'Email Already in Use',
                    );
                  } else if (e.code == 'invalid-email') {
                    await showErrorDialog(
                      context,
                      'Invalid Email',
                    );
                  } else {
                    await showErrorDialog(
                      context,
                      'Error:${e.code}',
                    );
                  }
                }
              } catch (e) {
                if (!context.mounted) {
                  log("Context Error");
                } else {
                  await showErrorDialog(
                    context,
                    'Error:${e.toString()}',
                  );
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text("Already Registered? Login Here!"),
          ),
        ],
      ),
    );
  }
}

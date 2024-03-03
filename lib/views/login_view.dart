import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/routes/constants.dart';
import 'package:notes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("Login"),
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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: pass,
                );
                if (!context.mounted) {
                  log("Context Error");
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (!context.mounted) {
                  log("Context Error");
                } else {
                  if (e.code == 'invalid-credential') {
                    await showErrorDialog(
                      context,
                      "Invalid Credentials",
                    );
                  } else {
                    await showErrorDialog(
                      context,
                      "Error: ${e.code}",
                    );
                  }
                }
              } catch (e) {
                if (!context.mounted) {
                  log("Context Error");
                } else {
                  await showErrorDialog(
                    context,
                    "Error: ${e.toString()}",
                  );
                }
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Not Registered? Reister here!"),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:notes/firebase_options.dart';

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
          title: const Text('Login'),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
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
                        final pass = _email.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: pass);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-credential') {
                            log("User Not Found");
                          } else {
                            log(e.code);
                          }
                        }
                      },
                      child: const Text("Login"),
                    )
                  ],
                );
              default:
                return const Text("Loading");
            }
          },
        ));
  }
}

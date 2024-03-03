import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Text("Please Verify You're Email"),
          TextButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              log('${user?.emailVerified}');
              user?.sendEmailVerification();
            },
            child: const Text("Send Email Verification"),
          )
        ],
      ),
    );
  }
}

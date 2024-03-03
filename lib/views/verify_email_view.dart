import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/routes/constants.dart';

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
      body: Center(
        child: Column(
          children: [
            const Text(
                'We\'ve send you an email verification. Please verify your email'),
            const Text('Haven\'t receive an email. Cick the Button below'),
            TextButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                log('${user?.emailVerified}');
                user?.sendEmailVerification();
              },
              child: const Text("Resend Email Verification"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) {
                  log("Context Error");
                } else {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                }
              },
              child: const Text("Restart"),
            )
          ],
        ),
      ),
    );
  }
}

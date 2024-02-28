import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: const VerifyEmailView(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                final userVerified = user?.emailVerified ?? false;
                if (userVerified) {
                  print("You are Verifed");
                } else {
                  print("You aren't Verifed");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const VerifyEmailView(),
                    ),
                  );
                }
                return const Text('Done..');
              default:
                return const Text("Loading");
            }
          },
        ));
  }
}

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
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          return Column(
            children: [
              const Text("Please Verify You're Email"),
              TextButton(
                onPressed: () {
                  final user = FirebaseAuth.instance.currentUser;
                  user?.sendEmailVerification();
                },
                child: const Text("Send Email Verification"),
              )
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screen1.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;
        final user = FirebaseAuth.instance.currentUser;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                user != null ? const HomeScreen() : const QuestionScreenOne(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          'assets/images/logo.png',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
        Text('WELCOM TO WORKIFY')
      ])),
    );
  }
}

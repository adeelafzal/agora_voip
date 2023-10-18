import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      Navigator.pushReplacementNamed(
          context,FirebaseAuth.instance.currentUser != null
          ? "/HomeScreen"
          : "/SignInScreen");
    });
    return Scaffold(
      body: Center(
        child: Hero(
          tag: "logo",
            child: Image.asset(
          "images/logo.png",
          scale: 3,
        )),
      ),
    );
  }
}

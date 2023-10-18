import 'package:agora_voip/main.dart';
import 'package:agora_voip/utils/firebase_notifications.dart';
import 'package:agora_voip/view/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  Future<UserCredential?> signUp(
      {required String email, required String password}) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      navigatorKey.currentState!.pop();
      final SnackBar snackBar = SnackBar(content: Text(e.code));
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
    return null;
  }

  saveUserData({required String email}) async {
    String? deviceToken = await FirebaseNotifications().getDeviceToken();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "email": email,
      "token": deviceToken,
      "userId": FirebaseAuth.instance.currentUser!.uid
    });
  }

  signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String? deviceToken = await FirebaseNotifications().getDeviceToken();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"token": deviceToken});
        navigatorKey.currentState!.pop();
        navigatorKey.currentState!.pushReplacementNamed("/HomeScreen");
      });
    } on FirebaseAuthException catch (e) {
      navigatorKey.currentState!.pop();
      final SnackBar snackBar = SnackBar(content: Text(e.code));
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }
}

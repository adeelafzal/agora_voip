import 'package:agora_voip/main.dart';
import 'package:agora_voip/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel {
  final AuthRepository authRepository = AuthRepository();

  createAccount({required String email, required String password}) async {
    try {
      UserCredential? userCredential =
          await authRepository.signUp(email: email, password: password);
      if (userCredential == null) {
        return;
      }
      await authRepository.saveUserData(email: email);
      const SnackBar snackBar =
          SnackBar(content: Text("Account created successfully."));
      snackbarKey.currentState?.showSnackBar(snackBar);
      navigatorKey.currentState!.pop();
      navigatorKey.currentState!.pop();
    } on FirebaseAuthException catch (e) {
      navigatorKey.currentState!.pop();
      final SnackBar snackBar = SnackBar(content: Text(e.code));
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  signIn({required String email, required String password}){
    authRepository.signIn(email: email, password: password);
  }

}

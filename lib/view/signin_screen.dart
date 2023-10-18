import 'package:agora_voip/utils/validator_functions.dart';
import 'package:agora_voip/view_model/auth_viewmodel.dart';
import 'package:agora_voip/widgets/loading_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthViewModel authViewModel = AuthViewModel();
  final email = TextEditingController();
  final password = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Hero(
                tag: "logo",
                child: Image.asset(
                  "images/logo.png",
                  scale: 3,
                ),
              ),
              const Text("Sign In",
                  style: TextStyle(
                      color: Color(0xFF00174c),
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => validateEmail(email.text),
                decoration: InputDecoration(
                    label: const Text("Email"),
                    hintText: "Enter your email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: password,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => validatePassword(password.text),
                decoration: InputDecoration(
                    label: const Text("Password"),
                    hintText: "Enter your password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    if (!_key.currentState!.validate()) {
                      return;
                    }
                    loadingDialog();
                    authViewModel.signIn(
                        email: email.text, password: password.text);
                  },
                  child: const Text("Sign In")),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: "Don’t have an account? ",
                        style: TextStyle(
                          color: Color(0xff979899),
                        )),
                    TextSpan(
                        text: 'Sign Up',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, "/SignUpScreen");
                          },
                        style: const TextStyle(
                          color: Colors.deepPurple,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../utils/helpers.dart';

class LoginView extends StatefulWidget {
  final VoidCallback togglePage;
  const LoginView({required this.togglePage, super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _authService = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await _authService.signInWithEmailAndPassword(
        _email.text.trim(),
        _password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showMessage(context, e.message ?? "Login failed");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _email,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _password,
          decoration: const InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
        const SizedBox(height: 28),
        _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _login,
                child: const Text(
                  "Log In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: widget.togglePage,
          child: const Text(
            "Don't have an account? Sign Up",
            style: TextStyle(color: Colors.indigo),
          ),
        ),
      ],
    );
  }
}
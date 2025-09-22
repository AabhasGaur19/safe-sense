import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../utils/helpers.dart';

class SignUpView extends StatefulWidget {
  final VoidCallback togglePage;
  const SignUpView({required this.togglePage, super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _age = TextEditingController();
  bool _loading = false;

  Future<void> _signup() async {
    setState(() => _loading = true);
    try {
      final user = await _auth.registerWithEmailAndPassword(
        _email.text.trim(),
        _password.text.trim(),
      );
      if (user != null) {
        await _db.addUserData(
          user.uid,
          _name.text.trim(),
          int.tryParse(_age.text) ?? 0,
        );
      }
    } on FirebaseAuthException catch (e) {
      showMessage(context, e.message ?? "Signup failed");
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
          controller: _name,
          decoration: const InputDecoration(labelText: "Full Name"),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        TextField(
          controller: _age,
          decoration: const InputDecoration(labelText: "Age"),
          keyboardType: TextInputType.number,
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
                onPressed: _signup,
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: widget.togglePage,
          child: const Text(
            "Already have an account? Log In",
            style: TextStyle(color: Colors.indigo),
          ),
        ),
      ],
    );
  }
}
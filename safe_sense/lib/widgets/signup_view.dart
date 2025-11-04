// lib/widgets/signup_view.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/api_service.dart'; // 👈 ADD THIS
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
  final ApiService _api = ApiService(); // 👈 ADD THIS
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _age = TextEditingController();
  bool _loading = false;

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();
    
    // Validate inputs
    if (_name.text.trim().isEmpty) {
      showMessage(context, "Please enter your name", type: MessageType.error);
      return;
    }
    
    if (_age.text.trim().isEmpty || int.tryParse(_age.text) == null) {
      showMessage(context, "Please enter a valid age", type: MessageType.error);
      return;
    }
    
    if (_email.text.trim().isEmpty) {
      showMessage(context, "Please enter your email", type: MessageType.error);
      return;
    }
    
    if (_password.text.trim().isEmpty || _password.text.length < 6) {
      showMessage(context, "Password must be at least 6 characters", type: MessageType.error);
      return;
    }
    
    setState(() => _loading = true);
    
    try {
      // 👇 SEND DATA TO BACKEND FIRST
      print('📤 Sending data to backend...');
      final backendResponse = await _api.sendSignupData(
        name: _name.text.trim(),
        age: int.parse(_age.text.trim()),
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      
      if (backendResponse['success']) {
        print('✅ Backend received data successfully!');
        print('Response: ${backendResponse['data']}');
      } else {
        print('❌ Backend error: ${backendResponse['error']}');
        if (mounted) {
          showMessage(context, "Backend error: ${backendResponse['error']}", 
            type: MessageType.error);
        }
        return;
      }
      
      // Create auth account
      final user = await _auth.registerWithEmailAndPassword(
        _email.text.trim(),
        _password.text.trim(),
      );
      
      if (user != null) {
        // Store user data in Firestore
        await _db.addUserData(
          user.uid,
          _name.text.trim(),
          int.parse(_age.text.trim()),
          _email.text.trim(),
        );
        
        if (mounted) {
          showMessage(context, "Account created successfully!", type: MessageType.success);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage = "Signup failed";
        if (e.code == 'weak-password') {
          errorMessage = "The password is too weak";
        } else if (e.code == 'email-already-in-use') {
          errorMessage = "An account already exists with this email";
        } else if (e.code == 'invalid-email') {
          errorMessage = "Invalid email address";
        } else {
          errorMessage = e.message ?? "Signup failed";
        }
        showMessage(context, errorMessage, type: MessageType.error);
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, "Error: ${e.toString()}", type: MessageType.error);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          "Create Account",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
          
        // Two fields per row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _age,
                decoration: const InputDecoration(
                  labelText: "Age",
                  prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Email field
        TextField(
          controller: _email,
          decoration: const InputDecoration(
            labelText: "Email",
            prefixIcon: Icon(Icons.email_outlined, size: 20),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            isDense: true,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        
        // Password field
        TextField(
          controller: _password,
          decoration: const InputDecoration(
            labelText: "Password",
            prefixIcon: Icon(Icons.lock_outline, size: 20),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            isDense: true,
          ),
          obscureText: true,
        ),
        
        const Expanded(child: SizedBox()),
        
        // Buttons
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          ElevatedButton(
            onPressed: _signup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Create Account"),
          ),
        const SizedBox(height: 6),
        TextButton(
          onPressed: widget.togglePage,
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 36),
          ),
          child: Text(
            "Already have an account? Sign In",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}







// // lib/widgets/login_view.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../services/auth_service.dart';
// import '../utils/helpers.dart';

// class LoginView extends StatefulWidget {
//   final VoidCallback togglePage;
//   const LoginView({required this.togglePage, super.key});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   final AuthService _authService = AuthService();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   bool _loading = false;

//   Future<void> _login() async {
//     setState(() => _loading = true);
//     try {
//       await _authService.signInWithEmailAndPassword(
//         _email.text.trim(),
//         _password.text.trim(),
//       );
//     } on FirebaseAuthException catch (e) {
//       if(mounted) showMessage(context, e.message ?? "Login failed");
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           "Welcome Back",
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF1A1A1A),
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Sign in to your account",
//           style: TextStyle(color: Colors.grey[600]),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 32),
//         TextField(
//           controller: _email,
//           decoration: const InputDecoration(
//             labelText: "Email",
//             prefixIcon: Icon(Icons.email_outlined),
//           ),
//           keyboardType: TextInputType.emailAddress,
//         ),
//         const SizedBox(height: 16),
//         TextField(
//           controller: _password,
//           decoration: const InputDecoration(
//             labelText: "Password",
//             prefixIcon: Icon(Icons.lock_outline),
//           ),
//           obscureText: true,
//         ),
//         const SizedBox(height: 32),
//         _loading
//             ? const Center(child: CircularProgressIndicator())
//             : ElevatedButton(
//                 onPressed: _login,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(double.infinity, 56),
//                 ),
//                 child: const Text("Sign In"),
//               ),
//         const SizedBox(height: 24),
//         TextButton(
//           onPressed: widget.togglePage,
//           child: Text(
//             "Don't have an account? Sign Up",
//             style: TextStyle(color: Theme.of(context).primaryColor),
//           ),
//         ),
//       ],
//     );
//   }
// }



// lib/widgets/login_view.dart
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
    // Hide keyboard
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await _authService.signInWithEmailAndPassword(
        _email.text.trim(),
        _password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // if (mounted) showMessage(context, e.message ?? "Login failed");
      if (mounted) showMessage(context, e.message ?? "Login failed", type: MessageType.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Wrap the Column with SingleChildScrollView to prevent overflow
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Welcome Back",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Sign in to your account",
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _email,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 32),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text("Sign In"),
                ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: widget.togglePage,
            child: Text(
              "Don't have an account? Sign Up",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
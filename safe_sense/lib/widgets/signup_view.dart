// // lib/widgets/signup_view.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../services/auth_service.dart';
// import '../services/database_service.dart';
// import '../utils/helpers.dart';

// class SignUpView extends StatefulWidget {
//   final VoidCallback togglePage;
//   const SignUpView({required this.togglePage, super.key});

//   @override
//   State<SignUpView> createState() => _SignUpViewState();
// }

// class _SignUpViewState extends State<SignUpView> {
//   final AuthService _auth = AuthService();
//   final DatabaseService _db = DatabaseService();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   final _name = TextEditingController();
//   final _age = TextEditingController();
//   bool _loading = false;

//   Future<void> _signup() async {
//     // Hide keyboard
//     FocusScope.of(context).unfocus();
//     setState(() => _loading = true);
//     try {
//       final user = await _auth.registerWithEmailAndPassword(
//         _email.text.trim(),
//         _password.text.trim(),
//       );
//       if (user != null) {
//         await _db.addUserData(
//           user.uid,
//           _name.text.trim(),
//           int.tryParse(_age.text) ?? 0,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       if (mounted) showMessage(context, e.message ?? "Signup failed");
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
//           "Create Account",
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF1A1A1A),
//               ),
//           textAlign: TextAlign.center,
//         ),
//         // ✅ REMOVED subtitle text ("Join SafeSense today") and its spacing.
//         const SizedBox(height: 16),
//         TextField(
//           controller: _name,
//           decoration: const InputDecoration(
//             labelText: "Full Name",
//             prefixIcon: Icon(Icons.person_outline),
//           ),
//         ),
//         const SizedBox(height: 16),
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
//         const SizedBox(height: 16),
//         TextField(
//           controller: _age,
//           decoration: const InputDecoration(
//             labelText: "Age",
//             prefixIcon: Icon(Icons.calendar_today_outlined),
//           ),
//           keyboardType: TextInputType.number,
//         ),
//         const Spacer(), // Use Spacer to push content to the bottom
//         _loading
//             ? const Center(child: CircularProgressIndicator())
//             : ElevatedButton(
//                 onPressed: _signup,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(double.infinity, 56),
//                 ),
//                 child: const Text("Create Account"),
//               ),
//         const SizedBox(height: 16),
//         TextButton(
//           onPressed: widget.togglePage,
//           child: Text(
//             "Already have an account? Sign In",
//             style: TextStyle(color: Theme.of(context).primaryColor),
//           ),
//         ),
//       ],
//     );
//   }
// }




// lib/widgets/signup_view.dart
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
    FocusScope.of(context).unfocus();
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
      if (mounted) showMessage(context, e.message ?? "Signup failed");
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
        // Compact header
        Text(
          "Create Account",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
          
          // Two fields per row to save vertical space
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
          
          // Flexible spacer
          const Expanded(child: SizedBox()),
          
          // Buttons section
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
                  borderRadius: BorderRadius.circular(6),
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
import 'package:flutter/material.dart';
import '../widgets/login_view.dart';
import '../widgets/signup_view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();
  bool _isLogin = true;
  
  void togglePage() {
    setState(() => _isLogin = !_isLogin);
    _pageController.animateToPage(
      _isLogin ? 0 : 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.shield_outlined, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  _isLogin ? "Welcome Back" : "Create Account",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin ? "Login to continue" : "Sign up to start your journey",
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        LoginView(togglePage: togglePage),
                        SignUpView(togglePage: togglePage),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
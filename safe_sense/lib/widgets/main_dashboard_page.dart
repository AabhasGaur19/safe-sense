import 'package:flutter/material.dart';

class MainDashboardPage extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final bool isSessionActive;
  final bool isLoading;
  final VoidCallback onToggleSession;

  const MainDashboardPage({
    super.key,
    required this.userData,
    required this.isSessionActive,
    required this.isLoading,
    required this.onToggleSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (userData != null)
                Column(
                  children: [
                    Text(
                      "Name: ${userData!['name']}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Age: ${userData!['age']}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: 180,
                height: 180,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: onToggleSession,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSessionActive ? Colors.green : Colors.indigo,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                        ),
                        child: Text(
                          isSessionActive ? "Stop\nSession" : "Start",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
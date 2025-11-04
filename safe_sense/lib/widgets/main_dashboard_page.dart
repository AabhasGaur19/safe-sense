// lib/widgets/main_dashboard_page.dart
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: isSmallScreen ? 12 : 16,
        ),
        child: Column(
          children: [
            SizedBox(height: isSmallScreen ? 16 : 24),
            // Profile card section removed
            const Spacer(flex: 2),
            Container(
              width: isSmallScreen ? 180 : 200,
              height: isSmallScreen ? 180 : 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isSessionActive 
                      ? [Colors.green, Colors.lightGreen]
                      : [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSessionActive 
                        ? Colors.green.withOpacity(0.3)
                        : Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: isSmallScreen ? 25 : 30,
                    spreadRadius: isSmallScreen ? 8 : 10,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(isSmallScreen ? 90 : 100),
                        onTap: onToggleSession,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isSessionActive ? Icons.stop_rounded : Icons.play_arrow_rounded,
                                size: isSmallScreen ? 42 : 48,
                                color: Colors.white,
                              ),
                              SizedBox(height: isSmallScreen ? 6 : 8),
                              Text(
                                isSessionActive ? "STOP" : "START",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            const Spacer(flex: 3),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 14 : 16,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: isSessionActive 
                    ? Colors.green.withOpacity(0.1)
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSessionActive ? Icons.fiber_manual_record : Icons.radio_button_unchecked,
                    color: isSessionActive ? Colors.green : Theme.of(context).primaryColor,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isSessionActive ? "Session Active" : "Ready to Start",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isSessionActive ? Colors.green : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
          ],
        ),
      ),
    );
  }
}
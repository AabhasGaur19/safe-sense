// lib/widgets/settings_page.dart
import 'package:flutter/material.dart';
import '../screens/settings/profile_page.dart';
import '../screens/settings/notifications_page.dart';
import '../screens/settings/privacy_security_page.dart';
import '../screens/settings/help_support_page.dart';
import '../screens/settings/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: isSmallScreen ? 16 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isSmallScreen ? 16 : 24),
                Text(
                  "Settings",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 24 : 28,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Manage your preferences",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: 8,
              ),
              children: [
                _buildSettingsCard(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: "Profile",
                  subtitle: "Manage your personal information",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 12 : 14),
                _buildSettingsCard(
                  context,
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  subtitle: "Configure alert preferences",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsPage()),
                    );
                  },
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 12 : 14),
                _buildSettingsCard(
                  context,
                  icon: Icons.security_rounded,
                  title: "Privacy & Security",
                  subtitle: "Manage your data and security settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacySecurityPage()),
                    );
                  },
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 12 : 14),
                _buildSettingsCard(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: "Help & Support",
                  subtitle: "Get help and contact support",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpSupportPage()),
                    );
                  },
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 12 : 14),
                _buildSettingsCard(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: "About",
                  subtitle: "App version and information",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(isSmallScreen ? 16 : 18),
        leading: Container(
          width: isSmallScreen ? 44 : 48,
          height: isSmallScreen ? 44 : 48,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: isSmallScreen ? 20 : 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 14 : 15,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
        trailing: Container(
          width: isSmallScreen ? 28 : 30,
          height: isSmallScreen ? 28 : 30,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: isSmallScreen ? 12 : 14,
            color: Colors.grey,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
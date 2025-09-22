// lib/widgets/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  "Settings",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Manage your preferences",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildSettingsCard(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: "Profile",
                  subtitle: "Manage your personal information",
                  onTap: () {
                    // TODO: Navigate to Profile Page
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  subtitle: "Configure alert preferences",
                  onTap: () {
                    // TODO: Navigate to Notifications Page
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  icon: Icons.security_rounded,
                  title: "Privacy & Security",
                  subtitle: "Manage your data and security settings",
                  onTap: () {
                    // TODO: Navigate to Privacy Page
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: "Help & Support",
                  subtitle: "Get help and contact support",
                  onTap: () {
                    // TODO: Navigate to Help Page
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: "About",
                  subtitle: "App version and information",
                  onTap: () {
                    // TODO: Navigate to About Page
                  },
                ),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

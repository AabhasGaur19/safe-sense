// lib/screens/settings/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database_service.dart';
import '../../utils/helpers.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final DatabaseService _db = DatabaseService();
  
  bool _sosAlerts = true;
  bool _sessionReminders = true;
  bool _locationUpdates = false;
  bool _emergencyContacts = true;
  bool _appUpdates = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _notificationFrequency = 'immediate';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final settings = await _db.getNotificationSettings(user.uid);
      if (settings != null && mounted) {
        setState(() {
          _sosAlerts = settings['sosAlerts'] ?? true;
          _sessionReminders = settings['sessionReminders'] ?? true;
          _locationUpdates = settings['locationUpdates'] ?? false;
          _emergencyContacts = settings['emergencyContacts'] ?? true;
          _appUpdates = settings['appUpdates'] ?? true;
          _soundEnabled = settings['soundEnabled'] ?? true;
          _vibrationEnabled = settings['vibrationEnabled'] ?? true;
          _notificationFrequency = settings['notificationFrequency'] ?? 'immediate';
        });
      }
    }
  }

  Future<void> _saveNotificationSettings() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _db.updateNotificationSettings(user.uid, {
          'sosAlerts': _sosAlerts,
          'sessionReminders': _sessionReminders,
          'locationUpdates': _locationUpdates,
          'emergencyContacts': _emergencyContacts,
          'appUpdates': _appUpdates,
          'soundEnabled': _soundEnabled,
          'vibrationEnabled': _vibrationEnabled,
          'notificationFrequency': _notificationFrequency,
        });
        if (mounted) {
          showMessage(context, "Notification settings saved!", type: MessageType.success);
        }
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, "Failed to save settings: ${e.toString()}", type: MessageType.error);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: isSmallScreen ? 16 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      context,
                      title: "Alert Preferences",
                      icon: Icons.notifications_active_rounded,
                      isSmallScreen: isSmallScreen,
                      children: [
                        _buildSwitchTile(
                          context,
                          title: "SOS Alerts",
                          subtitle: "Get notified about SOS activations",
                          value: _sosAlerts,
                          onChanged: (val) => setState(() => _sosAlerts = val),
                          isSmallScreen: isSmallScreen,
                        ),
                        const Divider(height: 1),
                        _buildSwitchTile(
                          context,
                          title: "Session Reminders",
                          subtitle: "Reminders to end active sessions",
                          value: _sessionReminders,
                          onChanged: (val) => setState(() => _sessionReminders = val),
                          isSmallScreen: isSmallScreen,
                        ),
                        const Divider(height: 1),
                        _buildSwitchTile(
                          context,
                          title: "Location Updates",
                          subtitle: "Notifications for location changes",
                          value: _locationUpdates,
                          onChanged: (val) => setState(() => _locationUpdates = val),
                          isSmallScreen: isSmallScreen,
                        ),
                        const Divider(height: 1),
                        _buildSwitchTile(
                          context,
                          title: "Emergency Contacts",
                          subtitle: "Updates from emergency contacts",
                          value: _emergencyContacts,
                          onChanged: (val) => setState(() => _emergencyContacts = val),
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 20),

                    _buildSectionCard(
                      context,
                      title: "Sound & Vibration",
                      icon: Icons.volume_up_rounded,
                      isSmallScreen: isSmallScreen,
                      children: [
                        _buildSwitchTile(
                          context,
                          title: "Sound",
                          subtitle: "Play sound for notifications",
                          value: _soundEnabled,
                          onChanged: (val) => setState(() => _soundEnabled = val),
                          isSmallScreen: isSmallScreen,
                        ),
                        const Divider(height: 1),
                        _buildSwitchTile(
                          context,
                          title: "Vibration",
                          subtitle: "Vibrate on notifications",
                          value: _vibrationEnabled,
                          onChanged: (val) => setState(() => _vibrationEnabled = val),
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 20),

                    _buildSectionCard(
                      context,
                      title: "Notification Frequency",
                      icon: Icons.schedule_rounded,
                      isSmallScreen: isSmallScreen,
                      children: [
                        _buildRadioTile(
                          context,
                          title: "Immediate",
                          subtitle: "Receive notifications instantly",
                          value: 'immediate',
                          groupValue: _notificationFrequency,
                          onChanged: (val) => setState(() => _notificationFrequency = val!),
                          isSmallScreen: isSmallScreen,
                        ),
                        const Divider(height: 1),
                        _buildRadioTile(
                          context,
                          title: "Hourly Summary",
                          subtitle: "Bundled updates every hour",
                          value: 'hourly',
                          groupValue: _notificationFrequency,
                          onChanged: (val) => setState(() => _notificationFrequency = val!),
                          isSmallScreen: isSmallScreen,
                        ),
                        const Divider(height: 1),
                        _buildRadioTile(
                          context,
                          title: "Daily Summary",
                          subtitle: "One notification per day",
                          value: 'daily',
                          groupValue: _notificationFrequency,
                          onChanged: (val) => setState(() => _notificationFrequency = val!),
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 20),

                    _buildSectionCard(
                      context,
                      title: "General",
                      icon: Icons.info_outline_rounded,
                      isSmallScreen: isSmallScreen,
                      children: [
                        _buildSwitchTile(
                          context,
                          title: "App Updates",
                          subtitle: "New features and improvements",
                          value: _appUpdates,
                          onChanged: (val) => setState(() => _appUpdates = val),
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 24 : 32),
                  ],
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: isSmallScreen ? 12 : 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveNotificationSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Save Preferences",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isSmallScreen,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 36 : 40,
                  height: isSmallScreen ? 36 : 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: isSmallScreen ? 18 : 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isSmallScreen,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: isSmallScreen ? 8 : 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
    required bool isSmallScreen,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: isSmallScreen ? 8 : 12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
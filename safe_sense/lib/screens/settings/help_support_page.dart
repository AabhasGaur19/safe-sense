// lib/screens/settings/help_support_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/helpers.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@safesense.com',
      queryParameters: {
        'subject': 'SafeSense Support Request',
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      // Handle error silently or show a message
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+1-800-SAFESENSE',
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch phone dialer';
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _launchWebsite() async {
    final Uri websiteUri = Uri.parse('https://safesense.com/help');

    try {
      if (await canLaunchUrl(websiteUri)) {
        await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch website';
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _showFAQDialog(BuildContext context, String question, String answer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(answer),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text('Help & Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: isSmallScreen ? 16 : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Support Section
              _buildSectionCard(
                context,
                title: "Contact Support",
                icon: Icons.support_agent_rounded,
                isSmallScreen: isSmallScreen,
                children: [
                  _buildContactTile(
                    context,
                    icon: Icons.email_rounded,
                    title: "Email Support",
                    subtitle: "support@safesense.com",
                    onTap: _launchEmail,
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(height: 1),
                  _buildContactTile(
                    context,
                    icon: Icons.phone_rounded,
                    title: "Phone Support",
                    subtitle: "+1-800-SAFESENSE",
                    onTap: _launchPhone,
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(height: 1),
                  _buildContactTile(
                    context,
                    icon: Icons.public_rounded,
                    title: "Help Center",
                    subtitle: "Visit our website for guides",
                    onTap: _launchWebsite,
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),

              SizedBox(height: isSmallScreen ? 16 : 20),

              // FAQs Section
              _buildSectionCard(
                context,
                title: "Frequently Asked Questions",
                icon: Icons.help_outline_rounded,
                isSmallScreen: isSmallScreen,
                children: [
                  _buildFAQTile(
                    context,
                    question: "How do I add emergency contacts?",
                    answer: "Tap the Contacts button on the home screen (person icon), then tap the '+' button to select contacts from your phone's contact list.",
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(height: 1),
                  _buildFAQTile(
                    context,
                    question: "How does the SOS feature work?",
                    answer: "Press the red SOS button and wait for the 5-second countdown. After the countdown, your location and emergency message will be sent to all your emergency contacts via SMS. You can cancel anytime during the countdown.",
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(height: 1),
                  _buildFAQTile(
                    context,
                    question: "What are sessions?",
                    answer: "Sessions track your location and time during activities. Start a session before your activity, and end it when you're safe. This creates a log of your movements for safety purposes.",
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(height: 1),
                  _buildFAQTile(
                    context,
                    question: "Why isn't location working?",
                    answer: "Make sure you've granted location permissions to SafeSense in your phone's settings. Also ensure your GPS is turned on and you have a clear view of the sky for better accuracy.",
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(height: 1),
                  _buildFAQTile(
                    context,
                    question: "Can I export my session history?",
                    answer: "Currently, session history is stored locally in the app. We're working on adding export functionality in a future update. Stay tuned!",
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),

              SizedBox(height: isSmallScreen ? 16 : 20),

              // Resources Section
              _buildSectionCard(
                context,
                title: "Resources",
                icon: Icons.library_books_rounded,
                isSmallScreen: isSmallScreen,
                children: [
                  _buildResourceTile(
                    context,
                    icon: Icons.article_rounded,
                    title: "User Guide",
                    subtitle: "Complete guide to using SafeSense",
                    onTap: () {
                      showMessage(context, "Opening user guide...", type: MessageType.info);
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(height: 1),
                  _buildResourceTile(
                    context,
                    icon: Icons.videocam_rounded,
                    title: "Video Tutorials",
                    subtitle: "Watch how-to videos",
                    onTap: () {
                      showMessage(context, "Opening tutorials...", type: MessageType.info);
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(height: 1),
                  _buildResourceTile(
                    context,
                    icon: Icons.privacy_tip_rounded,
                    title: "Safety Tips",
                    subtitle: "Learn personal safety best practices",
                    onTap: () {
                      showMessage(context, "Opening safety tips...", type: MessageType.info);
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),

              SizedBox(height: isSmallScreen ? 16 : 20),

              // Feedback Section
              _buildSectionCard(
                context,
                title: "Feedback",
                icon: Icons.feedback_rounded,
                isSmallScreen: isSmallScreen,
                children: [
                  _buildResourceTile(
                    context,
                    icon: Icons.bug_report_rounded,
                    title: "Report a Bug",
                    subtitle: "Help us improve SafeSense",
                    onTap: () {
                      showMessage(context, "Opening bug report form...", type: MessageType.info);
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(height: 1),
                  _buildResourceTile(
                    context,
                    icon: Icons.lightbulb_outline_rounded,
                    title: "Suggest a Feature",
                    subtitle: "Share your ideas with us",
                    onTap: () {
                      showMessage(context, "Opening feature request form...", type: MessageType.info);
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),

              SizedBox(height: isSmallScreen ? 24 : 32),
            ],
          ),
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

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: isSmallScreen ? 12 : 16,
        ),
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
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(
    BuildContext context, {
    required String question,
    required String answer,
    required bool isSmallScreen,
  }) {
    return InkWell(
      onTap: () => _showFAQDialog(context, question, answer),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: isSmallScreen ? 12 : 16,
        ),
        child: Row(
          children: [
            Icon(
              Icons.question_answer_rounded,
              size: isSmallScreen ? 20 : 22,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: isSmallScreen ? 12 : 16,
        ),
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
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
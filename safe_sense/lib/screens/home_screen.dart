// lib/screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/session.dart';
import '../models/sos_contact.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../utils/helpers.dart';
import '../widgets/main_dashboard_page.dart';
import '../widgets/logs_page.dart';
import '../widgets/settings_page.dart';
import 'contacts_page.dart';
import 'profile_setup_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Session? _currentSession;
  final List<Session> _sessionLogs = [];
  bool _isLoading = false;
  bool _profileCheckDone = false; // Add this

  List<SOSContact> _sosContacts = [];
  bool _isSosCountdownActive = false;
  int _countdownValue = 5;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _checkProfileCompletion(); // Add this
  }

  // Add this method
  Future<void> _checkProfileCompletion() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final db = DatabaseService();
      
      // Get user document
      final userDoc = await db.userExists(user.uid);
      
      if (!userDoc) {
        // User document doesn't exist, show profile setup
        if (mounted) {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProfileSetupScreen(),
              fullscreenDialog: true,
            ),
          );
          
          if (result == true) {
            setState(() => _profileCheckDone = true);
          }
        }
      } else {
        setState(() => _profileCheckDone = true);
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  // ... rest of your existing code (keep everything else the same)
  
  void _startSosCountdown() {
    if (_sosContacts.isEmpty) {
      showMessage(context, "Please add at least one SOS contact first.", type: MessageType.info);
      return;
    }
    setState(() => _isSosCountdownActive = true);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _countdownValue--);
      if (_countdownValue == 0) {
        timer.cancel();
        _sendSms();
      }
    });
  }

  void _cancelSosCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _isSosCountdownActive = false;
      _countdownValue = 5;
    });
    showMessage(context, "SOS Canceled", type: MessageType.info);
  }

  Future<void> _sendSms() async {
    final String location = await getCurrentLocation();
    final String message = "SOS! I am in an emergency. My last known location is: $location";
    final List<String> recipients = _sosContacts.map((c) => c.number).toList();

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: recipients.join(','),
      queryParameters: {'body': message},
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        throw 'Could not launch SMS app.';
      }
    } catch (e) {
      if (mounted) showMessage(context, 'Error sending SOS: ${e.toString()}', type: MessageType.error);
    } finally {
      if (mounted) {
         setState(() {
          _isSosCountdownActive = false;
          _countdownValue = 5;
        });
      }
    }
  }

  void _toggleSession() async {
    setState(() => _isLoading = true);
    try {
      if (_currentSession == null) {
        final startTime = DateTime.now();
        final startLocation = await getCurrentLocation();
        setState(() {
          _currentSession = Session(
            startTime: startTime,
            endTime: startTime,
            startLocation: startLocation,
            endLocation: "",
          );
        });
        showMessage(context, "Session started!", type: MessageType.success);
      } else {
        final endTime = DateTime.now();
        final endLocation = await getCurrentLocation();
        final completedSession = Session(
          startTime: _currentSession!.startTime,
          startLocation: _currentSession!.startLocation,
          endTime: endTime,
          endLocation: endLocation,
        );
        setState(() {
          _sessionLogs.insert(0, completedSession);
          _currentSession = null;
        });
        showMessage(context, "Session logged successfully!", type: MessageType.success);
      }
    } catch (e) {
      showMessage(context, e.toString(), type: MessageType.error);
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  void _navigateAndManageContacts(BuildContext context) async {
    final List<SOSContact>? updatedContacts = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactsPage(initialContacts: _sosContacts),
      ),
    );

    if (updatedContacts != null) {
      setState(() {
        _sosContacts = updatedContacts;
      });
      showMessage(context, "Contacts updated!", type: MessageType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final DatabaseService db = DatabaseService();
    final user = FirebaseAuth.instance.currentUser;
    final screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<Map<String, dynamic>?>(
      stream: db.getUserData(user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final userData = snapshot.data;
        final userName = userData?['name'] ?? 'User';

        final List<Widget> pages = [
          MainDashboardPage(
            userData: userData,
            isSessionActive: _currentSession != null,
            isLoading: _isLoading,
            onToggleSession: _toggleSession,
          ),
          LogsPage(sessionLogs: _sessionLogs),
          const SettingsPage(),
        ];

        return Stack(
          children: [
            Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: Text(
                  '${getGreeting()}, $userName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: kToolbarHeight,
                titleSpacing: 16,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () async => await auth.signOut(),
                      icon: const Icon(Icons.logout_rounded),
                      iconSize: 18,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  )
                ],
              ),
              body: pages[_selectedIndex],
              floatingActionButton: _selectedIndex == 0
                  ? Padding(
                      padding: EdgeInsets.only(
                        bottom: screenHeight < 700 ? 8 : 16,
                        right: 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: FloatingActionButton.small(
                              onPressed: () => _navigateAndManageContacts(context),
                              backgroundColor: Colors.white,
                              foregroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              heroTag: "contacts",
                              child: const Icon(Icons.contacts_rounded, size: 20),
                            ),
                          ),
                          SizedBox(height: screenHeight < 700 ? 12 : 16),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: FloatingActionButton(
                              onPressed: _startSosCountdown,
                              backgroundColor: Theme.of(context).colorScheme.error,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              heroTag: "sos",
                              child: const Icon(Icons.emergency, size: 26),
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_rounded),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.history_rounded),
                          label: 'Logs',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings_rounded),
                          label: 'Settings',
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                      type: BottomNavigationBarType.fixed,
                      selectedFontSize: 12,
                      unselectedFontSize: 11,
                      iconSize: 22,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            if (_isSosCountdownActive)
              Container(
                color: Colors.black.withOpacity(0.9),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenHeight < 700 ? 180 : 200,
                        height: screenHeight < 700 ? 180 : 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 50,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _countdownValue > 0 ? "$_countdownValue" : "SENT",
                            style: TextStyle(
                              fontSize: screenHeight < 700 ? 50 : 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight < 700 ? 32 : 40),
                      if (_countdownValue > 0)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _cancelSosCountdown,
                          child: const Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
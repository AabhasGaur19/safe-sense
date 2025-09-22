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

  // SOS state management
  List<SOSContact> _sosContacts = [];
  bool _isSosCountdownActive = false;
  int _countdownValue = 5;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  // SOS Logic
  void _startSosCountdown() {
    if (_sosContacts.isEmpty) {
      showMessage(context, "Please add at least one SOS contact first.");
      return;
    }

    setState(() => _isSosCountdownActive = true);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    showMessage(context, "SOS Canceled", color: Colors.blueGrey);
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
        setState(() {
          _isSosCountdownActive = false;
          _countdownValue = 5;
        });
      } else {
        throw 'Could not launch SMS app.';
      }
    } catch (e) {
      showMessage(context, 'Error sending SOS: ${e.toString()}');
      setState(() {
        _isSosCountdownActive = false;
        _countdownValue = 5;
      });
    }
  }

  // Session Logic
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
        showMessage(context, "Session started!", color: Colors.green);
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
        showMessage(context, "Session logged successfully!", color: Colors.blue);
      }
    } catch (e) {
      showMessage(context, e.toString());
    } finally {
      setState(() => _isLoading = false);
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
      showMessage(context, "Contacts updated!", color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final DatabaseService db = DatabaseService();
    final user = FirebaseAuth.instance.currentUser;

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
              appBar: AppBar(
                title: Text('${getGreeting()}, $userName'),
                backgroundColor: Colors.white,
                elevation: 0,
                foregroundColor: Colors.black,
                actions: [
                  IconButton(
                    onPressed: () async => await auth.signOut(),
                    icon: const Icon(Icons.logout),
                  )
                ],
              ),
              body: pages[_selectedIndex],
              floatingActionButton: _selectedIndex == 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton.small(
                          onPressed: () => _navigateAndManageContacts(context),
                          tooltip: 'Add SOS Contacts',
                          child: const Icon(Icons.contact_emergency),
                        ),
                        const SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: _startSosCountdown,
                          backgroundColor: Colors.indigo,
                          tooltip: 'Activate SOS',
                          child: const Icon(Icons.sos_outlined, color: Colors.white),
                        ),
                      ],
                    )
                  : null,
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Logs'),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.indigo,
                onTap: _onItemTapped,
              ),
            ),
            // Countdown overlay
            if (_isSosCountdownActive)
              Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _countdownValue > 0 ? "$_countdownValue" : "SOS\nSENT",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 120,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (_countdownValue > 0)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          onPressed: _cancelSosCountdown,
                          child: const Text("Cancel", style: TextStyle(fontSize: 20)),
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
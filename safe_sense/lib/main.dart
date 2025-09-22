// import 'dart:async'; // ✅ Import for Timer
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firebase_options.dart';

// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:intl/intl.dart';

// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';

// // ✅ NEW IMPORTS
// import 'package:url_launcher/url_launcher.dart';

// // --- (main, showMessage, getGreeting, and Services are unchanged) ---
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// // ✅ NEW SOS CONTACT MODEL
// class SOSContact {
//   final String name;
//   final String number;

//   SOSContact({required this.name, required this.number});
// }

// class Session {
//   final DateTime startTime;
//   final DateTime endTime;
//   final String startLocation;
//   final String endLocation;
//   final Duration duration;

//   Session({
//     required this.startTime,
//     required this.endTime,
//     required this.startLocation,
//     required this.endLocation,
//   }) : duration = endTime.difference(startTime);
// }
// void showMessage(BuildContext context, String message,
//     {Color color = Colors.redAccent}) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(message, style: const TextStyle(fontSize: 16)),
//       backgroundColor: color,
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.all(20),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//     ),
//   );
// }
// String getGreeting() {
//   final hour = DateTime.now().hour;
//   if (hour < 12) return 'Good morning';
//   if (hour < 17) return 'Good afternoon';
//   return 'Good evening';
// }

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   Stream<User?> get user => _auth.authStateChanges();
//   Future<User?> signInWithEmailAndPassword(String email, String password) async {
//     final result =
//     await _auth.signInWithEmailAndPassword(email: email, password: password);
//     return result.user;
//   }
//   Future<User?> registerWithEmailAndPassword(
//       String email, String password) async {
//     final result = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     return result.user;
//   }
//   Future<void> signOut() async => _auth.signOut();
// }
// class DatabaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Future<void> addUserData(String uid, String name, int age) async {
//     await _firestore.collection('users').doc(uid).set({
//       'name': name,
//       'age': age,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
//   Stream<Map<String, dynamic>?> getUserData(String uid) {
//     return _firestore.collection('users').doc(uid).snapshots().map((snap) {
//       return snap.exists ? snap.data() : null;
//     });
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Auth App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: "Poppins",
//         // brightness: Brightlight,
//         primarySwatch: Colors.indigo,
//       ),
//       home: const Wrapper(),
//     );
//   }
// }
// class Wrapper extends StatelessWidget {
//   const Wrapper({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final AuthService authService = AuthService();
//     return StreamBuilder<User?>(
//       stream: authService.user,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           return snapshot.data == null ? const AuthScreen() : const HomeScreen();
//         }
//         return const Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         );
//       },
//     );
//   }
// }
// // --- (AuthScreen and its child views are unchanged) ---
// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});
//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }
// class _AuthScreenState extends State<AuthScreen> {
//   final PageController _pageController = PageController();
//   bool _isLogin = true;
//   void togglePage() {
//     setState(() => _isLogin = !_isLogin);
//     _pageController.animateToPage(
//       _isLogin ? 0 : 1,
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeInOut,
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 const Icon(Icons.shield_outlined, size: 100, color: Colors.white),
//                 const SizedBox(height: 20),
//                 Text(
//                   _isLogin ? "Welcome Back" : "Create Account",
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _isLogin
//                       ? "Login to continue"
//                       : "Sign up to start your journey",
//                   style: TextStyle(color: Colors.white.withOpacity(0.8)),
//                 ),
//                 const SizedBox(height: 30),
//                 Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: 20,
//                           color: Colors.black.withOpacity(0.2),
//                           offset: const Offset(0, 8))
//                     ],
//                   ),
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.55,
//                     child: PageView(
//                       controller: _pageController,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         LoginView(togglePage: togglePage),
//                         SignUpView(togglePage: togglePage),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class LoginView extends StatefulWidget {
//   final VoidCallback togglePage;
//   const LoginView({required this.togglePage, super.key});
//   @override
//   State<LoginView> createState() => _LoginViewState();
// }
// class _LoginViewState extends State<LoginView> {
//   final AuthService _authService = AuthService();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   bool _loading = false;
//   Future<void> _login() async {
//     setState(() => _loading = true);
//     try {
//       await _authService.signInWithEmailAndPassword(
//           _email.text.trim(), _password.text.trim());
//     } on FirebaseAuthException catch (e) {
//       showMessage(context, e.message ?? "Login failed");
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         TextField(controller: _email, decoration: const InputDecoration(labelText: "Email")),
//         const SizedBox(height: 16),
//         TextField(controller: _password, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
//         const SizedBox(height: 28),
//         _loading
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.indigo,
//             minimumSize: const Size(double.infinity, 50),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           onPressed: _login,
//           child: const Text("Log In",style: TextStyle(color: Colors.white),),
//         ),
//         const SizedBox(height: 20),
//         GestureDetector(
//           onTap: widget.togglePage,
//           child: const Text("Don't have an account? Sign Up",
//               style: TextStyle(color: Colors.indigo)),
//         ),
//       ],
//     );
//   }
// }
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
//     setState(() => _loading = true);
//     try {
//       final user = await _auth.registerWithEmailAndPassword(
//           _email.text.trim(), _password.text.trim());
//       if (user != null) {
//         await _db.addUserData(
//             user.uid, _name.text.trim(), int.tryParse(_age.text) ?? 0);
//       }
//     } on FirebaseAuthException catch (e) {
//       showMessage(context, e.message ?? "Signup failed");
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         TextField(controller: _name, decoration: const InputDecoration(labelText: "Full Name")),
//         const SizedBox(height: 16),
//         TextField(controller: _email, decoration: const InputDecoration(labelText: "Email")),
//         const SizedBox(height: 16),
//         TextField(controller: _password, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
//         const SizedBox(height: 16),
//         TextField(controller: _age, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
//         const SizedBox(height: 28),
//         _loading
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.indigo,
//             minimumSize: const Size(double.infinity, 50),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           onPressed: _signup,
//           child: const Text("Sign Up",style: TextStyle(color: Colors.white)),
//         ),
//         const SizedBox(height: 20),
//         GestureDetector(
//           onTap: widget.togglePage,
//           child: const Text("Already have an account? Log In",
//               style: TextStyle(color: Colors.indigo)),
//         ),
//       ],
//     );
//   }
// }


// // -------------------- HOME SCREEN --------------------
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   Session? _currentSession;
//   final List<Session> _sessionLogs = [];
//   bool _isLoading = false;

//   // ✅ NEW SOS STATE MANAGEMENT
//   List<SOSContact> _sosContacts = []; // In-memory list. For production, use persistent storage.
//   bool _isSosCountdownActive = false;
//   int _countdownValue = 5;
//   Timer? _countdownTimer;

//   @override
//   void dispose() {
//     _countdownTimer?.cancel(); // Important to avoid memory leaks
//     super.dispose();
//   }

//   // ✅ NEW SOS LOGIC
//   void _startSosCountdown() {
//     if (_sosContacts.isEmpty) {
//       showMessage(context, "Please add at least one SOS contact first.");
//       return;
//     }

//     setState(() => _isSosCountdownActive = true);

//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() => _countdownValue--);
//       if (_countdownValue == 0) {
//         timer.cancel();
//         _sendSms();
//       }
//     });
//   }

//   void _cancelSosCountdown() {
//     _countdownTimer?.cancel();
//     setState(() {
//       _isSosCountdownActive = false;
//       _countdownValue = 5; // Reset
//     });
//     showMessage(context, "SOS Canceled", color: Colors.blueGrey);
//   }

//   Future<void> _sendSms() async {
//     final String location = await _getCurrentLocation();
//     final String message = "SOS! I am in an emergency. My last known location is: $location";
//     final List<String> recipients = _sosContacts.map((c) => c.number).toList();

//     // This URI format is crucial for sending to multiple recipients.
//     // It opens the default SMS app with fields pre-filled.
//     final Uri smsUri = Uri(
//       scheme: 'sms',
//       path: recipients.join(','), // Comma-separated for multiple numbers
//       queryParameters: {'body': message},
//     );

//     try {
//       if (await canLaunchUrl(smsUri)) {
//         await launchUrl(smsUri);
//         setState(() {
//           _isSosCountdownActive = false;
//           _countdownValue = 5; // Reset
//         });
//       } else {
//         throw 'Could not launch SMS app.';
//       }
//     } catch (e) {
//       showMessage(context, 'Error sending SOS: ${e.toString()}');
//       setState(() {
//         _isSosCountdownActive = false;
//         _countdownValue = 5; // Reset
//       });
//     }
//   }


//   // --- (Existing session logic is mostly unchanged) ---
//   Future<String> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return Future.error('Location services are disabled.');
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
//     }
//     if (permission == LocationPermission.deniedForever) return Future.error('Location permissions are permanently denied');
//     try {
//       Position position = await Geolocator.getCurrentPosition();
//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       return "${place.locality}, ${place.administrativeArea}";
//     } catch (e) {
//       return "Could not get location";
//     }
//   }

//   void _toggleSession() async {
//     setState(() => _isLoading = true);
//     try {
//       if (_currentSession == null) {
//         final startTime = DateTime.now();
//         final startLocation = await _getCurrentLocation();
//         setState(() {
//           _currentSession = Session(
//               startTime: startTime,
//               endTime: startTime,
//               startLocation: startLocation,
//               endLocation: "");
//         });
//         showMessage(context, "Session started!", color: Colors.green);
//       } else {
//         final endTime = DateTime.now();
//         final endLocation = await _getCurrentLocation();
//         final completedSession = Session(
//           startTime: _currentSession!.startTime,
//           startLocation: _currentSession!.startLocation,
//           endTime: endTime,
//           endLocation: endLocation,
//         );
//         setState(() {
//           _sessionLogs.insert(0, completedSession);
//           _currentSession = null;
//         });
//         showMessage(context, "Session logged successfully!", color: Colors.blue);
//       }
//     } catch (e) {
//       showMessage(context, e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _onItemTapped(int index) => setState(() => _selectedIndex = index);

//   // ✅ NEW: Navigate to contacts page
//   void _navigateAndManageContacts(BuildContext context) async {
//     final List<SOSContact>? updatedContacts = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ContactsPage(initialContacts: _sosContacts)),
//     );

//     if (updatedContacts != null) {
//       setState(() {
//         _sosContacts = updatedContacts;
//       });
//       showMessage(context, "Contacts updated!", color: Colors.blue);
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     final AuthService auth = AuthService();
//     final DatabaseService db = DatabaseService();
//     final user = FirebaseAuth.instance.currentUser;

//     return StreamBuilder<Map<String, dynamic>?>(
//       stream: db.getUserData(user!.uid),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         }

//         final userData = snapshot.data;
//         final userName = userData?['name'] ?? 'User';

//         final List<Widget> pages = [
//           MainDashboardPage(
//             userData: userData,
//             isSessionActive: _currentSession != null,
//             isLoading: _isLoading,
//             onToggleSession: _toggleSession,
//           ),
//           LogsPage(sessionLogs: _sessionLogs),
//           const SettingsPage(),
//         ];

//         // ✅ NEW: Wrap with a Stack to show the countdown overlay
//         return Stack(
//           children: [
//             Scaffold(
//               appBar: AppBar(
//                 title: Text('${getGreeting()}, $userName'),
//                 backgroundColor: Colors.white,
//                 elevation: 0,
//                 foregroundColor: Colors.black,
//                 actions: [
//                   IconButton(
//                       onPressed: () async => await auth.signOut(),
//                       icon: const Icon(Icons.logout))
//                 ],
//               ),
//               body: pages[_selectedIndex],
//               // ✅ NEW: Column of Floating Action Buttons
//               floatingActionButton: _selectedIndex == 0
//                   ? Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   FloatingActionButton.small(
//                     onPressed: () => _navigateAndManageContacts(context),
//                     tooltip: 'Add SOS Contacts',
//                     child: const Icon(Icons.contact_emergency),
//                   ),
//                   const SizedBox(height: 16),
//                   FloatingActionButton(
//                     onPressed: _startSosCountdown,
//                     backgroundColor: Colors.indigo,
//                     tooltip: 'Activate SOS',
//                     child: const Icon(Icons.sos_outlined, color: Colors.white),
//                   ),
//                 ],
//               )
//                   : null,
//               bottomNavigationBar: BottomNavigationBar(
//                 items: const <BottomNavigationBarItem>[
//                   BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//                   BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Logs'),
//                   BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//                 ],
//                 currentIndex: _selectedIndex,
//                 selectedItemColor: Colors.indigo,
//                 onTap: _onItemTapped,
//               ),
//             ),
//             // ✅ NEW: The countdown overlay UI
//             if (_isSosCountdownActive)
//               Container(
//                 color: Colors.black.withOpacity(0.8),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         _countdownValue > 0 ? "$_countdownValue" : "SOS\nSENT",
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 120,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.none
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                       if (_countdownValue > 0)
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               foregroundColor: Colors.red,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 40, vertical: 15)),
//                           onPressed: _cancelSosCountdown,
//                           child: const Text("Cancel", style: TextStyle(fontSize: 20)),
//                         ),
//                     ],
//                   ),
//                 ),
//               )
//           ],
//         );
//       },
//     );
//   }
// }

// // --- (MainDashboard, LogsPage, SettingsPage are mostly unchanged) ---
// class MainDashboardPage extends StatelessWidget {
//   final Map<String, dynamic>? userData;
//   final bool isSessionActive;
//   final bool isLoading;
//   final VoidCallback onToggleSession;

//   const MainDashboardPage({
//     super.key,
//     required this.userData,
//     required this.isSessionActive,
//     required this.isLoading,
//     required this.onToggleSession,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (userData != null)
//                 Column(
//                   children: [
//                     Text("Name: ${userData!['name']}",
//                         style: const TextStyle(fontSize: 18)),
//                     const SizedBox(height: 8),
//                     Text("Age: ${userData!['age']}",
//                         style: const TextStyle(fontSize: 18)),
//                   ],
//                 ),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: 180,
//                 height: 180,
//                 child: isLoading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                   onPressed: onToggleSession,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                     isSessionActive ? Colors.green : Colors.indigo,
//                     shape: const CircleBorder(),
//                     padding: const EdgeInsets.all(24),
//                   ),
//                   child: Text(
//                     isSessionActive ? "Stop\nSession" : "Start",
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class LogsPage extends StatelessWidget {
//   final List<Session> sessionLogs;
//   const LogsPage({super.key, required this.sessionLogs});

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (sessionLogs.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.list_alt, size: 80, color: Colors.grey),
//             SizedBox(height: 16),
//             Text('No Session Logs', style: TextStyle(fontSize: 24, color: Colors.grey)),
//             Text('Start and stop a session to see it here.', style: TextStyle(color: Colors.grey)),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: sessionLogs.length,
//       itemBuilder: (context, index) {
//         final session = sessionLogs[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(16),
//             leading: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.timer_outlined, color: Colors.indigo),
//                 const SizedBox(height: 4),
//                 Text(
//                   _formatDuration(session.duration),
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.indigo),
//                 ),
//               ],
//             ),
//             title: Text(
//               DateFormat('MMMM dd, yyyy').format(session.startTime),
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 8),
//                 Text("From: ${session.startLocation}", style: TextStyle(color: Colors.grey[700])),
//                 Text("To:      ${session.endLocation}", style: TextStyle(color: Colors.grey[700])),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Time: ${DateFormat.jm().format(session.startTime)} - ${DateFormat.jm().format(session.endTime)}",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.settings, size: 80, color: Colors.grey),
//             SizedBox(height: 16),
//             Text('Settings Page', style: TextStyle(fontSize: 24)),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // ✅ CONTACTS MANAGEMENT PAGE (Using permission_handler)
// class ContactsPage extends StatefulWidget {
//   final List<SOSContact> initialContacts;
//   const ContactsPage({super.key, required this.initialContacts});

//   @override
//   State<ContactsPage> createState() => _ContactsPageState();
// }

// class _ContactsPageState extends State<ContactsPage> {
//   late List<SOSContact> _contacts;

//   @override
//   void initState() {
//     super.initState();
//     _contacts = List.from(widget.initialContacts);
//   }

//   // ✅ ENTIRE METHOD REWRITTEN FOR ROBUST PERMISSION HANDLING
//   Future<void> _pickContact() async {
//     // 1. Check the status of the contacts permission
//     PermissionStatus status = await Permission.contacts.status;

//     // 2. If permission is not granted, request it.
//     if (!status.isGranted) {
//       status = await Permission.contacts.request();
//     }

//     // 3. Check the final status and act accordingly
//     if (status.isGranted) {
//       // Permission is granted, proceed to open the contact picker
//       try {
//         Contact? contact = await FlutterContacts.openExternalPick();

//         if (contact != null && contact.phones.isNotEmpty) {
//           bool exists = _contacts.any((c) => c.number == contact.phones.first.number);
//           if (exists) {
//             showMessage(context, "${contact.displayName} is already in the list.", color: Colors.orange);
//             return;
//           }
//           setState(() {
//             _contacts.add(SOSContact(
//                 name: contact.displayName, number: contact.phones.first.number));
//           });
//         }
//       } catch (e) {
//         showMessage(context, "Failed to pick contact: ${e.toString()}");
//       }
//     } else if (status.isPermanentlyDenied) {
//       // If permission is permanently denied, show a dialog to open app settings
//       showMessage(context, "Contact permission is permanently denied. Please enable it in settings.");
//       openAppSettings(); // This is a helper function from the permission_handler package
//     } else {
//       // If permission is just denied, show the message
//       showMessage(context, "Contact permission is required to add contacts.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SOS Contacts'),
//         leading: BackButton(
//           onPressed: () => Navigator.pop(context, _contacts),
//         ),
//       ),
//       body: _contacts.isEmpty
//           ? const Center(child: Text("No contacts added yet."))
//           : ListView.builder(
//               itemCount: _contacts.length,
//               itemBuilder: (context, index) {
//                 final contact = _contacts[index];
//                 return ListTile(
//                   title: Text(contact.name),
//                   subtitle: Text(contact.number),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       setState(() {
//                         _contacts.removeAt(index);
//                       });
//                     },
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _pickContact,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
























import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'services/auth_service.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: Colors.indigo,
      ),
      home: const Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  
  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return snapshot.data == null ? const AuthScreen() : const HomeScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
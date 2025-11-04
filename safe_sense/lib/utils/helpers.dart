import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// ✅ Define an enum for message types
enum MessageType { success, error, info }

// ✅ A completely redesigned showMessage function
void showMessage(BuildContext context, String message, {MessageType type = MessageType.error}) {
  // Determine color and icon based on message type
  Color backgroundColor;
  IconData iconData;

  switch (type) {
    case MessageType.success:
      backgroundColor = const Color(0xFF4CAF50); // Green
      iconData = Icons.check_circle_outline_rounded;
      break;
    case MessageType.error:
      backgroundColor = Theme.of(context).colorScheme.error; // Theme Error Red
      iconData = Icons.error_outline_rounded;
      break;
    case MessageType.info:
      backgroundColor = const Color(0xFF17a2b8); // A nice info blue/teal
      iconData = Icons.info_outline_rounded;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: 'Poppins'
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      elevation: 8.0,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}


String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

Future<String> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return Future.error('Location services are disabled.');

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  try {
    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude
    );
    Placemark place = placemarks[0];
    return "${place.locality}, ${place.administrativeArea}";
  } catch (e) {
    return "Could not get location";
  }
}
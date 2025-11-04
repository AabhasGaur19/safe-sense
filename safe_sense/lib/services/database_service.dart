// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==============================
  // 🧑‍💻 USER DATA METHODS
  // ==============================

  /// Add new user data (used when user signs up or first logs in)
  Future<void> addUserData(String uid, String name, int age, String email) async {
    try {
      print('Attempting to save user data for UID: $uid');

      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'age': age,
        'email': email,
        'profileComplete': true, // Add this flag
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('User data saved successfully!');
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  /// Get a real-time stream of user data
  Stream<Map<String, dynamic>?> getUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snap) {
      if (snap.exists && snap.data() != null) {
        return snap.data();
      } else {
        return null;
      }
    });
  }

  /// Update user profile (auto-creates doc if missing)
  Future<void> updateUserData(String uid, String name, int age) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'age': age,
        'email': FirebaseAuth.instance.currentUser?.email,
        'profileComplete': true,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print("✅ User data updated successfully for $uid");
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }

  /// Delete user data (and associated settings)
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      await _firestore
          .collection('user_settings')
          .doc(uid)
          .collection('notifications')
          .doc('settings')
          .delete();
      await _firestore
          .collection('user_settings')
          .doc(uid)
          .collection('privacy')
          .doc('settings')
          .delete();

      print('User data deleted successfully!');
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow;
    }
  }

  /// Check if user profile is complete
  Future<bool> isProfileComplete(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        return false;
      }
      
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        return false;
      }
      
      // Check if profileComplete flag exists and is true
      // OR check if name exists and is not empty/default
      final profileComplete = data['profileComplete'] == true;
      final hasValidName = data['name'] != null && 
                          data['name'].toString().isNotEmpty &&
                          !data['name'].toString().contains('@'); // Not an email
      
      return profileComplete && hasValidName;
    } catch (e) {
      print('Error checking profile completion: $e');
      return false;
    }
  }

  /// Check if user exists in Firestore
  Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }

  // ==============================
  // 🔔 NOTIFICATION SETTINGS METHODS
  // ==============================

  Future<Map<String, dynamic>?> getNotificationSettings(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('user_settings')
          .doc(uid)
          .collection('notifications')
          .doc('settings')
          .get();

      return doc.exists ? doc.data() as Map<String, dynamic>? : null;
    } catch (e) {
      print('Error getting notification settings: $e');
      return null;
    }
  }

  Future<void> updateNotificationSettings(String uid, Map<String, dynamic> settings) async {
    try {
      await _firestore
          .collection('user_settings')
          .doc(uid)
          .collection('notifications')
          .doc('settings')
          .set({
        ...settings,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating notification settings: $e');
      rethrow;
    }
  }

  // ==============================
  // 🔒 PRIVACY SETTINGS METHODS
  // ==============================

  Future<Map<String, dynamic>?> getPrivacySettings(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('user_settings')
          .doc(uid)
          .collection('privacy')
          .doc('settings')
          .get();

      return doc.exists ? doc.data() as Map<String, dynamic>? : null;
    } catch (e) {
      print('Error getting privacy settings: $e');
      return null;
    }
  }

  Future<void> updatePrivacySettings(String uid, Map<String, dynamic> settings) async {
    try {
      await _firestore
          .collection('user_settings')
          .doc(uid)
          .collection('privacy')
          .doc('settings')
          .set({
        ...settings,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating privacy settings: $e');
      rethrow;
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> addUserData(String uid, String name, int age) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'age': age,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
  
  Stream<Map<String, dynamic>?> getUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snap) {
      return snap.exists ? snap.data() : null;
    });
  }
}
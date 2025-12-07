import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(AppUser user) async {
    await _db.collection("users").doc(user.uid).set(user.toMap());
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      final doc = await _db.collection("users").doc(uid).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }
}

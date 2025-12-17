import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================= USER =================

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

  // ================= DAILY HEALTH LOG =================

  Future<void> saveDailyLog({
    required String uid,
    required DateTime date,
    required int totalScore,
    required double efficiency,
    required String note,
    required Map<String, dynamic> todoData,
  }) async {
    final docId = _formatDate(date); // 2025-12-14

    await _db
        .collection("users")
        .doc(uid)
        .collection("daily_logs")
        .doc(docId)
        .set({
          "totalScore": totalScore,
          "efficiency": efficiency,
          "note": note,
          "todoData": todoData,
          "createdAt": FieldValue.serverTimestamp(),
        });
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal(); // 👈 Türkiye saatine çeker
    return "${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}";
  }
}

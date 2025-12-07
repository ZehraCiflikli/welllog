import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  bool isLoading = false;

  /// 🔥 Firebase'de o anda giriş yapan kullanıcıyı döner
  User? get user => FirebaseAuth.instance.currentUser;

  /// 🔥 Firestore'dan çekilen kullanıcı verisi
  Map<String, dynamic>? currentUserData;

  // ------------------------------- //
  //  REGISTER (KAYIT OLMA)
  // ------------------------------- //
  Future<String?> registerUser({
    required String fullName,
    required String email,
    required String password,
    required int age,
    required int height,
    required int weight,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final userCredential = await _authService.register(email, password);
      if (userCredential == null) return "Kayıt başarısız.";

      AppUser appUser = AppUser(
        uid: userCredential.uid,
        fullName: fullName,
        email: email,
        age: age,
        height: height,
        weight: weight,
      );

      await _firestoreService.saveUser(appUser);

      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // ------------------------------- //
  //  LOGIN (GİRİŞ YAPMA)
  // ------------------------------- //
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final loginResult = await _authService.login(email, password);
      if (loginResult == null) {
        isLoading = false;
        notifyListeners();
        return "E-posta veya şifre hatalı";
      }

      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // ------------------------------- //
  //  FIRESTORE -> KULLANICI VERISI GETIRME
  // ------------------------------- //
  Future<void> loadCurrentUser() async {
    if (user == null) return;

    final data = await _firestoreService.getUser(user!.uid);
    currentUserData = data;

    notifyListeners();
  }

  // ------------------------------- //
  //  LOGOUT (ÇIKIŞ YAPMA)
  // ------------------------------- //
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    currentUserData = null;
    notifyListeners();
  }

  Future<void> updateUserData({
    required String fullName,
    required int age,
    required int height,
    required int weight,
  }) async {
    if (user == null) return;

    await _firestoreService.updateUser(user!.uid, {
      "fullName": fullName,
      "age": age,
      "height": height,
      "weight": weight,
    });

    await loadCurrentUser(); // güncel veriyi yeniden çek
    notifyListeners();
  }
}

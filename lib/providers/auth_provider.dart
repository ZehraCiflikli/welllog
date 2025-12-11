import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Secure Storage için yeni import
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

// Secure Storage Tanımları
final _storage = const FlutterSecureStorage();
const String _isLoggedInKey = 'is_logged_in';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // Mevcut isLoading değişkeni uygulamanın genel yüklenme durumunu gösteriyor.
  // Oturum kontrolü için ayrı bir değişken tanımlayalım.
  bool _isAppLoading =
      true; // Uygulamanın başlangıçta oturum kontrolü yapıp yapmadığı
  bool _isLoggedIn = false; // Oturumun açık olup olmadığı

  bool get isAppLoading => _isAppLoading;
  bool get isLoggedIn => _isLoggedIn;

  // Mevcut isLoading değişkenini koruyoruz
  bool isLoading = false;

  /// 🔥 Firebase'de o anda giriş yapan kullanıcıyı döner
  User? get user => FirebaseAuth.instance.currentUser;

  /// 🔥 Firestore'dan çekilen kullanıcı verisi
  Map<String, dynamic>? currentUserData;

  // ----------------------------------------------------
  // 🔑 1. YENİ METOT: UYGULAMA BAŞLANGICINDA OTURUM KONTROLÜ
  // ----------------------------------------------------
  Future<void> autoLogin() async {
    _isAppLoading = true;
    notifyListeners();

    // Firebase Auth, token yönetimini ve oturumun kalıcılığını (restart'larda bile)
    // otomatik olarak halleder. Biz sadece durumu kontrol ediyoruz.
    final currentUser = _auth.currentUser; // Firebase'deki mevcut kullanıcı

    if (currentUser != null) {
      _isLoggedIn = true;
      // Oturum varsa, Firestore'dan kullanıcı verisini de çekelim
      await loadCurrentUser();
    } else {
      // Firebase'de kullanıcı yoksa, daha önce bir işaret koyup koymadığımızı kontrol et.
      // (Bu adım teknik olarak Firebase tarafından yapılmasına rağmen, mantıksal temizlik için faydalı)
      final storedStatus = await _storage.read(key: _isLoggedInKey);
      _isLoggedIn = storedStatus == 'true';
    }

    _isAppLoading = false;
    notifyListeners();
  }
  // ----------------------------------------------------

  // ------------------------------- //
  //  REGISTER (KAYIT OLMA)
  // ------------------------------- //
  // ... (Bu kısım aynı kalıyor) ...
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

      // Kayıt başarılıysa oturum işaretini kaydet
      await _storage.write(key: _isLoggedInKey, value: 'true');
      _isLoggedIn = true; // Durumu güncelle

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

      // 🔑 2. DEĞİŞİKLİK: Giriş başarılıysa kalıcılık işaretini kaydet
      await _storage.write(key: _isLoggedInKey, value: 'true');
      _isLoggedIn = true; // Durumu güncelle
      await loadCurrentUser(); // Kullanıcı verisini çek

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
  //  FIRESTORE -> KULLANICI VERISI GETIRME (AYNI KALIYOR)
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

    // 🔑 3. DEĞİŞİKLİK: Çıkışta kalıcılık işaretini sil
    await _storage.delete(key: _isLoggedInKey);

    _isLoggedIn = false; // Durumu güncelle
    currentUserData = null;
    notifyListeners();
  }

  // ... (updateUserData kısmı aynı kalıyor) ...
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

    await loadCurrentUser();
    notifyListeners();
  }

  Future<void> sendResetEmail() async {
    if (user == null) return;

    await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
  }
}

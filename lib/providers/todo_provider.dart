import 'package:flutter/material.dart';

class TodoProvider with ChangeNotifier {
  DateTime _lastResetDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int ruhHali = 0;        // 1–5
  int sigara = 0;         // adet
  int kahve = 0;          // 0–5
  double ekranSuresi = 0; // saat
  int adim = 0;           // adım
  int su = 0;             // bardak
  bool ciltBakimi = false;
  List<bool> ogunler = [false, false, false];
  double uyku = 0;        // saat

  void checkDailyReset() {
    final today = DateTime.now();
    final nowDay = DateTime(today.year, today.month, today.day);
    if (nowDay.isAfter(_lastResetDate)) {
      _resetAll();
      _lastResetDate = nowDay;
    }
  }

  void _resetAll() {
    ruhHali = 0;
    sigara = 0;
    kahve = 0;
    ekranSuresi = 0;
    adim = 0;
    su = 0;
    ciltBakimi = false;
    ogunler = [false, false, false];
    uyku = 0;
    notifyListeners();
  }

  // ================= SETTER =================
  void setRuhHali(int v) { checkDailyReset(); ruhHali = v; notifyListeners(); }
  void setSigara(int v) { checkDailyReset(); sigara = v; notifyListeners(); }
  void setKahve(int v) { checkDailyReset(); kahve = v; notifyListeners(); }
  void setEkran(double v) { checkDailyReset(); ekranSuresi = v; notifyListeners(); }
  void setAdim(int v) { checkDailyReset(); adim = v; notifyListeners(); }
  void setSu(int v) { checkDailyReset(); su = v; notifyListeners(); }
  void setCiltBakimi(bool v) { checkDailyReset(); ciltBakimi = v; notifyListeners(); }
  void toggleOgun(int i) { checkDailyReset(); ogunler[i] = !ogunler[i]; notifyListeners(); }
  void setUyku(double v) { checkDailyReset(); uyku = v; notifyListeners(); }

  // ================= PUAN HESABI =================

  double calculateScore() {
    checkDailyReset();

    final bool hasAnyInput =
        ruhHali > 0 ||
        sigara > 0 ||
        kahve > 0 ||
        ekranSuresi > 0 ||
        adim > 0 ||
        su > 0 ||
        uyku > 0 ||
        ciltBakimi ||
        ogunler.any((e) => e);

    if (!hasAnyInput) return 0;

    double score = 0;

    // 😊 Ruh Hali (max 10)
    score += (ruhHali.clamp(0, 5)) * 2;

    // 🚬 Sigara (max 10)
    score += (10 - (sigara * 2)).clamp(0, 10);

    // ☕ Kahve (max 10)
    score += (10 - ((kahve - 1).clamp(0, 4) * 2)).clamp(0, 10);

    // 🧴 Cilt Bakımı
    if (ciltBakimi) score += 10;

    // 📱 Ekran Süresi (1 saat = 10)
    score += (10 - (ekranSuresi - 1).clamp(0, 10)).clamp(0, 10);

    // 🍽️ Öğün (3×5)
    score += ogunler.where((e) => e).length * 5;

    // 🚶 Adım (1000 = 1)
    score += (adim / 1000).floor().clamp(0, 10);

    // 😴 Uyku
    if (uyku >= 8) {
      score += 15;
    } else if (uyku >= 4) {
      score += (15 - ((8 - uyku) * 3)).clamp(0, 15);
    }

    // 💧 Su
    score += su.clamp(0, 10);

    return (score / 100).clamp(0, 1);
  }
}

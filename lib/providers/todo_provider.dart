import 'package:flutter/material.dart';

class TodoProvider with ChangeNotifier {
  // ================== READONLY ==================
  bool isReadOnly = false;

  // ================== GÜN RESET ==================
  DateTime _lastResetDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  bool _didResetToday = false;

  void _checkDailyReset() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (today.isAfter(_lastResetDate)) {
      _resetAll();
      _lastResetDate = today;
      _didResetToday = true;
    }

    // 👉 Bugüne dönünce readonly kapalı olmalı
    isReadOnly = false;
  }

  bool consumeResetFlag() {
    if (_didResetToday) {
      _didResetToday = false;
      return true;
    }
    return false;
  }

  // ================== RESET ==================
  void _resetAll() {
    ruhHali = 0;
    sigara = -1;
    kahve = -1;

    ekranSuresi = -1;
    adim = 0;
    su = 0;

    ciltBakimi = false;
    ogunler = [false, false, false];

    uyku = -1;

    notifyListeners();
  }

  // ================== GÜNLÜK VERİLER ==================
  int ruhHali = 0;
  int sigara = -1;
  int kahve = -1;

  double ekranSuresi = -1;
  int adim = 0;
  int su = 0;

  bool ciltBakimi = false;
  List<bool> ogunler = [false, false, false];

  double uyku = -1;

  // ================== SETTER'LAR ==================
  void setRuhHali(int value) {
    _checkDailyReset();
    ruhHali = value;
    notifyListeners();
  }

  void setSigara(int value) {
    _checkDailyReset();
    sigara = value;
    notifyListeners();
  }

  void setKahve(int value) {
    _checkDailyReset();
    kahve = value;
    notifyListeners();
  }

  void setEkranSuresi(double value) {
    _checkDailyReset();
    ekranSuresi = value;
    notifyListeners();
  }

  void setAdim(int value) {
    _checkDailyReset();
    adim = value;
    notifyListeners();
  }

  void setSu(int value) {
    _checkDailyReset();
    su = value;
    notifyListeners();
  }

  void toggleCiltBakimi(bool value) {
    _checkDailyReset();
    ciltBakimi = value;
    notifyListeners();
  }

  void toggleOgun(int index) {
    _checkDailyReset();
    ogunler[index] = !ogunler[index];
    notifyListeners();
  }

  void setUyku(double value) {
    _checkDailyReset();
    uyku = value;
    notifyListeners();
  }

  // ================== PUANLAMA ==================
  double get maxScore => 100;

  double get totalScore {
    _checkDailyReset();
    double earned = 0;

    if (ruhHali > 0) earned += (ruhHali / 5) * 10;

    if (sigara >= 0) {
      if (sigara == 0)
        earned += 10;
      else if (sigara <= 5)
        earned += (10 - sigara * 2);
    }

    if (kahve >= 0) {
      if (kahve <= 1)
        earned += 10;
      else if (kahve <= 5)
        earned += (10 - (kahve - 1) * 2);
    }

    if (ciltBakimi) earned += 10;

    if (ekranSuresi >= 0) {
      earned += (10 - (ekranSuresi - 1)).clamp(0, 10);
    }

    earned += ogunler.where((e) => e).length * 5;
    earned += (adim / 1000).clamp(0, 10);

    if (uyku >= 0) {
      if (uyku >= 8)
        earned += 15;
      else if (uyku >= 4)
        earned += 15 - (8 - uyku) * 3;
    }

    earned += su.clamp(0, 10);

    return earned.clamp(0, maxScore);
  }

  // ================== FIRESTORE ==================
  Map<String, dynamic> toMap() {
    return {
      "ruhHali": ruhHali,
      "sigara": sigara,
      "kahve": kahve,
      "ekranSuresi": ekranSuresi,
      "adim": adim,
      "su": su,
      "ciltBakimi": ciltBakimi,
      "ogunler": ogunler,
      "uyku": uyku,
    };
  }

  void loadFromMap(Map<String, dynamic>? data) {
    if (data == null) {
      _resetAll();
      isReadOnly = true;
      notifyListeners();
      return;
    }

    final todo = data["todoData"] as Map<String, dynamic>;

    ruhHali = todo["ruhHali"] ?? 0;
    sigara = todo["sigara"] ?? -1;
    kahve = todo["kahve"] ?? -1;
    ekranSuresi = (todo["ekranSuresi"] ?? -1).toDouble();
    adim = todo["adim"] ?? 0;
    su = todo["su"] ?? 0;
    ciltBakimi = todo["ciltBakimi"] ?? false;
    ogunler = List<bool>.from(todo["ogunler"] ?? [false, false, false]);
    uyku = (todo["uyku"] ?? -1).toDouble();

    isReadOnly = true;
    notifyListeners();
  }

  double calculateScore() {
    return (totalScore / maxScore).clamp(0, 1);
  }
}

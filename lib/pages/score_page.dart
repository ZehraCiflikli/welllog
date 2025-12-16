import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:welllog/providers/todo_provider.dart';
import 'package:welllog/providers/auth_provider.dart';
import '../services/firestore_service.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final TextEditingController _noteController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  String _dailyQuote = "Yükleniyor...";
  String _quoteAuthor = "";
  bool _isLoadingQuote = true;

  bool _savedThisBuild = false; // 👈 bu sayfa açıldığında bir kere kaydetmek için

  @override
  void initState() {
    super.initState();
    _fetchDailyQuote();
  }

  Future<void> _saveDailyLog(
    BuildContext context,
    TodoProvider todo,
    AuthProvider auth,
  ) async {
    final uid = auth.currentUserData?["uid"];
    if (uid == null) return;

    try {
      await _firestoreService.saveDailyLog(
        uid: uid,
        date: DateTime.now(),
        totalScore: todo.totalScore.round(),
        efficiency: todo.calculateScore(), // 0–1
        note: _noteController.text.trim(),
        todoData: todo.toMap(),
      );

      // İstersen snackbar da göstermeyebilirsin, ben bilgi amaçlı bıraktım:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Günlük kayıt otomatik kaydedildi ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt sırasında hata oluştu ❌")),
      );
    }
  }

  /// 👇 Bu fonksiyon build içinde çağrılıyor, ama sadece 1 kere kayıt yapıyor
  void _autoSaveOncePerOpen(
    BuildContext context,
    TodoProvider todo,
    AuthProvider auth,
  ) {
    if (_savedThisBuild) return;

    _savedThisBuild = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveDailyLog(context, todo, auth);
    });
  }

  Future<void> _fetchDailyQuote() async {
    final uri = Uri.parse('https://zenquotes.io/api/random');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _dailyQuote = data[0]['q'] ?? "Alıntı bulunamadı.";
          _quoteAuthor = data[0]['a'] ?? "";
          _isLoadingQuote = false;
        });
      } else {
        _setQuoteError();
      }
    } catch (_) {
      _setQuoteError();
    }
  }

  void _setQuoteError() {
    setState(() {
      _dailyQuote = "Alıntı yüklenemedi.";
      _quoteAuthor = "";
      _isLoadingQuote = false;
    });
  }

  void _saveNote(BuildContext context) {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen bir not gir")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Not başarıyla kaydedildi ✅")),
    );

    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final todo = context.watch<TodoProvider>();
    final auth = context.watch<AuthProvider>();

    // 👇 SAYFA AÇILDIĞINDA/BUILDLANDIĞINDA OTOMATİK KAYIT
    _autoSaveOncePerOpen(context, todo, auth);

    final fullName =
        auth.currentUserData?["fullName"]?.split(" ").first ?? "Kullanıcı";

    final double totalScore = todo.totalScore;
    final double maxScore = todo.maxScore;
    final double efficiencyRatio =
        maxScore == 0 ? 0 : (totalScore / maxScore).clamp(0, 1);

    final int percentage = (efficiencyRatio * 100).round();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: Text(
          "$fullName'nın Günlük Özeti",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 🟢 VERİMLİLİK ÇEMBERİ
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: efficiencyRatio,
                    strokeWidth: 38,
                    backgroundColor: Colors.green.withOpacity(0.15),
                    color: Colors.green.withOpacity(0.55),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "%$percentage",
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text(
                      "Verimlilik",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 🌿 GÜNLÜK ALINTI
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _isLoadingQuote
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Text(
                            _dailyQuote,
                            style: GoogleFonts.poppins(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          if (_quoteAuthor.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "- $_quoteAuthor",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // 📝 GÜNÜN NOTU
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Günün Özeti",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Bugün nasıldı?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _saveNote(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Notu Kaydet"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            // ❌ Artık “Günü Kaydet” butonu YOK
          ],
        ),
      ),
    );
  }
}

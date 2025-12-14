import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:welllog/providers/todo_provider.dart';
import 'package:welllog/providers/auth_provider.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final TextEditingController _noteController = TextEditingController();

  String _dailyQuote = "Yükleniyor...";
  String _quoteAuthor = "";
  bool _isLoadingQuote = true;

  @override
  void initState() {
    super.initState();
    _fetchDailyQuote();
  }

  // 🌿 Günlük alıntı
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

  // 📝 Not kaydet (reset YOK)
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

    final fullName =
        auth.currentUserData?["fullName"]?.split(" ").first ?? "Kullanıcı";

    // 🎯 Score artık Provider’dan geliyor
    final double efficiencyScore = todo.calculateScore();
    final int percentage = (efficiencyScore * 100).round();

    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ STANDARD APPBAR
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

            // 🟢 SAYDAM & KALIN YÜZDELİK ÇEMBER
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: efficiencyScore.clamp(0, 1),
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

            const SizedBox(height: 20),

            Text(
              percentage >= 80
                  ? "Mükemmel bir gün! 🔥"
                  : percentage >= 60
                      ? "Gayet iyi gidiyorsun 👍"
                      : "Yarın daha iyi olacak 💪",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            // 💬 GÜNLÜK ALINTI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _isLoadingQuote
                  ? const CircularProgressIndicator(color: Colors.green)
                  : Column(
                      children: [
                        const Icon(Icons.format_quote,
                            color: Colors.green, size: 30),
                        const SizedBox(height: 10),
                        Text(
                          _dailyQuote,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.green.shade800,
                          ),
                        ),
                        if (_quoteAuthor.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "- $_quoteAuthor",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
            ),

            const SizedBox(height: 30),

            // 📝 NOT ALANI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_note, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "Güne Özel Bir Not",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText:
                          "Bugün neler hissettin? Buraya yazabilirsin...",
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ✅ NOTU KAYDET
            ElevatedButton(
              onPressed: () => _saveNote(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Notu Kaydet",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

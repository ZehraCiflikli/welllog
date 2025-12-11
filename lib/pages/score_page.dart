import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // http paketini ekledik

// NOT: pubspec.yaml dosyanıza http paketini eklemeyi unutmayın!
// dependencies:
//   flutter:
//     sdk: flutter
//   http: ^1.1.0 // veya en güncel sürüm

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final double efficiencyScore = 0.75;
  final TextEditingController _noteController = TextEditingController();

  // Alıntıyı saklamak için değişkenler
  String _dailyQuote = "Yükleniyor...";
  String _quoteAuthor = "";
  bool _isLoadingQuote = true;

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde alıntıyı çek
    _fetchDailyQuote();
  }

  // ZenQuotes API'den alıntı çekme fonksiyonu
  Future<void> _fetchDailyQuote() async {
    // API adresi: https://zenquotes.io/api/random
    final uri = Uri.parse('https://zenquotes.io/api/random');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // API'den gelen JSON verisini çözümle
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty && data[0] is Map) {
          setState(() {
            // 'q' alıntıyı, 'a' yazarı temsil eder
            _dailyQuote = data[0]['q'] ?? "Alıntı bulunamadı.";
            _quoteAuthor = data[0]['a'] ?? "Bilinmeyen Yazar";
            _isLoadingQuote = false;
          });
        }
      } else {
        // Hata durumunda (örneğin 404)
        setState(() {
          _dailyQuote = "Alıntı yüklenirken bir sorun oluştu.";
          _quoteAuthor = "";
          _isLoadingQuote = false;
        });
      }
    } catch (e) {
      // Ağ hatası veya JSON çözümleme hatası
      setState(() {
        _dailyQuote = "Ağ hatası: Alıntı yüklenemedi.";
        _quoteAuthor = "";
        _isLoadingQuote = false;
      });
      print('Alıntı çekme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Günün Özeti",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: efficiencyScore,
                    strokeWidth: 15,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.green,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "%${(efficiencyScore * 100).toInt()}",
                      style: const TextStyle(
                        fontSize: 40,
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
            // Burası eski Text widget'ının yeri:
            // Text(
            //   efficiencyScore >= 0.7
            //       ? "Harika bir gün! 🚀"
            //       : "Yarın daha iyisini yapabilirsin! ✨",
            //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            // ),

            // YENİ: Alıntı Bölümü
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _isLoadingQuote
                  ? const Center(child: CircularProgressIndicator(color: Colors.green))
                  : Column(
                children: [
                  const Icon(Icons.format_quote, color: Colors.green, size: 30),
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
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "- $_quoteAuthor",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Burası eski Padding/Text widget'ının yeri:
            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            //   child: Text(
            //     "Bugünkü hedeflerinin çoğuna ulaştın. Kendinle gurur duy!",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // ),

            const SizedBox(height: 20), // Ekstra boşluk eklendi

            // Mevcut Not Bölümü devam ediyor...
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
                    decoration: InputDecoration(
                      hintText: "Bugün neler hissettin? Buraya yazabilirsin...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Günün kaydedildi! 🎉")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Günü Tamamla",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
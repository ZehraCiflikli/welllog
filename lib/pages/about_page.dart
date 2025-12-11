import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: Text(
          "Hakkında",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------
            // UYGULAMA BAŞLIK + AÇIKLAMA
            // -------------------------
            Text(
              "WellLog",
              style: GoogleFonts.poppins(
                fontSize: 28,
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "WellLog, günlük yaşam alışkanlıklarını takip etmeyi kolaylaştıran, "
              "her gün küçük ama etkili adımlarla daha sağlıklı bir hayat kurmana yardımcı olan "
              "kişisel bir sağlık asistanıdır.\n\n"
              "Su tüketimi, uyku düzeni, öğün takibi, adım sayısı, cilt bakımı gibi "
              "hayat kalitesini etkileyen 9 farklı parametreyi tek bir ekranda kontrol edebilir, "
              "günün sonunda otomatik oluşturulan sağlık puanınla ilerlemeni takip edebilirsin.\n\n"
              "WellLog, alışkanlık oluşturma yolculuğunu daha keyifli ve sürdürülebilir hale getirmek amacıyla "
              "tasarlanmış sade, modern ve kullanıcı dostu bir uygulamadır.",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 30),

            // -------------------------
            // SÜRÜM BİLGİSİ
            // -------------------------
            Text(
              "Sürüm",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "1.0.0",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            // -------------------------
            // GELİŞTİRİCİLER
            // -------------------------
            Text(
              "Takım",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),

            const SizedBox(height: 10),

            // Developer 1 — Aysima
            Row(
              children: [
                Icon(Icons.terminal, color: Colors.green.shade700, size: 22),
                const SizedBox(width: 10),
                Text(
                  "Aysima Uc — Developer </>",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Developer 2 — Berivan
            Row(
              children: [
                Icon(Icons.terminal, color: Colors.green.shade700, size: 22),
                const SizedBox(width: 10),
                Text(
                  "Berivan Alpagu — Developer </>",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            // Designer — Büşra
            Row(
              children: [
                Icon(Icons.eco, color: Colors.green.shade700, size: 22),
                const SizedBox(width: 10),
                Text(
                  "Büşra Zararsız — Designer",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Developer 3 — Zehra
            Row(
              children: [
                Icon(Icons.terminal, color: Colors.green.shade700, size: 22),
                const SizedBox(width: 10),
                Text(
                  "Zehra Çiflikli — Developer </>",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "© 2025 WellLog — Healthy habits, happy life.",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

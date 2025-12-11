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

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "WellLog",
              style: GoogleFonts.poppins(
                fontSize: 26,
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "WellLog, günlük sağlık alışkanlıklarını takip etmeni "
              "ve sağlıklı yaşam hedeflerine ulaşmanı kolaylaştırmak için tasarlanmış bir uygulamadır.",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Sürüm",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),

            Text(
              "1.0.0",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Geliştiriciler",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),

            Text(
              "• Aysima \n• Berivan\n• Büşra\n• Zehra Çiflikli\n",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "© 2025 WellLog",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

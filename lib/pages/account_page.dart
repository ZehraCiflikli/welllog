import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:welllog/providers/auth_provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).loadCurrentUser();
    });

    final auth = Provider.of<AuthProvider>(context);
    final data = auth.currentUserData;

    final fullName = data?["fullName"] ?? "-";
    final email = auth.user?.email ?? "-";

    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: Text(
          "Hesabım",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ⭐ PROFIL HEADER
            Column(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  size: 120,
                  color: Colors.green.shade400,
                ),

                const SizedBox(height: 10),

                Text(
                  fullName,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  email,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ⭐ AYARLAR LİSTESİ
            _settingsTile(
              icon: Icons.person_outline,
              text: "Profil Bilgilerim",
              onTap: () => Navigator.pushNamed(context, "/editProfile"),
            ),

            _settingsTile(
              icon: Icons.lock_outline,
              text: "Şifre Sıfırla",
              onTap: () {
                auth.sendResetEmail();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Şifre sıfırlama maili gönderildi"),
                  ),
                );
              },
            ),

            _settingsTile(
              icon: Icons.info_outline,
              text: "Hakkında",
              onTap: () => Navigator.pushNamed(context, "/about"),
            ),

            const SizedBox(height: 10),

            // ⭐ ÇIKIŞ BUTONU
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red.shade400),
              title: Text(
                "Çıkış Yap",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.red.shade400,
                ),
              ),
              onTap: () async {
                await auth.logout();

                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, "/login");
                }
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String text,
    required Function() onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.green.shade700),
          title: Text(text, style: GoogleFonts.poppins(fontSize: 16)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        Divider(height: 1),
      ],
    );
  }
}

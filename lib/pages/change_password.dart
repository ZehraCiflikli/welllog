import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:welllog/providers/auth_provider.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final newPasswordRepeat = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: Text(
          "Şifre Değiştir",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _label("Mevcut Şifre"),
            _input(oldPassword, true),

            const SizedBox(height: 20),

            _label("Yeni Şifre"),
            _input(newPassword, true),

            const SizedBox(height: 20),

            _label("Yeni Şifre (Tekrar)"),
            _input(newPasswordRepeat, true),

            const SizedBox(height: 30),

            loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (newPassword.text != newPasswordRepeat.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Yeni şifreler aynı değil"),
                            ),
                          );
                          return;
                        }

                        setState(() => loading = true);

                        try {
                          final email = user!.email!;
                          final creds = EmailAuthProvider.credential(
                            email: email,
                            password: oldPassword.text,
                          );

                          // Şifreyi doğrula
                          await user.reauthenticateWithCredential(creds);

                          // Yeni şifreyi güncelle
                          await user.updatePassword(newPassword.text);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Şifre başarıyla değiştirildi"),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } on FirebaseAuthException catch (e) {
                          String message = "Bir hata oluştu.";

                          if (e.code == 'wrong-password' ||
                              e.code == 'invalid-credential') {
                            message = "Mevcut şifre yanlış.";
                          } else if (e.code == 'weak-password') {
                            message = "Yeni şifre çok zayıf.";
                          } else if (e.code == 'requires-recent-login') {
                            message =
                                "Güvenlik nedeniyle yeniden giriş yapmanız gerekiyor.";
                          }

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Beklenmeyen bir hata oluştu."),
                            ),
                          );
                        }

                        setState(() => loading = false);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Kaydet",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

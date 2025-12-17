import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:welllog/providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  bool _isObscure = true;

  // BAŞARI POPUP FONKSİYONU
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Kullanıcı dışarı basarak kapatamasın
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Kayıt Başarılı!",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF145A32),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Hesabınız başarıyla oluşturuldu. Sağlıklı yaşam yolculuğunuza başlayabilirsiniz.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dialog'u kapat
                  Navigator.pushReplacementNamed(context, "/home"); // Ana sayfaya git
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF145A32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("TAMAM", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = min(140.0, screenWidth * 0.35);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/login_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.green),
                        onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_circle_rounded,
                          size: avatarSize,
                          color: const Color(0xFF145A32),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "MERHABA SİZİ TANIYALIM",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            color: const Color(0xFF145A32),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader(),
                              const SizedBox(height: 20),
                              _label("Ad Soyad"),
                              _inputField("Ad ve soyadınızı girin", fullNameController),
                              const SizedBox(height: 14),
                              _label("E-posta"),
                              _inputField("Mail adresinizi girin", emailController),
                              const SizedBox(height: 14),
                              _label("Şifre"),
                              _passwordField("Şifrenizi girin", passwordController),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(child: _labelColumn("Yaş", ageController)),
                                  const SizedBox(width: 10),
                                  Expanded(child: _labelColumn("Boy", heightController, hint: "cm")),
                                  const SizedBox(width: 10),
                                  Expanded(child: _labelColumn("Kilo", weightController, hint: "kg")),
                                ],
                              ),
                              const SizedBox(height: 30),
                              _buildRegisterButton(auth, context),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- YARDIMCI METODLAR ---

  Widget _labelColumn(String label, TextEditingController controller, {String hint = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        _inputField(hint.isEmpty ? label : hint, controller, keyboardType: TextInputType.number),
      ],
    );
  }

  Widget _sectionHeader() {
    return Row(
      children: [
        const Icon(Icons.person_pin, color: Colors.green, size: 24),
        const SizedBox(width: 8),
        Text(
          "Kişisel Bilgiler",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade700),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 2),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
    );
  }

  Widget _inputField(String hint, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _passwordField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 20),
          onPressed: () => setState(() => _isObscure = !_isObscure),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildRegisterButton(auth, context) {
    return SizedBox(
      width: double.infinity,
      child: auth.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : ElevatedButton(
        onPressed: () async {
          // Inputları topla ve kayıt fonksiyonunu çağır
          final error = await auth.registerUser(
            fullName: fullNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            age: int.tryParse(ageController.text) ?? 0,
            height: int.tryParse(heightController.text) ?? 0,
            weight: int.tryParse(weightController.text) ?? 0,
          );

          if (error == null) {
            // Kayıt başarılıysa popup göster
            _showSuccessDialog();
          } else {
            // Hata varsa snackbar ile göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
            "KAYIT OL",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}
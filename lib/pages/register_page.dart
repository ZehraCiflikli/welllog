import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:welllog/providers/auth_provider.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context); // isLoading için dinliyor
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = min(180.0, screenWidth * 0.45);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffE5E5E5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Icon
              Icon(
                Icons.account_circle_rounded,
                size: avatarSize,
                color: Colors.green.shade400,
              ),

              const SizedBox(height: 10),

              // Title
              Text(
                "MERHABA SİZİ TANIYALIM",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 22),

              // CARD
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.18),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row: Avatar + Texts
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade200,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kişisel Bilgiler",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Sağlık hedeflerini kişiselleştirmek için bilgilerini ekle.",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                softWrap: true,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _label("Ad Soyad"),
                    const SizedBox(height: 6),
                    _inputField("Ad ve soyadınızı girin", fullNameController),

                    const SizedBox(height: 12),

                    _label("E-posta"),
                    const SizedBox(height: 6),
                    _inputField("Mail adresinizi girin", emailController),

                    const SizedBox(height: 12),

                    _label("Şifre"),
                    const SizedBox(height: 6),
                    _passwordField("Şifrenizi girin", passwordController),

                    const SizedBox(height: 12),

                    _label("Yaş"),
                    const SizedBox(height: 6),
                    _inputField(
                      "Yaşınızı girin",
                      ageController,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 12),

                    _label("Boy (cm)"),
                    const SizedBox(height: 6),
                    _inputField(
                      "Boyunuzu cm cinsinden girin",
                      heightController,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 12),

                    _label("Kilo (kg)"),
                    const SizedBox(height: 6),
                    _inputField(
                      "Kilonuzu kg cinsinden girin",
                      weightController,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: auth.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                final error = await auth.registerUser(
                                  fullName: fullNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  age: int.parse(ageController.text),
                                  height: int.parse(heightController.text),
                                  weight: int.parse(weightController.text),
                                );

                                if (error == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Kayıt başarılı!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade500,
                                minimumSize: const Size(double.infinity, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "KAYIT OL",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.green.shade700,
      ),
    );
  }

  Widget _inputField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13),
        filled: true,
        fillColor: Colors.grey.shade100,
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

  Widget _passwordField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13),
        suffixIcon: const Icon(Icons.lock_outline),
        filled: true,
        fillColor: Colors.grey.shade100,
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:welllog/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff96D9A0), // Resim yüklenirken görünecek uyumlu renk
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. KATMAN: Sadece JPEG Arka Plan
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. KATMAN: İçerik
          SafeArea(
            child: Column(
              children: [
                // LOGO
                const SizedBox(height: 20),

                // FIGÜR İÇİN BOŞLUK
                // Spacer(flex: 3) kullanarak ortadaki kadın ve avokado figürüne yer açıyoruz
                const Spacer(flex: 3),

                // FORM ELEMANLARI
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "HOŞ GELDİN",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF145A32),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _inputField("E-postanızı girin", emailController, Icons.email_outlined),
                      const SizedBox(height: 12),
                      _passwordField("Şifrenizi girin", passwordController),

                      const SizedBox(height: 24),

                      // GİRİŞ BUTONU (Renk: #145A32)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final auth = Provider.of<AuthProvider>(context, listen: false);
                            final error = await auth.loginUser(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            if (error == null) {
                              if (mounted) Navigator.pushReplacementNamed(context, "/home");
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error), backgroundColor: Colors.red),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF145A32),
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("GİRİŞ YAP",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, "/register"),
                        child: Text(
                          "Hesabın yok mu? Kayıt ol",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF145A32),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String hint, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF145A32)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _passwordField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF145A32)),
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF145A32)),
          onPressed: () => setState(() => _isObscure = !_isObscure),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
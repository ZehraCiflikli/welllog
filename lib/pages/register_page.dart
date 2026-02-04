import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:welllog/providers/auth_provider.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  bool _isObscure = true;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                "Hesabınız başarıyla oluşturuldu. Şimdi giriş yaparak WellLog dünyasına adım atabilirsiniz.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, "/login");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF145A32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("GİRİŞ YAP", style: TextStyle(color: Colors.white)),
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
      backgroundColor: const Color(0xff96D9A0),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/register_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF145A32)),
                          onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
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
                                _emailInputField("Mail adresinizi girin", emailController),
                                const SizedBox(height: 14),
                                _label("Şifre"),
                                _passwordField("Şifrenizi girin", passwordController),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _ageField()),
                                    const SizedBox(width: 10),
                                    Expanded(child: _heightField()),
                                    const SizedBox(width: 10),
                                    Expanded(child: _weightField()),
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
          ),
        ],
      ),
    );
  }

  // --- ÖZEL VALIDASYONLU ALANLAR ---

  Widget _emailInputField(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration(hint),
      validator: (value) {
        if (value == null || value.isEmpty) return "Boş bırakılamaz";
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) return "Geçersiz mail formatı";
        return null;
      },
    );
  }

  Widget _ageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Yaş"),
        TextFormField(
          controller: ageController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration("Yaş"),
          validator: (value) => (value == null || value.isEmpty) ? "Boş" : null,
        ),
      ],
    );
  }

  Widget _heightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Boy"),
        TextFormField(
          controller: heightController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration("cm"),
          validator: (value) => (value == null || value.isEmpty) ? "Boş" : null,
        ),
      ],
    );
  }

  Widget _weightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Kilo"),
        TextFormField(
          controller: weightController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration("kg"),
          validator: (value) => (value == null || value.isEmpty) ? "Boş" : null,
        ),
      ],
    );
  }

  // --- MERKEZİ TASARIM METODU (Tüm Borderlar Burada) ---

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      errorStyle: const TextStyle(color: Colors.red, fontSize: 11),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

      // Normal Durum
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      // Hata Durumu (Kırmızı Kenarlık)
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),

      // Hata Varken Seçili Olma Durumu
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),

      // Normal Seçili Olma Durumu
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF145A32), width: 1),
      ),
    );
  }

  // --- DİĞER YARDIMCI METOTLAR ---

  Widget _sectionHeader() {
    return Row(
      children: [
        const Icon(Icons.person_pin, color: Color(0xFF145A32), size: 24),
        const SizedBox(width: 8),
        Text(
          "Kişisel Bilgiler",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF145A32)),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 2),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF145A32))),
    );
  }

  Widget _inputField(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(hint),
      validator: (value) => (value == null || value.isEmpty) ? "Boş bırakılamaz" : null,
    );
  }

  Widget _passwordField(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: _isObscure,
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 20),
          onPressed: () => setState(() => _isObscure = !_isObscure),
        ),
      ),
      validator: (value) => (value == null || value.length < 6) ? "En az 6 karakter" : null,
    );
  }

  Widget _buildRegisterButton(auth, context) {
    return SizedBox(
      width: double.infinity,
      child: auth.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF145A32)))
          : ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final error = await auth.registerUser(
              fullName: fullNameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              age: int.parse(ageController.text),
              height: double.parse(heightController.text).toInt(),
              weight: double.parse(weightController.text).toInt(),
            );

            if (error == null) {
              _showSuccessDialog();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error), backgroundColor: Colors.red),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF145A32),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text("KAYIT OL", style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
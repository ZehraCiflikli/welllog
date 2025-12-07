import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:welllog/providers/auth_provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool editMode = false;

  final fullNameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AuthProvider>(context, listen: false).loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final data = auth.currentUserData;

    final fullName = data?["fullName"] ?? "Yükleniyor...";
    final age = data?["age"]?.toString() ?? "-";
    final height = data?["height"]?.toString() ?? "-";
    final weight = data?["weight"]?.toString() ?? "-";
    final email = auth.user?.email ?? "-";

    if (editMode && data != null) {
      fullNameController.text = fullName;
      ageController.text = age;
      heightController.text = height;
      weightController.text = weight;
    }

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
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
        actions: [
          IconButton(
            icon: Icon(
              editMode ? Icons.close : Icons.edit,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {
              setState(() {
                editMode = !editMode;
              });
            },
          ),
        ],
      ),

      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⭐ PROFIL KARTI
                  _profileCard(fullName, email),

                  const SizedBox(height: 25),

                  // ⭐ İSTATISTIK BÖLÜMÜ (VIEW veya EDIT)
                  editMode ? _editStats() : _viewStats(age, height, weight),

                  const SizedBox(height: 30),

                  // ⭐ DASHBOARD ALANI
                  _dailyStatusCard(),

                  const SizedBox(height: 30),

                  // ⭐ EDIT MODE BUTTONS
                  if (editMode) _editButtons(auth),

                  // ⭐ ÇIKIŞ BUTONU
                  if (!editMode)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await auth.logout();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, "/login");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          "Çıkış Yap",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  // ------------------------------------------------------------
  // PROFIL KARTI
  // ------------------------------------------------------------
  Widget _profileCard(String name, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          editMode
              ? TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: "Ad Soyad"),
                )
              : Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
          const SizedBox(height: 6),
          Text(
            email,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // VIEW MODE – YAŞ BOY KILO KUTULARI
  // ------------------------------------------------------------
  Widget _viewStats(String age, String height, String weight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatBox(label: "Yaş", value: age),
        StatBox(label: "Boy", value: "$height cm"),
        StatBox(label: "Kilo", value: "$weight kg"),
      ],
    );
  }

  // ------------------------------------------------------------
  // EDIT MODE – INPUT ALANLARI
  // ------------------------------------------------------------
  Widget _editStats() {
    return Column(
      children: [
        _editField("Yaş", ageController),
        const SizedBox(height: 12),
        _editField("Boy (cm)", heightController),
        const SizedBox(height: 12),
        _editField("Kilo (kg)", weightController),
      ],
    );
  }

  Widget _editField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  // ------------------------------------------------------------
  // EDIT MODE BUTTONS (KAYDET – IPTAL)
  // ------------------------------------------------------------
  Widget _editButtons(AuthProvider auth) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await auth.updateUserData(
                fullName: fullNameController.text,
                age: int.parse(ageController.text),
                height: int.parse(heightController.text),
                weight: int.parse(weightController.text),
              );

              setState(() {
                editMode = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              "Kaydet",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            setState(() {
              editMode = false;
            });
          },
          child: const Text("İptal"),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // DASHBOARD / PUAN ALANI
  // ------------------------------------------------------------
  Widget _dailyStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bugünkü Puanın: 72",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Harika gidiyorsun 🌿",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// ISTATISTIK BILESENI
// ------------------------------------------------------------
class StatBox extends StatelessWidget {
  final String label;
  final String value;

  const StatBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

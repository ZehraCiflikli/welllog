import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/todo_provider.dart';
import '../providers/auth_provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TextEditingController _sigaraController;
  late TextEditingController _kahveController;

  @override
  void initState() {
    super.initState();
    final todo = context.read<TodoProvider>();

    _sigaraController =
        TextEditingController(text: todo.sigara >= 0 ? "${todo.sigara}" : "");
    _kahveController =
        TextEditingController(text: todo.kahve >= 0 ? "${todo.kahve}" : "");
  }

  @override
  void dispose() {
    _sigaraController.dispose();
    _kahveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todo = context.watch<TodoProvider>();
    final auth = context.watch<AuthProvider>();

    // 🔁 GÜN DEĞİŞTİYSE INPUTLARI TEMİZLE
    if (todo.consumeResetFlag()) {
      _sigaraController.clear();
      _kahveController.clear();
    }

    final name =
        auth.currentUserData?["fullName"]?.split(" ").first ?? "Kullanıcı";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: Text(
          "$name'nın Günlük Takibi",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // 😊 RUH HALİ
          _card(
            "Ruh Hali Takibi",
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (i) {
                final index = i + 1;
                return GestureDetector(
                  onTap: () => todo.setRuhHali(index),
                  child: Text(
                    ["😢", "😟", "😐", "🙂", "😄"][i],
                    style: TextStyle(
                      fontSize: 32,
                      backgroundColor:
                          todo.ruhHali == index ? Colors.green.shade100 : null,
                    ),
                  ),
                );
              }),
            ),
          ),

          // 🚬 SİGARA
          _card(
            "Sigara Takibi",
            _numberField(
              controller: _sigaraController,
              hint: "Kaç adet sigara içtin? (0 = hiç)",
              onChanged: (v) =>
                  todo.setSigara(v.isEmpty ? -1 : int.tryParse(v) ?? 0),
            ),
          ),

          // ☕ KAHVE
          _card(
            "Kahve Takibi",
            _numberField(
              controller: _kahveController,
              hint: "Kaç bardak kahve içtin?",
              onChanged: (v) =>
                  todo.setKahve(v.isEmpty ? -1 : int.tryParse(v) ?? 0),
            ),
          ),

          // 🧴 CİLT BAKIMI
          _card(
            "Cilt Bakımı Takibi",
            CheckboxListTile(
              value: todo.ciltBakimi,
              activeColor: Colors.green,
              onChanged: (val) => todo.toggleCiltBakimi(val ?? false),
              title: const Text("Bugün cilt bakımı yaptım"),
            ),
          ),

          // 📱 EKRAN SÜRESİ
          _card(
            "Ekran Süresi Takibi",
            _slider(
              value: todo.ekranSuresi,
              min: 1,
              max: 10,
              defaultValue: 1,
              label:
                  "${(todo.ekranSuresi < 0 ? 1 : todo.ekranSuresi).toInt()} saat",
              onChanged: (v) => todo.setEkranSuresi(v),
            ),
          ),

          // 🍽️ ÖĞÜN
          _card(
            "Öğün Takibi",
            Column(
              children: List.generate(3, (i) {
                final labels = ["Kahvaltı", "Öğle", "Akşam"];
                return CheckboxListTile(
                  title: Text(labels[i]),
                  value: todo.ogunler[i],
                  activeColor: Colors.green,
                  onChanged: (_) => todo.toggleOgun(i),
                );
              }),
            ),
          ),

          // 🚶 ADIM
          _card(
            "Adım Takibi",
            _slider(
              value: todo.adim.toDouble(),
              min: 0,
              max: 10000,
              defaultValue: 0,
              label: "${todo.adim} adım",
              onChanged: (v) => todo.setAdim(v.toInt()),
            ),
          ),

          // 😴 UYKU
          _card(
            "Uyku Takibi",
            _slider(
              value: todo.uyku,
              min: 0,
              max: 12,
              defaultValue: 0,
              label:
                  "${(todo.uyku < 0 ? 0 : todo.uyku).toInt()} saat",
              onChanged: (v) => todo.setUyku(v),
            ),
          ),

          // 💧 SU
          _card(
            "Su İçme Takibi",
            _slider(
              value: todo.su.toDouble(),
              min: 0,
              max: 10,
              defaultValue: 0,
              label: "${todo.su} bardak",
              onChanged: (v) => todo.setSu(v.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ORTAK WIDGETLER =================

  Widget _card(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _slider({
    required double value,
    required double min,
    required double max,
    required double defaultValue,
    required String label,
    required Function(double) onChanged,
  }) {
    final safeValue = value < min ? defaultValue : value;

    return Column(
      children: [
        Slider(
          value: safeValue,
          min: min,
          max: max,
          divisions: max.toInt(),
          activeColor: Colors.green,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
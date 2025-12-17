import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/todo_provider.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TextEditingController _sigaraController;
  late TextEditingController _kahveController;
  final FirestoreService _firestoreService = FirestoreService();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final todo = context.read<TodoProvider>();

    _sigaraController = TextEditingController(
      text: todo.sigara >= 0 ? "${todo.sigara}" : "",
    );
    _kahveController = TextEditingController(
      text: todo.kahve >= 0 ? "${todo.kahve}" : "",
    );
  }

  @override
  void dispose() {
    _sigaraController.dispose();
    _kahveController.dispose();
    super.dispose();
  }

  bool get isToday {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final todo = context.watch<TodoProvider>();
    final auth = context.watch<AuthProvider>();

    // Gün reset olduysa inputları temizle
    if (todo.consumeResetFlag()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sigaraController.clear();
        _kahveController.clear();
      });
    }

    // Bugüne dönünce readonly kapansın
    if (isToday && todo.isReadOnly) {
      todo.isReadOnly = false;
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
          _threeDayHeader(auth),

          const SizedBox(height: 10),

          if (!isToday) _oldDayBanner(),

          _buildForm(todo, enabled: !todo.isReadOnly),
        ],
      ),
    );
  }

  // ============================================================
  // 🔥 3 GÜNLÜK HEADER
  // ============================================================

  Widget _threeDayHeader(AuthProvider auth) {
    DateTime yesterday = selectedDate.subtract(const Duration(days: 1));
    DateTime tomorrow = selectedDate.add(const Duration(days: 1));

    final formatterShort = DateFormat("d MMM", "tr");
    final formatterDay = DateFormat("E", "tr");

    DateTime now = DateTime.now();
    bool canGoForward =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    Widget buildDay(DateTime date, bool isSelected, bool disabled) {
      return GestureDetector(
        onTap: disabled
            ? null
            : () async {
                setState(() {
                  selectedDate = date;
                });

                final uid = auth.currentUserData?["uid"];
                if (uid == null) return;

                if (!isToday) {
                  final data = await _firestoreService.getDailyLog(
                    uid: uid,
                    date: date,
                  );
                  context.read<TodoProvider>().loadFromMap(data);
                }
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade600 : Colors.green.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                formatterShort.format(date),
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.green.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatterDay.format(date),
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white70 : Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: buildDay(yesterday, yesterday == selectedDate, false)),
        const SizedBox(width: 8),
        Expanded(child: buildDay(selectedDate, true, false)),
        const SizedBox(width: 8),
        Expanded(
          child: buildDay(tomorrow, tomorrow == selectedDate, canGoForward),
        ),
      ],
    );
  }

  // ============================================================
  // 🔶 GEÇMİŞ GÜN BİLGİSİ
  // ============================================================

  Widget _oldDayBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "Geçmiş güne bakıyorsun. Veriler sadece görüntülenebilir.",
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ============================================================
  // 🔥 FORM
  // ============================================================

  Widget _buildForm(TodoProvider todo, {required bool enabled}) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Column(
          children: [
            _card(
              "Bugün nasıl hissediyorsun?",
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
                        backgroundColor: todo.ruhHali == index
                            ? Colors.green.shade100
                            : null,
                      ),
                    ),
                  );
                }),
              ),
            ),

            _card(
              "Uyku Takibi",
              _slider(
                value: todo.uyku,
                min: 0,
                max: 12,
                defaultValue: 0,
                label: "${(todo.uyku < 0 ? 0 : todo.uyku).toInt()} saat",
                onChanged: (v) => todo.setUyku(v),
              ),
            ),

            _card(
              "Su Takibi",
              _slider(
                value: todo.su.toDouble(),
                min: 0,
                max: 10,
                defaultValue: 0,
                label: "${todo.su} bardak",
                onChanged: (v) => todo.setSu(v.toInt()),
              ),
            ),

            _card(
              "Öğün Takibi",
              Column(
                children: List.generate(3, (i) {
                  final labels = ["Kahvaltı", "Öğle", "Akşam"];
                  return CheckboxListTile(
                    title: Text(labels[i]),
                    value: todo.ogunler[i],
                    onChanged: (_) => todo.toggleOgun(i),
                    activeColor: Colors.green,
                  );
                }),
              ),
            ),

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

            _card(
              "Kahve Takibi",
              _numberField(
                controller: _kahveController,
                hint: "Kaç bardak kahve içtin?",
                onChanged: (v) =>
                    todo.setKahve(v.isEmpty ? -1 : int.tryParse(v) ?? 0),
              ),
            ),

            _card(
              "Sigara Takibi",
              _numberField(
                controller: _sigaraController,
                hint: "Kaç adet sigara içtin?",
                onChanged: (v) =>
                    todo.setSigara(v.isEmpty ? -1 : int.tryParse(v) ?? 0),
              ),
            ),

            _card(
              "Cilt Bakımı Takibi",
              CheckboxListTile(
                value: todo.ciltBakimi,
                onChanged: (val) => todo.toggleCiltBakimi(val ?? false),
                title: const Text("Bugün cilt bakımı yaptım"),
                activeColor: Colors.green,
              ),
            ),

            _card(
              "Ekran Süresi",
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
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 🔹 KART
  Widget _card(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 🔹 SLIDER
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

  // ============================================================
  // 🔹 NUMBER FIELD
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
    );
  }
}

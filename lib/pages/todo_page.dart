import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import 'package:welllog/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';


class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

@override
Widget build(BuildContext context) {
  final todo = context.watch<TodoProvider>();
  final auth = context.watch<AuthProvider>();

  final fullName =
      auth.currentUserData?["fullName"]?.split(" ").first ?? "Kullanıcı";

  return Scaffold(
    backgroundColor: Colors.white,

    appBar: AppBar(
      backgroundColor: Colors.green.shade600,
      elevation: 0,
      title: Text(
        "$fullName'nın Yapılacak Listesi",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 👇 SENİN MEVCUT CARD'LARIN AYNEN DEVAM

            // Ruh Hali Takibi
            _emojiCard(
              context,
              title: "Ruh Hali Takibi",
              selected: todo.ruhHali,
              onSelect: (val) => todo.setRuhHali(val),
            ),

            // Sigara Takibi
            _sliderCard(
              context,
              title: "Sigara Takibi",
              value: todo.sigara.toDouble(),
              max: 10,
              onChanged: (val) => todo.setSigara(val.toInt()),
              unit: "adet",
            ),

            // Kahve Takibi
            _sliderCard(
              context,
              title: "Kahve Takibi",
              value: todo.kahve.toDouble(),
              max: 5,
              onChanged: (val) => todo.setKahve(val.toInt()),
              unit: "bardak",
            ),

            // Cilt Bakımı Takibi
            _checkboxCard(
              context,
              title: "Cilt Bakımı Takibi",
              value: todo.ciltBakimi,
              onChanged: (val) => todo.setCiltBakimi(val!),
            ),

            // Ekran Süresi Takibi
            _sliderCard(
              context,
              title: "Ekran Süresi Takibi",
              value: todo.ekranSuresi,
              max: 10,
              onChanged: (val) => todo.setEkran(val),
              unit: "saat",
            ),

            // Öğün Takibi
            _multiCheckboxCard(
              context,
              title: "Öğün Takibi",
              labels: ["Kahvaltı", "Öğle", "Akşam"],
              values: todo.ogunler,
              onChanged: (index) => todo.toggleOgun(index),
            ),

            // Adım Takibi
            _sliderCard(
              context,
              title: "Adım Takibi",
              value: todo.adim.toDouble(),
              max: 10000,
              onChanged: (val) => todo.setAdim(val.toInt()),
              unit: "adım",
            ),

            // Uyku Takibi
            _sliderCard(
              context,
              title: "Uyku Takibi",
              value: todo.uyku,
              max: 12,
              onChanged: (val) => todo.setUyku(val),
              unit: "saat",
            ),

            // Su İçme Takibi
            _sliderCard(
              context,
              title: "Su İçme Takibi",
              value: todo.su.toDouble(),
              max: 10,
              onChanged: (val) => todo.setSu(val.toInt()),
              unit: "bardak",
            ),
          ],
        ),
      ),
    );
  }

  Widget _emojiCard(BuildContext context,
      {required String title,
      required int selected,
      required Function(int) onSelect}) {
    final emojis = ["😢", "😟", "😐", "🙂", "😄"];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                emojis.length,
                (index) => GestureDetector(
                  onTap: () => onSelect(index + 1),
                  child: Text(
                    emojis[index],
                    style: TextStyle(
                        fontSize: 32,
                        backgroundColor:
                            selected == index + 1 ? Colors.green[100] : null),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sliderCard(BuildContext context,
      {required String title,
      required double value,
      required double max,
      required Function(double) onChanged,
      String? unit}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: value,
                    max: max,
                    divisions: max.toInt(),
                    label: "$value ${unit ?? ''}",
                    onChanged: onChanged,
                  ),
                ),
                Text("${value.toInt()} ${unit ?? ''}"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkboxCard(BuildContext context,
      {required String title, required bool value, required Function(bool?) onChanged}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: CheckboxListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _multiCheckboxCard(BuildContext context,
      {required String title,
      required List<String> labels,
      required List<bool> values,
      required Function(int) onChanged}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...List.generate(labels.length, (index) {
              return CheckboxListTile(
                title: Text(labels[index]),
                value: values[index],
                onChanged: (_) => onChanged(index),
              );
            }),
          ],
        ),
      ),
    );
  }
}

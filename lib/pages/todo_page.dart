import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welllog/providers/auth_provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Üst Başlık Kısmı - Kullanıcı bilgileri çıkarıldı
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.home, color: Colors.green, size: 30),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TodoPage",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Günlük Takip",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  TrackingCard(
                    title: "Ruh Hali Takibi",
                    icon: Icons.sentiment_satisfied_alt,
                  ),
                  TrackingCard(title: "Sigara Takibi", icon: Icons.smoke_free),
                  TrackingCard(title: "Kahve Takibi", icon: Icons.coffee),
                  TrackingCard(
                    title: "Cilt Bakımı Takibi",
                    icon: Icons.face_retouching_natural,
                  ),
                  TrackingCard(
                    title: "Ekran Süresi Takibi",
                    icon: Icons.smartphone,
                  ),
                  TrackingCard(title: "Öğün Takibi", icon: Icons.restaurant),
                  TrackingCard(
                    title: "Adım Takibi",
                    icon: Icons.directions_walk,
                  ),
                  TrackingCard(title: "Uyku Takibi", icon: Icons.bedtime),
                  TrackingCard(title: "Su İçme Takibi", icon: Icons.water_drop),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingCard extends StatefulWidget {
  final String title;
  final IconData icon;

  const TrackingCard({super.key, required this.title, required this.icon});

  @override
  State<TrackingCard> createState() => _TrackingCardState();
}

class _TrackingCardState extends State<TrackingCard> {
  int _value = 5;

  void _increment() {
    if (_value < 10) setState(() => _value++);
  }

  void _decrement() {
    if (_value > 1) setState(() => _value--);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(widget.icon, color: Colors.green.shade700, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _value / 10.0,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.green,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Row(
            children: [
              _controlBtn(Icons.remove, _decrement),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    "$_value",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              _controlBtn(Icons.add, _increment),
            ],
          ),
        ],
      ),
    );
  }

  Widget _controlBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.green, size: 18),
      ),
    );
  }
}

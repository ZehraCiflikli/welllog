import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySelectorDemo extends StatefulWidget {
  @override
  State<DaySelectorDemo> createState() => _DaySelectorDemoState();
}

class _DaySelectorDemoState extends State<DaySelectorDemo> {
  DateTime selectedDate = DateTime.now();

  DateTime get prevDate => selectedDate.subtract(Duration(days: 1));
  DateTime get nextDate => selectedDate.add(Duration(days: 1));

  bool get isToday {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("d MMMM EEEE", "tr");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        title: Text("To‑Do Takvimi"),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          // 🔥 GÜN SEÇİCİ BAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Sol ok
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.green, size: 32),
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.subtract(Duration(days: 1));
                  });
                },
              ),

              _dayButton(prevDate, false),
              _dayButton(selectedDate, true),
              _dayButton(nextDate, false),

              // Sağ ok — sadece bugünün ötesine geçemez
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: isToday ? Colors.grey : Colors.green,
                  size: 32,
                ),
                onPressed: isToday
                    ? null
                    : () {
                        setState(() {
                          selectedDate = selectedDate.add(Duration(days: 1));
                        });
                      },
              ),
            ],
          ),

          const SizedBox(height: 30),

          // 🔥 SEÇİLİ GÜNÜN ALTTAKİ EKRANI
          Expanded(child: _buildDayContent()),
        ],
      ),
    );
  }

  Widget _dayButton(DateTime date, bool isSelected) {
    final dateText = DateFormat("d MMMM EEEE", "tr").format(date);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade300 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        dateText,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.green.shade900 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDayContent() {
    final isSelectedToday = isToday;

    return Center(
      child: isSelectedToday
          ? Text(
              "BUGÜNÜN To‑Do SAYFASI (aktif mod)",
              style: TextStyle(fontSize: 20, color: Colors.green),
            )
          : Text(
              "${DateFormat("d MMMM").format(selectedDate)} gününün verileri (read‑only)",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            ),
    );
  }
}

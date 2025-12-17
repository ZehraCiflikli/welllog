import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripleDaySelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const TripleDaySelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final prev = selectedDate.subtract(const Duration(days: 1));
    final next = selectedDate.add(const Duration(days: 1));

    Widget box(DateTime date) {
      final isSelected = isSameDay(date, selectedDate);
      final isFuture = date.isAfter(today);

      return GestureDetector(
        onTap: isFuture ? null : () => onDateSelected(date),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade600 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.green.shade700 : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.green.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Text(
                DateFormat("d MMM", "tr").format(date),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat("EEE", "tr").format(date),
                style: TextStyle(
                  color: isSelected ? Colors.white70 : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        box(prev),
        box(selectedDate),
        if (!next.isAfter(today)) box(next),
      ],
    );
  }
}

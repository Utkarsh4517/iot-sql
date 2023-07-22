import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime selectedDate) onDateChanged;
  const DatePickerWidget({
    required this.onDateChanged,
    super.key,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onDateChanged(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(
        //   "Selected Date: ${selectedDate.toLocal()}".split(' ')[0],
        //   style: const TextStyle(color: Colors.white),
        // ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: (){ _selectDate(context);}, child: const Text('select date'))
      ],
    );
  }
}

import 'package:flutter/material.dart';

class DurationSelector extends StatefulWidget {
  final Function(int) onDurationSelected;

  const DurationSelector({required this.onDurationSelected, super.key});
  @override
  State<DurationSelector> createState() => _DurationSelectorState();
}

class _DurationSelectorState extends State<DurationSelector> {
  List<int> durationsInMinutes = List.generate(20, (index) => (index + 1) * 15);

  int selectedDuration = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton<int>(
        value: selectedDuration,
        items: [
          const DropdownMenuItem<int>(
            value: 0,
            child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    color: Color(0xFF2864ff),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Duração estimada do serviço',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w100,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...durationsInMinutes.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      color: Color(0xFF2864ff),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${value ~/ 60} horas ${value % 60} minutos',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
        onChanged: (int? newValue) {
          if (newValue != null) {
            setState(() {
              selectedDuration = newValue;
            });
            widget.onDurationSelected(selectedDuration);
          }
        },
        style: const TextStyle(
          color: Colors.black,
        ),
        underline: Container(
          height: 1.5,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

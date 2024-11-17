import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  static Widget buildTextField(
      {required TextEditingController controller,
      required String hintText,
      required IconData prefixIcon,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      void Function(String)? onChanged}) {
    return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w200,
          ),
          prefixIcon: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.blue, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Icon(
              prefixIcon,
              color: Colors.blue,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.5),
          ),
        ),
        onChanged: onChanged,
        onEditingComplete: () {},
        inputFormatters: inputFormatters);
  }

  static Widget buildTimePickerFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w200,
          ),
          prefixIcon: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.blue, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Icon(
              prefixIcon,
              color: Colors.blue,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.5),
          ),
        ),
        onTap: () async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            controller.text = pickedTime.format(context);
          }
        },
      ),
    );
  }
}

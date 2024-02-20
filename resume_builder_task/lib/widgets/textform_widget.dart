import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  final String hinttext;
  final ValueChanged<String>? onChanged;
  const TextFormWidget({
    super.key,
    required this.hinttext,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hinttext,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }
}

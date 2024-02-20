import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  final String hinttext;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const TextFormWidget({
    Key? key,
    required this.hinttext,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hinttext,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

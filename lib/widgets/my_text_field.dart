// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:gouantum/utilities/palette.dart';

// ignore: must_be_immutable
class MytextField extends StatelessWidget {
  final TextEditingController theController;
  final String hintText;
  final TextInputType textInputType;
  final bool autofocus;
  TextAlign textAlign;
  final Function onsave;
  final Function validator;
  MytextField({
    super.key,
    required this.theController,
    required this.hintText,
    required this.textInputType,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    required this.onsave,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign,
      controller: theController,
      onSaved: onsave(),
      validator: validator(),
      decoration: InputDecoration(
        // labelText: "full phone no.",
        hintText: hintText,
        hintStyle: const TextStyle(color: Palette.medGrayColor),
        filled: true,
        fillColor: Palette.lightGrayColor,
      ),
      keyboardType: textInputType,
      autofocus: autofocus,
    );
  }
}

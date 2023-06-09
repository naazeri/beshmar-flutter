import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/styles.dart';

class MyTextFormField extends StatelessWidget {
  final String? placeholder;
  final IconData? icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool digitsOnly;
  final int? maxLength;
  final TextAlign textAlign;
  final String? Function(String?)? validator;
  final Function? onFieldSubmitted;

  const MyTextFormField({
    this.placeholder,
    this.icon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.digitsOnly = true,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.onFieldSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter>? inputFormatters;

    if (keyboardType == TextInputType.number) {
      inputFormatters = <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ];
    }

    return TextFormField(
      controller: controller,
      onFieldSubmitted: (_) => onFieldSubmitted!(),
      inputFormatters: inputFormatters,
      validator: validator,
      maxLength: maxLength,
      textAlign: textAlign,
      style: Styles.textNormal,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: placeholder,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
    );
  }
}

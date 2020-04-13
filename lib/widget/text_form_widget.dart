import 'package:flutter/material.dart';

class TextformFieldWidget extends StatelessWidget {
  final String hint;
  final String label;
  final bool obscureText;
  final TextInputType inputType;
  final int maxLength;
  final Function validatorFunction;
  final Function saveFunction;
  final String initialValue;
  final Function onValueChangeFunction;

  TextformFieldWidget({
    this.hint,
    this.obscureText,
    this.label,
    this.inputType,
    this.maxLength,
    this.validatorFunction,
    this.saveFunction,
    this.initialValue,
    this.onValueChangeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      initialValue: initialValue,
      validator: validatorFunction,
      onSaved: saveFunction,
      keyboardType: inputType,
      maxLength: maxLength,
      maxLines: 1,
      onChanged: onValueChangeFunction,
      decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}

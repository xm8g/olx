import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomizado extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool autoFocus;
  final TextInputType type;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final Function(String) validator;
  final Function(String) onSaved;

  const InputCustomizado({
    @required this.controller, 
    @required this.hint, 
    this.obscure = false,
    this.autoFocus = false,
    this.type = TextInputType.text,
    this.inputFormatters,
    this.maxLines,
    this.validator,
    this.onSaved
  });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      autofocus: this.autoFocus,
      keyboardType: this.type,
      inputFormatters: this.inputFormatters,
      obscureText: this.obscure,
      style: TextStyle(fontSize: 20),
      maxLines: this.obscure ? 1 : this.maxLines,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: this.hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))
      ),
      validator: this.validator,
      onSaved: this.onSaved,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReusableTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final Color? fillColor;
  final Color? borderColor;
  final GestureTapCallback? suffixIconOnTap;

  const ReusableTextFormField({
    Key? key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.focusNode,
    this.readOnly = false,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.fillColor,
    this.borderColor,
    this.suffixIconOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly ?? false,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? GestureDetector(
          onTap: suffixIconOnTap,
          child: Icon(suffixIcon),
        ): null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor ?? Colors.grey),
        ),
        filled: fillColor != null,
        fillColor: fillColor,
 
      ),
    );
  }
}
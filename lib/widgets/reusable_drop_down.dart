import 'package:flutter/material.dart';

class ReusableDropdown<T> extends StatelessWidget {
  final String? labelText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? hint;
  final Widget? icon;
  final Color? dropdownColor;
  final TextStyle? style;
  final InputBorder? border;

  const ReusableDropdown({
    Key? key,
    this.labelText,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.hint,
    this.icon,
    this.dropdownColor,
    this.style,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: labelText,
        border: border ?? const OutlineInputBorder(), 
      ),
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      hint: hint,
      icon: icon,
      dropdownColor: dropdownColor,
      style: style,
    );
  }
}
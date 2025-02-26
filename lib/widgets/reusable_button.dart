import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;  
  final Color? textColor;    
  final double? fontSize;    
  final EdgeInsets? padding;  
  final BorderRadius? borderRadius; 
  final BorderSide? border;
  final IconData? icon; 
  final TextStyle? style;
  const ReusableButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.border,
    this.icon,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          side: border != null ? border as BorderSide : BorderSide.none, 
        ),
        side: border,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(icon, color: textColor),
            ),
          Text(
            text,
            style: style ?? TextStyle(fontSize: fontSize, color: textColor),
          ),
        ],
      ),
    );
  }
}
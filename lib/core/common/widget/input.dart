import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    this.maxLines = 1,
    this.label,
    this.suffix,
    this.autofocus,
    this.prefix,
    this.enabled,
    this.readOnly,
    this.onSaved,
    this.fillColor,
    this.validator,
    this.onTap,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.hint,
    this.onFieldSubmitted,
    this.obscureText = false,
    super.key,
    this.focuseNode,
    // this.textDirection = TextDirection.ltr,
    this.textDirection,
  });

  final TextDirection? textDirection;
  final int? maxLines;
  final bool? readOnly;
  final bool? enabled, autofocus;
  final String? label;
  final String? hint;
  final Widget? suffix;
  final IconData? prefix;
  final Color? fillColor;
  final bool? obscureText;
  final FocusNode? focuseNode;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      autofocus: autofocus ?? false,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly ?? false,
      onSaved: onSaved,
      onChanged: onChanged,
      textDirection: textDirection,
      controller: controller,
      style: const TextStyle(fontSize: 15),
      onTapOutside: focuseNode != null
          ? null
          : (val) => FocusManager.instance.primaryFocus?.unfocus(),
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.multiline,
      obscureText: obscureText ?? false,
      enabled: enabled,
      maxLines: obscureText == true ? 1 : maxLines,
      focusNode: focuseNode,
      decoration: InputDecoration(
        hintText: hint,
        label: label != null ? Text(label!) : null,
        isDense: false,
        prefixIcon: prefix != null ? Icon(prefix) : null,
        suffixIcon: suffix,
        errorMaxLines: 3,
      ),
    );
  }
}

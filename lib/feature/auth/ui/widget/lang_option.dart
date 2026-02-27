import 'package:flutter/material.dart';

class LangChoice extends StatelessWidget {
  final String flag;
  final void Function() onTap;
  const LangChoice({super.key, required this.onTap, required this.flag});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          alignment: .center,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.blue.shade50),
          ),
          child: Text(flag, style: TextStyle(fontSize: 48)),
        ),
      ),
    );
  }
}

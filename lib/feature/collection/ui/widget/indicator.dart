import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color? color;
  final bool _currentSlide;
  final double? width, height;
  const Indicator(
    this._currentSlide, {
    super.key,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height ?? 9,
      width: _currentSlide ? width ?? 9 : height ?? 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color ?? Colors.blue.shade900),
      ),
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 250),
    );
  }
}

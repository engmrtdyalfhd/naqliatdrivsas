import 'colory.dart';
import 'package:flutter/material.dart';

OutlineInputBorder buildBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(width: 1, color: Colory.main.shade50),
  );
}

OutlineInputBorder buildFocusedBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(width: 1, color: Colory.main.shade100),
  );
}

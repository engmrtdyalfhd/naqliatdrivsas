import 'package:flutter/material.dart';

import 'border_theme.dart';
import 'colory.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.blue,
    ),
    appBarTheme: const AppBarTheme(
      titleSpacing: 16,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    // ! _____ Input _____ ! //
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colory.lightBg,
      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      suffixIconColor: Colors.grey,
      prefixIconColor: Colors.grey,
      contentPadding: const EdgeInsets.all(16),
      border: buildBorder(),
      enabledBorder: buildBorder(),
      disabledBorder: buildBorder(),
      focusedErrorBorder: buildBorder(),
      focusedBorder: buildFocusedBorder(),
    ),
    // ! _____ Main Button _____ ! //
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 55),
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    // ! _____ Secondary Button _____ ! //
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 13, fontWeight: .bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: Colors.blue.shade50),
        ),
      ),
    ),
    // ! _____ Radio Button (Collection View) _____ ! //
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(const EdgeInsets.all(8)),
        // backgroundColor: WidgetStatePropertyAll(Colory.lightBg),
        // minimumSize: WidgetStatePropertyAll(Size.fromHeight(64)),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 14, fontWeight: .normal),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            // side: BorderSide(color: Colors.blue.shade100),
          ),
        ),
      ),
    ),
    // ! _____ ListTile _____ ! //
    listTileTheme: ListTileThemeData(
      dense: false,
      // tileColor: Colory.lightBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.shade100),
      ),
      titleTextStyle: const TextStyle(
        // fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      textColor: Colors.black,
      iconColor: Colors.grey.shade600,
      subtitleTextStyle: TextStyle(
        inherit: false,
        fontSize: 12,
        color: Colors.grey.shade600,
      ),
      // subtitleTextStyle: AppText.regular14(),
    ),
    // ! _____ Dialog _____ ! //
    dialogTheme: DialogThemeData(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      // insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
      contentTextStyle: TextStyle(fontSize: 14, color: Colors.black),
    ),
    // ! _____ FAB _____ ! //
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 1.5,
      shape: StadiumBorder(),
      extendedTextStyle: TextStyle(
        inherit: false,
        fontSize: 13,
        fontWeight: .w700,
      ),
      extendedPadding: EdgeInsets.all(16),
      // backgroundColor: Colors.white,
      // foregroundColor: Colors.white,
    ),
    // ! _____ Bottom Sheet _____ ! //
    bottomSheetTheme: BottomSheetThemeData(
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    // ! _____ Progress Indicator _____ ! //
    progressIndicatorTheme: const ProgressIndicatorThemeData(),
  );
}

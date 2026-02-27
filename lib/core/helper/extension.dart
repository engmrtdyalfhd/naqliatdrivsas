import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

extension BuildContextExtensions on BuildContext {
  NavigatorState get nav => Navigator.of(this);
  FocusScopeNode get scope => FocusScope.of(this);
  MediaQueryData get query => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);
  ScaffoldMessengerState get toast => ScaffoldMessenger.of(this);
}

extension NavigationExtensions on BuildContext {
  Future<void> popAndPushNamedWithDelay(
    String routeName, {
    Object? arguments,
  }) async {
    Navigator.pop(this);
    await Future.delayed(const Duration(milliseconds: 250));
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      this,
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.popAndPushNamed<T, TO>(
      this,
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      this,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.pop<T>(this, result);
  }
}

extension ScaffoldMessengerExtension on BuildContext {
  void showMsg(
    String msg, {
    Color? backgroundColor,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        action: action,
        content: Text(msg),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

extension SimpleDialogExtension on BuildContext {
  void simpleDialog({required String msg, required String lottie}) {
    showAdaptiveDialog(
      context: this,
      barrierDismissible: true,
      
      builder: (_) {
        return Dialog(
          // insetPadding: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LottieBuilder.asset(
                  lottie,
                  width: 100,
                  height: 100,
                  reverse: true,
                ),
                Flexible(child: Text(msg)),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> showConfirmationAlert({
  required BuildContext context,
  String title = "Alert",
  String content = "Are you sure?",
  String confirmText = "Continue",
  String cancelText = "Cancel",
  required VoidCallback onConfirm,
}) async {
  final bool? shouldProceed = await showAdaptiveDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return AlertDialog.adaptive(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(
              cancelText,
              style: TextStyle(color: Colors.red.shade300),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
  if (shouldProceed == true) onConfirm();
}

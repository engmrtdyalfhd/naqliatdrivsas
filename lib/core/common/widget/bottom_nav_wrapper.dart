import '../../helper/extension.dart';
import 'package:flutter/material.dart';

class BottomNavWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const BottomNavWrapper({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding:
            padding ??
            EdgeInsets.fromLTRB(
              _padd(context),
              3,
              _padd(context),
              context.query.padding.bottom + 16,
            ),
        child: child,
      ),
    );
  }

  double _padd(BuildContext context) =>
      context.query.size.width > 600 ? 18 * 4 : 18;
}

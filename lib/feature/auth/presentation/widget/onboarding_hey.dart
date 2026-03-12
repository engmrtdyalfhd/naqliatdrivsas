import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OnboardingHey extends StatelessWidget {
  const OnboardingHey({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 32),
        child: RichText(
          textAlign: .center,
          text: TextSpan(
            style: TextStyle(
              letterSpacing: 1,
              color: Colors.black,
              fontSize: 20,
              fontWeight: .bold,
            ),
            text: "${"welcome1".tr()} ",
            children: [
              TextSpan(
                text: "welcome2".tr(),
                style: TextStyle(color: Colors.blue.shade700),
              ),
              TextSpan(text: "\n${"welcome3".tr()}"),
            ],
          ),
        ),
      ),
    );
  }
}

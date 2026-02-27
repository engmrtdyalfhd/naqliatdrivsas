import '../widget/lang_option.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import '../widget/onboarding_hey.dart';
import '../../../../core/helper/constant.dart';
import 'package:naqliatsa/core/helper/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/common/widget/bottom_nav_wrapper.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Image.asset(ImgPath.logo, width: 175, height: 175),
                ),
              ),
              const OnboardingHey(),
              const Spacer(),
              Row(
                spacing: 16,
                children: [
                  const Icon(Iconsax.language_circle),
                  Text(
                    "lang".tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                spacing: 9,
                children: [
                  LangChoice(
                    flag: "🇸🇦",
                    onTap: () async {
                      // await context.setLocale(Locale("ar"));
                    },
                  ),
                  LangChoice(
                    flag: "🇵🇰",
                    onTap: () async {
                      // await context.setLocale(Locale("ar"));
                    },
                  ),
                  LangChoice(
                    flag: "🇺🇸",
                    onTap: () async {
                      // await context.setLocale(Locale("en"));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(
        child: FilledButton(
          onPressed: () => context.pushNamed(RoutePath.login),
          child: Text("continue".tr()),
        ),
      ),
    );
  }
}

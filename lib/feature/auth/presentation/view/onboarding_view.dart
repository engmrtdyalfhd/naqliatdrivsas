import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:naqliatdrivsas/feature/auth/presentation/widget/lang_option.dart';
import 'package:naqliatdrivsas/feature/auth/presentation/widget/onboarding_hey.dart';


import '../../../../core/common/widget/bottom_nav_wrapper.dart';
import '../../../../core/helper/constant.dart';
import '../../../../core/helper/extension.dart';


class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
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
                    'lang'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                spacing: 9,
                children: [
                  LangChoice(flag: '🇸🇦', onTap: () {}),
                  LangChoice(flag: '🇵🇰', onTap: () {}),
                  LangChoice(flag: '🇺🇸', onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(
        child: FilledButton(
          onPressed: () => context.pushNamed(RoutePath.login),
          child: Text('continue'.tr()),
        ),
      ),
    );
  }
}
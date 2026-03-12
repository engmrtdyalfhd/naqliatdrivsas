import 'core/helper/utils.dart';
import 'core/helper/app_route.dart';
import 'core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  await initMain();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/langs',
      startLocale: Locale('en'),
      fallbackLocale: Locale('ar'),
      child: NaqliatKSA(),
    ),
  );
}

class NaqliatKSA extends StatelessWidget {
  const NaqliatKSA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naqliat KSA',
      theme: lightTheme(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generateRoute,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}

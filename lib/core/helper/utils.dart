import 'package:naqliatsa/firebase_options.dart';

import 'extension.dart';

import 'package:firebase_core/firebase_core.dart';

import '../common/error/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../service/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> initMain() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  serviceLocator();
  Bloc.observer = Observer();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // ! ______ Save dashboard data to firestore
  // Future<Map<String, dynamic>> loadDashboardJson() async {
  //   final String jsonString = await rootBundle.loadString(
  //     'assets/langs/data.json',
  //   );

  //   return json.decode(jsonString) as Map<String, dynamic>;
  // }

  // final rawData = await loadDashboardJson();
  // final model = CollectionModel.fromJson(rawData);

  // await FirebaseFirestore.instance
  //     .collection(FirebaseStr.dashboardCollection)
  //     .doc(FirebaseStr.collectDataDoc)
  //     .set(model.toJson());
  // ! ______ Save dashboard data to firestore

  FlutterNativeSplash.remove();
}

Future<void> whatsapp(
  BuildContext context, [
  String phoneNumber = "+967773365712",
]) async {
  showConfirmationAlert(
    context: context,
    title: "Customer Support",
    content: "You will be redirected to WhatsApp.\nDo you want to continue?",
    onConfirm: () async {
      final url = "https://wa.me/$phoneNumber";
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    },
  );
}

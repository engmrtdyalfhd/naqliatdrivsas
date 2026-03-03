//
// ⚠️  ONE-TIME USE — Run once, then remove the call from main.dart
//
// Usage in main.dart (BEFORE runApp):
//   await seedCollectionDataToFirestore();
//

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constant.dart'; // FirebaseStr

Future<void> seedCollectionDataToFirestore() async {
  try {
    // 1. Read local asset
    final String jsonStr =
    await rootBundle.loadString('assets/langs/data.json');
    final Map<String, dynamic> jsonMap =
    json.decode(jsonStr) as Map<String, dynamic>;

    // 2. Write to Firestore → dashboard / collect_data
    await FirebaseFirestore.instance
        .collection(FirebaseStr.dashboardCollection)   // "dashboard"
        .doc(FirebaseStr.collectDataDoc)               // "collect_data"
        .set(jsonMap);

    // ignore: avoid_print
    print('✅ data.json successfully seeded to Firestore!');
  } catch (e) {
    // ignore: avoid_print
    print('❌ Firestore seed failed: $e');
  }
}
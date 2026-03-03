
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadUserFleet(BuildContext context) async {
    emit(HomeLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(HomeFailure('User not authenticated'));
        return;
      }

      // 1. Fetch user document from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(uid)
          .get();

      final data = doc.data();
      if (data == null || data['truck'] == null) {
        emit(HomeFailure('No fleet data found'));
        return;
      }

      final truckMap = data['truck'] as Map<String, dynamic>;
      final int truckId = truckMap['truck_id'] as int;
      final int carrierId = truckMap['carrier_id'] as int;
      final int? featureId = truckMap['feature_id'] as int?;
      final String phone = data['phone'] ?? '';

      // 2. Resolve IDs → names from local data.json
      final langCode = context.locale.languageCode;
      final resolved = await _resolveNames(
        langCode: langCode,
        truckId: truckId,
        carrierId: carrierId,
        featureId: featureId,
      );

      emit(HomeLoaded(
        phone: phone,
        truckName: resolved['truckName'] ?? 'Unknown',
        carrierType: resolved['carrierType'] ?? 'Unknown',
        featureName: resolved['featureName'],
      ));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  Future<Map<String, String?>> _resolveNames({
    required String langCode,
    required int truckId,
    required int carrierId,
    required int? featureId,
  }) async {
    final jsonStr = await rootBundle.loadString('assets/langs/data.json');
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;

    // Pick correct language list; fallback to 'en'
    final key = ['ar', 'ur'].contains(langCode) ? langCode : 'en';
    final trucks = json[key] as List<dynamic>;

    String? truckName;
    String? carrierType;
    String? featureName;

    for (final t in trucks) {
      if (t['truck_id'] == truckId) {
        truckName = t['truck_name'] as String;
        for (final c in t['truck_data'] as List<dynamic>) {
          if (c['carrier_id'] == carrierId) {
            carrierType = c['carrier_type'] as String;
            if (featureId != null) {
              for (final f in c['carrier_features'] as List<dynamic>) {
                if (f['feature_id'] == featureId) {
                  featureName = f['name'] as String;
                  break;
                }
              }
            }
            break;
          }
        }
        break;
      }
    }

    return {
      'truckName': truckName,
      'carrierType': carrierType,
      'featureName': featureName,
    };
  }
}
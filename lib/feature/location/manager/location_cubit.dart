// lib/feature/location/manager/location_cubit.dart
//
// pubspec.yaml — add:
//   geolocator: ^13.0.2
//   geocoding: ^3.0.0
//
// android/app/src/main/AndroidManifest.xml — add inside <manifest>:
//   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
//   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
//
// ios/Runner/Info.plist — add:
//   <key>NSLocationWhenInUseUsageDescription</key>
//   <string>We need your location to find nearby shipments</string>

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../data/repo/location_repo.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepo repo;

  LocationCubit(this.repo) : super(const LocationState());

  Future<void> init() async {
    await getCities();
    await detectCurrentCity();
  }

  // ── Cities ─────────────────────────────────────────────
  Future<void> getCities() async {
    try {
      emit(state.copyWith(isCitiesLoading: true, errorMsg: null));
      final cities = await repo.getCities();
      emit(state.copyWith(isCitiesLoading: false, cities: cities));
    } catch (e) {
      emit(state.copyWith(
        isCitiesLoading: false,
        errorMsg: 'حدث خطأ أثناء تحميل المدن',
      ));
    }
  }

  // ── GPS → city name ────────────────────────────────────
  Future<void> detectCurrentCity() async {
    try {
      emit(state.copyWith(isGpsLoading: true));

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        emit(state.copyWith(isGpsLoading: false));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String? detected;
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        detected = (p.locality?.isNotEmpty == true)
            ? p.locality
            : p.subAdministrativeArea;
      }

      if (detected != null && detected.isNotEmpty) {
        final matched = _matchCity(detected);
        emit(state.copyWith(
          isGpsLoading: false,
          fromCity: matched ?? detected,
        ));
      } else {
        emit(state.copyWith(isGpsLoading: false));
      }
    } catch (_) {
      emit(state.copyWith(isGpsLoading: false));
    }
  }

  String? _matchCity(String detected) {
    final lower = detected.toLowerCase();
    for (final c in state.cities) {
      if (c.name.toLowerCase().contains(lower) ||
          lower.contains(c.name.toLowerCase())) {
        return c.name;
      }
    }
    return null;
  }

  void selectFromCity(String city) =>
      emit(state.copyWith(fromCity: city, errorMsg: null));

  void selectToCity(String city) =>
      emit(state.copyWith(toCity: city, errorMsg: null));

  // ── Search — uses repo.getAdsByFromTo(from:, to:) ──────
  Future<void> searchAds() async {
    if (state.fromCity == null || state.fromCity!.isEmpty) {
      emit(state.copyWith(errorMsg: 'الرجاء اختيار المنشأ'));
      return;
    }
    if (state.toCity == null || state.toCity!.isEmpty) {
      emit(state.copyWith(errorMsg: 'الرجاء اختيار الوجهة'));
      return;
    }
    try {
      emit(state.copyWith(isAdsLoading: true, errorMsg: null));
      final ads = await repo.getAdsByFromTo(
        originCity: state.fromCity!,
        destinationCity: state.toCity!,
      );
      emit(state.copyWith(
        isAdsLoading: false,
        ads: ads,
        hasSearched: true,
      ));
    } catch (_) {
      emit(state.copyWith(
        isAdsLoading: false,
        errorMsg: 'فشل تحميل الإعلانات',
        hasSearched: true,
      ));
    }
  }
}
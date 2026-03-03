// lib/feature/location/manager/location_state.dart

import 'package:equatable/equatable.dart';
import '../data/model/admodel.dart';
import '../data/model/city_model.dart';

class LocationState extends Equatable {
  final bool isCitiesLoading;
  final bool isGpsLoading;
  final bool isAdsLoading;
  final List<CityModel> cities;
  final List<AdModel> ads;
  final String? fromCity;
  final String? toCity;
  final String? errorMsg;
  final bool hasSearched;

  const LocationState({
    this.isCitiesLoading = false,
    this.isGpsLoading = false,
    this.isAdsLoading = false,
    this.cities = const [],
    this.ads = const [],
    this.fromCity,
    this.toCity,
    this.errorMsg,
    this.hasSearched = false,
  });

  LocationState copyWith({
    bool? isCitiesLoading,
    bool? isGpsLoading,
    bool? isAdsLoading,
    List<CityModel>? cities,
    List<AdModel>? ads,
    String? fromCity,
    String? toCity,
    String? errorMsg,
    bool? hasSearched,
  }) {
    return LocationState(
      isCitiesLoading: isCitiesLoading ?? this.isCitiesLoading,
      isGpsLoading: isGpsLoading ?? this.isGpsLoading,
      isAdsLoading: isAdsLoading ?? this.isAdsLoading,
      cities: cities ?? this.cities,
      ads: ads ?? this.ads,
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      errorMsg: errorMsg,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }

  @override
  List<Object?> get props => [
    isCitiesLoading,
    isGpsLoading,
    isAdsLoading,
    cities,
    ads,
    fromCity,
    toCity,
    errorMsg,
    hasSearched,
  ];
}
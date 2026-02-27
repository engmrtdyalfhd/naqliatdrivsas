import 'package:equatable/equatable.dart';
import 'package:naqliatsa/feature/location/data/model/admodel.dart';
// import '../data/model/ad_model.dart';
import '../data/model/city_model.dart';

class LocationState extends Equatable {
  final bool isCitiesLoading;
  final bool isAdsLoading;

  final List<CityModel> cities;
  final List<AdModel> ads;

  final String? fromCity;
  final String? toCity;

  final String? errorMsg;

  const LocationState({
    this.isCitiesLoading = false,
    this.isAdsLoading = false,
    this.cities = const [],
    this.ads = const [],
    this.fromCity,
    this.toCity,
    this.errorMsg,
  });

  LocationState copyWith({
    bool? isCitiesLoading,
    bool? isAdsLoading,
    List<CityModel>? cities,
    List<AdModel>? ads,
    String? fromCity,
    String? toCity,
    String? errorMsg,
  }) {
    return LocationState(
      isCitiesLoading: isCitiesLoading ?? this.isCitiesLoading,
      isAdsLoading: isAdsLoading ?? this.isAdsLoading,
      cities: cities ?? this.cities,
      ads: ads ?? this.ads,
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      errorMsg: errorMsg,
    );
  }

  @override
  List<Object?> get props => [
    isCitiesLoading,
    isAdsLoading,
    cities,
    ads,
    fromCity,
    toCity,
    errorMsg,
  ];
}

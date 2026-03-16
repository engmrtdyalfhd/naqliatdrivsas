import 'carrier_feature_model.dart';

final class CarrierModel {
  const CarrierModel({
    required this.id,
    required this.carrierType,
    required this.carrierFeatures,
  });

  final int id;
  final String carrierType;
  final List<CarrierFeatureModel> carrierFeatures;

  factory CarrierModel.fromJson(Map<String, dynamic> json) => CarrierModel(
    id: json['carrier_id'] as int,
    carrierType: json['carrier_type'] as String,
    carrierFeatures: (json['carrier_features'] as List<dynamic>)
        .map((e) => CarrierFeatureModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
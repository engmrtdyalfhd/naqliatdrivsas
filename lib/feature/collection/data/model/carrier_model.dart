import 'carrier_feature_model.dart';

class CarrierModel {
  final int id;
  final String carrierType;
  final List<CarrierFeatureModel> carrierFeatures;

  const CarrierModel({
    required this.id,
    required this.carrierType,
    required this.carrierFeatures,
  });

  factory CarrierModel.fromJson(Map<String, dynamic> json) {
    return CarrierModel(
      id: json['carrier_id'] as int,
      carrierType: json['carrier_type'] as String,
      carrierFeatures: (json['carrier_features'] as List<dynamic>)
          .map((e) => CarrierFeatureModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carrier_id': id,
      'carrier_type': carrierType,
      'carrier_features': carrierFeatures.map((e) => e.toJson()).toList(),
    };
  }
}

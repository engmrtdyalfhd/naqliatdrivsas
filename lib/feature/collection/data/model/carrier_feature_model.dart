final class CarrierFeatureModel {
  const CarrierFeatureModel({required this.id, required this.name});

  final int id;
  final String name;

  factory CarrierFeatureModel.fromJson(Map<String, dynamic> json) =>
      CarrierFeatureModel(
        id: json['feature_id'] as int,
        name: json['name'] as String,
      );
}
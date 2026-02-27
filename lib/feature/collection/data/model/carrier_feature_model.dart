final class CarrierFeatureModel {
  final int id;
  final String name;
  const CarrierFeatureModel({required this.id, required this.name});

  factory CarrierFeatureModel.fromJson(Map<String, dynamic> json) =>
      CarrierFeatureModel(id: json['feature_id'], name: json['name']);

  Map<String, dynamic> toJson() => {'feature_id': id, 'name': name};
}

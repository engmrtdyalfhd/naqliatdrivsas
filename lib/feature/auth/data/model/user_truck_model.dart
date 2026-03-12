final class UserTruckModel {
  UserTruckModel({
    required this.truckId,
    required this.truckName,
    required this.carrierId,
    required this.carrierType,
    required this.featureName,
    required this.featureId,
  });

  int truckId;
  String truckName;
  int carrierId;
  String carrierType;
  String? featureName;
  int? featureId;

  factory UserTruckModel.fromJson(Map<String, dynamic> json) => UserTruckModel(
    truckId: json['truck_id'] as int,
    carrierId: json['carrier_id'] as int,
    featureId: json['feature_id'] as int?,
    truckName: json['truck_name'] as String,
    carrierType: json['carrier_type'] as String,
    featureName: json['feature_name'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'truck_id': truckId,
    'carrier_id': carrierId,
    'feature_id': featureId,
    'truck_name': truckName,
    'carrier_type': carrierType,
    'feature_name': featureName,
  };
}

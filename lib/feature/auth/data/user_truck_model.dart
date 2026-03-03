import '../../collection/data/model/carrier_model.dart';

final class UserTruckModel {
  int truckId;
  String truckName;
  int carrierId;
  String carrierType;
  String? featureName;
  int? featureId;

  UserTruckModel({
    required this.truckId,
    required this.truckName,
    required this.carrierId,
    required this.carrierType,
    required this.featureName,
    required this.featureId,
  });

  factory UserTruckModel.fromJson(Map<String, dynamic> json) => UserTruckModel(
    truckId: json['truck_id'],
    carrierId: json['carrier_id'],
    featureId: json['feature_id'],
    truckName: json['truck_name'],
    carrierType: json['carrier_type'],
    featureName: json['feature_name'],
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

final class UserTruckModel {
  int? featureId;
  int truckId, carrierId;

  UserTruckModel({
    required this.truckId,
    required this.carrierId,
    required this.featureId,
  });

  factory UserTruckModel.fromJson(Map<String, dynamic> json) => UserTruckModel(
    truckId: json['truck_id'],
    carrierId: json['carrier_id'],
    featureId: json['feature_id'],
  );

  Map<String, dynamic> toJson() => {
    'truck_id': truckId,
    'carrier_id': carrierId,
    'feature_id': featureId,
  };
}

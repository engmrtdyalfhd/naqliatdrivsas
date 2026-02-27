import 'carrier_model.dart';

class TruckModel {
  final int id;
  final String truckName;
  final List<CarrierModel> carriers;

  const TruckModel({
    required this.id,
    required this.truckName,
    required this.carriers,
  });

  factory TruckModel.fromJson(Map<String, dynamic> json) {
    return TruckModel(
      id: json["truck_id"] as int,
      truckName: json['truck_name'] as String,
      carriers: (json['truck_data'] as List<dynamic>)
          .map((e) => CarrierModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'truck_id': id,
      'truck_name': truckName,
      'truck_data': carriers.map((e) => e.toJson()).toList(),
    };
  }
}

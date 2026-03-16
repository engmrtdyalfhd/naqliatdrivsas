import 'carrier_model.dart';

final class TruckModel {
  const TruckModel({
    required this.id,
    required this.truckName,
    required this.carriers,
  });

  final int id;
  final String truckName;
  final List<CarrierModel> carriers;

  String get imagePath => 'assets/images/trucks/truck_$id.png';

  factory TruckModel.fromJson(Map<String, dynamic> json) => TruckModel(
    id: json['truck_id'] as int,
    truckName: json['truck_name'] as String,
    carriers: (json['truck_data'] as List<dynamic>)
        .map((e) => CarrierModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
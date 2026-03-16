import 'truck_model.dart';

final class CollectionModel {
  const CollectionModel({
    required this.en,
    required this.ar,
    required this.ur,
  });

  final List<TruckModel> en;
  final List<TruckModel> ar;
  final List<TruckModel> ur;

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    List<TruckModel> _parse(String key) =>
        (json[key] as List<dynamic>? ?? [])
            .map((e) => TruckModel.fromJson(e as Map<String, dynamic>))
            .toList();

    return CollectionModel(en: _parse('en'), ar: _parse('ar'), ur: _parse('ur'));
  }
}
import 'truck_model.dart';

class CollectionModel {
  final List<TruckModel> en, ar, ur;
  const CollectionModel({required this.en, required this.ar, required this.ur});

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      en: (json['en'] as List<dynamic>)
          .map((e) => TruckModel.fromJson(e))
          .toList(),
      ar: (json['ar'] as List<dynamic>)
          .map((e) => TruckModel.fromJson(e))
          .toList(),
      ur: (json['ur'] as List<dynamic>)
          .map((e) => TruckModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en.map((e) => e.toJson()).toList(),
      'ar': ar.map((e) => e.toJson()).toList(),
      'ur': ur.map((e) => e.toJson()).toList(),
    };
  }
}

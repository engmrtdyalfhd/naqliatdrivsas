class CityModel {
  final String id;
  final String name;

  CityModel({required this.id, required this.name});

  factory CityModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return CityModel(id: docId, name: json['name'] ?? '');
  }
}

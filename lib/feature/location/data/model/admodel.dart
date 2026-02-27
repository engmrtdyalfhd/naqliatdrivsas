class AdModel {
  final String id;
  final String title;
  final String from;
  final String to;
  final String description;

  AdModel({
    required this.id,
    required this.title,
    required this.from,
    required this.to,
    required this.description,
  });

  factory AdModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return AdModel(
      id: docId,
      title: json['title'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

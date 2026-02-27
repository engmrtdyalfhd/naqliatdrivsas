// models/shipment.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Shipment {
  final String id;
  final String originCity;
  final String originCountry;
  final String destinationCity;
  final String destinationCountry;
  final double distanceKm;
  final String description;
  final DateTime createdAt;
  final String? phone;

  Shipment({
    required this.id,
    required this.originCity,
    required this.originCountry,
    required this.destinationCity,
    required this.destinationCountry,
    required this.distanceKm,
    required this.description,
    required this.createdAt,
    this.phone,
  });

  // تحويل من Firestore DocumentSnapshot إلى Shipment
  factory Shipment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Shipment(
      id: doc.id,
      originCity: data['originCity'] ?? '',
      originCountry: data['originCountry'] ?? '',
      destinationCity: data['destinationCity'] ?? '',
      destinationCountry: data['destinationCountry'] ?? '',
      distanceKm: (data['distanceKm'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      phone: data['phone'],
    );
  }

  // تحويل Shipment إلى Map (للإضافة في Firestore)
  Map<String, dynamic> toMap() {
    return {
      'originCity': originCity,
      'originCountry': originCountry,
      'destinationCity': destinationCity,
      'destinationCountry': destinationCountry,
      'distanceKm': distanceKm,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'phone': phone,
    };
  }
}

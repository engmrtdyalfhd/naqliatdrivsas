// lib/feature/location/data/model/admodel.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AdModel {
  final String id;
  final String title;
  final String from;
  final String fromRegion;
  final String to;
  final String toRegion;
  final String description;
  final String? phone;
  final String? cargoType;
  final double? distanceKm;
  final DateTime? createdAt;

  AdModel({
    required this.id,
    required this.title,
    required this.from,
    this.fromRegion = '',
    required this.to,
    this.toRegion = '',
    required this.description,
    this.phone,
    this.cargoType,
    this.distanceKm,
    this.createdAt,
  });

  factory AdModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return AdModel(
      id: docId,
      title: json['title'] ?? '',
      from: json['from'] ?? '',
      fromRegion: json['from_region'] ?? '',
      to: json['to'] ?? '',
      toRegion: json['to_region'] ?? '',
      description: json['description'] ?? '',
      phone: json['phone'] as String?,
      cargoType: json['cargo_type'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null
          ? (json['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  String get timeAgo {
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }
}
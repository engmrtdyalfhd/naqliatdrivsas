import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_model.dart';
import 'user_truck_model.dart';

final class UserModel extends LoginModel {
  const UserModel({
    required super.phone,
    required super.lastLogin,
    required this.truck,
  });

  final UserTruckModel? truck;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    phone: json['phone'] as String,
    lastLogin: (json['last_login'] as Timestamp).toDate(),
    truck: json['truck'] == null
        ? null
        : UserTruckModel.fromJson(json['truck'] as Map<String, dynamic>),
  );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'truck': truck?.toJson(),
  };
}

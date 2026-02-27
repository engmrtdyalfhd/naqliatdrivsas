import 'login_model.dart';
import 'user_truck_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final class UserModel extends LoginModel {
  final UserTruckModel? truck;

  const UserModel({
    required super.phone,
    required super.lastLogin,
    required this.truck,
  });

  @override
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    phone: json['phone'],
    lastLogin: (json['last_login'] as Timestamp).toDate(),
    truck: json['truck'] == null
        ? null
        : UserTruckModel.fromJson(json['truck']),
  );

  @override
  Map<String, dynamic> toJson() => {
    'phone': phone,
    'last_login': Timestamp.fromDate(lastLogin),
    'truck': truck?.toJson(),
  };
}

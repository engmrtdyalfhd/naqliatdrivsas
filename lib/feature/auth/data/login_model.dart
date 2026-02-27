import 'package:cloud_firestore/cloud_firestore.dart';

class LoginModel {
  final String phone;
  final DateTime lastLogin;

  const LoginModel({required this.phone, required this.lastLogin});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    phone: json['phone'] as String,
    lastLogin: (json['last_login'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'last_login': Timestamp.fromDate(lastLogin),
  };
}

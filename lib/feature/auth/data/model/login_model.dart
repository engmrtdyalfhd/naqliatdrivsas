import 'package:cloud_firestore/cloud_firestore.dart';

class LoginModel {
  const LoginModel({required this.phone, required this.lastLogin});

  final String phone;
  final DateTime lastLogin;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    phone: json['phone'] as String,
    lastLogin: (json['last_login'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'last_login': Timestamp.fromDate(lastLogin),
  };
}

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<Either<String, String>> sendOtp({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onAutoVerified,
    required int timeoutSeconds,
  });

  Future<Either<String, void>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<Either<String, void>> saveUser({
    required String uid,
    required String phone,
  });

  Future<Either<String, bool>> hasCompletedCollection(String uid);

  Future<void> signOut();

  String? get currentUserId;
}

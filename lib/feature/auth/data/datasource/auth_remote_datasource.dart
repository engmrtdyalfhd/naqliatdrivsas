import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDatasource {
  Future<String> sendOtp({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential) onAutoVerified,
    required int timeoutSeconds,
  });

  Future<UserCredential> signInWithOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> upsertUser({required String uid, required String phone});

  Future<bool> hasCompletedCollection(String uid);

  Future<void> signOut();

  String? get currentUserId;
}

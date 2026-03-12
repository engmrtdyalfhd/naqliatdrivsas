import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/helper/constant.dart';
import '../model/login_model.dart';
import 'auth_remote_datasource.dart';

final class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<String> sendOtp({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential) onAutoVerified,
    required int timeoutSeconds,
  }) async {
    String? resolvedVerificationId;
    Object? resolvedError;

    final future = Future<String>(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      while (resolvedVerificationId == null && resolvedError == null) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      if (resolvedError != null) throw resolvedError!;
      return resolvedVerificationId!;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: timeoutSeconds),
      codeSent: (verificationId, _) {
        resolvedVerificationId = verificationId;
      },
      verificationCompleted: onAutoVerified,
      verificationFailed: (e) {
        resolvedError = e;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        resolvedVerificationId ??= verificationId;
      },
    );

    return future;
  }

  @override
  Future<UserCredential> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  @override
  Future<void> upsertUser({required String uid, required String phone}) async {
    final ref = _firestore.collection(FirebaseStr.driversCollection).doc(uid);

    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set(
        LoginModel(phone: phone, lastLogin: DateTime.now()).toJson(),
      );
    } else {
      await ref.update({'last_login': Timestamp.fromDate(DateTime.now())});
    }
  }

  @override
  Future<bool> hasCompletedCollection(String uid) async {
    final doc = await _firestore
        .collection(FirebaseStr.driversCollection)
        .doc(uid)
        .get();
    final data = doc.data();
    return data != null && data[FirebaseStr.driverTruck] != null;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  String? get currentUserId => _auth.currentUser?.uid;
}

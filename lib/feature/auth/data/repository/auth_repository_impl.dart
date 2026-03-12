import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naqliatdrivsas/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:naqliatdrivsas/feature/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepositoryImpl(this._authRemoteDatasource);

  @override
  String? get currentUserId => _authRemoteDatasource.currentUserId;

  @override
  Future<Either<String, bool>> hasCompletedCollection(String uid) async {
    try {
      final hasCompletedCollection = await _authRemoteDatasource
          .hasCompletedCollection(uid);
      return Right(hasCompletedCollection);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> saveUser({
    required String uid,
    required String phone,
  }) async {
    try {
      await _authRemoteDatasource.upsertUser(uid: uid, phone: phone);
      return const Right(null);
    } catch (_) {
      return const Left('Failed to save user. Please try again.');
    }
  }

  @override
  Future<Either<String, String>> sendOtp({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onAutoVerified,
    required int timeoutSeconds,
  }) async {
    try {
      final verificationId = await _authRemoteDatasource.sendOtp(
        phoneNumber: phoneNumber,
        onAutoVerified: onAutoVerified,
        timeoutSeconds: timeoutSeconds,
      );
      return Right(verificationId);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (_) {
      return const Left('Unexpected error. Please try again.');
    }
  }

  @override
  Future<void> signOut() => _authRemoteDatasource.signOut();

  @override
  Future<Either<String, void>> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      await _authRemoteDatasource.signInWithOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (_) {
      return const Left('Unexpected error. Please try again.');
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-phone-number' => 'The phone number is not valid.',
      'too-many-requests' => 'Too many requests. Please try again later.',
      'invalid-verification-code' => 'The OTP code is not valid.',
      'session-expired' => 'The OTP code has expired. Please resend.',
      'invalid-verification-id' => 'Verification session is invalid.',
      _ => 'Authentication failed. Please try again.',
    };
  }
}

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/check_collection_usecase.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/save_user_usecase.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/send_otp_usecase.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/sign_out_usecase.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/verify_otp_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SendOtpUseCase _sendOtp;
  final VerifyOtpUseCase _verifyOtp;
  final SaveUserUseCase _saveUser;
  final CheckCollectionUseCase _checkCollection;
  final SignOutUseCase _signOut;

  AuthCubit({
    required SendOtpUseCase sendOtp,
    required VerifyOtpUseCase verifyOtp,
    required SaveUserUseCase saveUser,
    required CheckCollectionUseCase checkCollection,
    required SignOutUseCase signOut,
  }) : _sendOtp = sendOtp,
       _verifyOtp = verifyOtp,
       _saveUser = saveUser,
       _checkCollection = checkCollection,
       _signOut = signOut,
       super(AuthInitial());

  String phone = '';
  String smsCode = '';
  String _verificationId = '';
  int resendCountdown = 60;

  void _emit(AuthState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  Future<void> sendOtp() async {
    if (state is AuthLoading) return;
    _emit(AuthLoading());
    resendCountdown = 60;
    final result = await _sendOtp(
      phoneNumber: phone,
      onAutoVerified: _handleAutoVerified,
    );
    result.fold((error) => _emit(AuthFailure(message: error)), (
      verificationId,
    ) {
      _verificationId = verificationId;
      _emit(OtpSentState());
    });
  }

  Future<void> _handleAutoVerified(PhoneAuthCredential credential) async {
    final result = await _verifyOtp(
      verificationId: credential.verificationId ?? _verificationId,
      smsCode: credential.smsCode ?? smsCode,
    );

    await result.fold(
      (error) async => _emit(AuthFailure(message: error)),
      (_) async => _postSignIn(),
    );
  }

  Future<void> verifyOtp() async {
    if (state is AuthLoading) return;

    if (smsCode.isEmpty) {
      _emit(AuthFailure(message: 'Please enter the OTP code.'));
      return;
    }
    if (_verificationId.isEmpty) {
      _emit(
        AuthFailure(message: 'Verification session expired. Please resend.'),
      );
      return;
    }

    _emit(AuthLoading());

    final result = await _verifyOtp(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    await result.fold(
      (error) async => _emit(AuthFailure(message: error)),
      (_) async => _postSignIn(),
    );
  }

  Future<void> _postSignIn() async {
    final uid = _currentUid;
    if (uid == null) {
      _emit(AuthFailure(message: 'Sign-in succeeded but user is missing.'));
      return;
    }

    final saveResult = await _saveUser(uid: uid, phone: phone);
    if (saveResult.isLeft()) {}

    final collectionResult = await _checkCollection(uid);
    collectionResult.fold(
      (error) => _emit(AuthSuccess(hasCollection: false)),
      (hasCollection) => _emit(AuthSuccess(hasCollection: hasCollection)),
    );
  }

  Future<void> signOut() => _signOut();

  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;
}

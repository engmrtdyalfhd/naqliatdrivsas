// lib/feature/auth/manager/auth_cubit.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/helper/constant.dart';
import '../data/login_model.dart';
import '../data/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  int counter = 60;
  String phone = '';
  String smsCode = '';
  String _verifId = '';
  bool _isUserHasCollection = false;

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Safe emit — ignores calls after cubit is closed
  void _emit(AuthState state) {
    if (!isClosed) emit(state);
  }

  Future<void> sendOTP() async {
    if (state is AuthLoading) return;
    _emit(AuthLoading());
    counter = 60;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: counter),
        codeSent: (String verificationId, int? _) async {
          _verifId = verificationId;
          _emit(CodeSentState());
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _verificationCompleted(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            _emit(AuthFailure("The provided phone number is not valid."));
          } else if (e.code == 'too-many-requests') {
            _emit(AuthFailure("Too many requests. please try again later."));
          } else {
            _emit(AuthFailure("Something went wrong."));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      _emit(AuthFailure("Unexpected error. Try again later."));
    }
  }

  Future<void> _verificationCompleted(PhoneAuthCredential credential) async {
    await _auth.signInWithCredential(credential);
    await saveUser();
    _isUserHasCollection = await _didUserCollectData;
    _emit(AuthSuccess(_isUserHasCollection));
  }

  Future<void> verifyPhone() async {
    if (state is AuthLoading || smsCode.isEmpty) return;
    _emit(AuthLoading());
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        smsCode: smsCode,
        verificationId: _verifId,
      );
      await _verificationCompleted(credential);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          _emit(AuthFailure("The provided code is not valid."));
        } else if (e.code == 'session-expired') {
          _emit(AuthFailure("The provided code is expired."));
        } else if (e.code == 'invalid-verification-id') {
          _emit(AuthFailure("The provided code is invalid."));
        } else {
          _emit(AuthFailure("Something went wrong. Status code $e"));
        }
      } else {
        _emit(AuthFailure("Unexpected error. Try again later."));
      }
    }
  }

  Future<void> saveUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final doc = await _firestore
        .collection(FirebaseStr.driversCollection)
        .doc(uid)
        .get();
    if (!doc.exists) {
      await _firestore
          .collection(FirebaseStr.driversCollection)
          .doc(uid)
          .set(
        LoginModel(
          phone: phone,
          lastLogin: DateTime.now(),
        ).toJson(),
      );
    } else {
      await _firestore
          .collection(FirebaseStr.driversCollection)
          .doc(uid)
          .update({'last_login': DateTime.now()});
    }
  }

  Future<bool> get _didUserCollectData async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc = await _firestore
        .collection(FirebaseStr.driversCollection)
        .doc(uid)
        .get();
    final data = doc.data();
    return data != null && data['truck'] != null;
  }
}
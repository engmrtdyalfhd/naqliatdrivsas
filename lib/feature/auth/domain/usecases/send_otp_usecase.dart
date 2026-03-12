import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naqliatdrivsas/feature/auth/domain/repository/auth_repository.dart';

final class SendOtpUseCase {
  final AuthRepository _authRepository;

  SendOtpUseCase(this._authRepository);

  Future<Either<String, String>> call({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onAutoVerified,
    int timeoutSeconds = 60,
  }) {
    return _authRepository.sendOtp(
      phoneNumber: phoneNumber,
      onAutoVerified: onAutoVerified,
      timeoutSeconds: timeoutSeconds,
    );
  }
}

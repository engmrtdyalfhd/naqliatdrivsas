import 'package:dartz/dartz.dart';
import 'package:naqliatdrivsas/feature/auth/domain/repository/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _authRepository;

  VerifyOtpUseCase(this._authRepository);

  Future<Either<String, void>> call({
    required String verificationId,
    required String smsCode,
  }) {
    return _authRepository.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}

import 'package:dartz/dartz.dart';

import '../repository/auth_repository.dart';

final class SaveUserUseCase {
  const SaveUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<String, void>> call({
    required String uid,
    required String phone,
  }) {
    return _repository.saveUser(uid: uid, phone: phone);
  }
}
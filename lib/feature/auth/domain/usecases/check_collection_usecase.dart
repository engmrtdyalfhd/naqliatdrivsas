import 'package:dartz/dartz.dart';

import '../repository/auth_repository.dart';

final class CheckCollectionUseCase {
  const CheckCollectionUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<String, bool>> call(String uid) {
    return _repository.hasCompletedCollection(uid);
  }
}
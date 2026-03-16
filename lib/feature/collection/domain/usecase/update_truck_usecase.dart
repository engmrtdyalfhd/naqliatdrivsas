import 'package:dartz/dartz.dart';

import '../../../auth/data/model/user_truck_model.dart';
import '../repository/collection_repository.dart';

final class UpdateTruckUseCase {
  const UpdateTruckUseCase(this._repository);

  final CollectionRepository _repository;

  Future<Either<String, void>> call({
    required String uid,
    required UserTruckModel truck,
  }) {
    return _repository.updateTruck(uid: uid, truck: truck);
  }
}
import 'package:dartz/dartz.dart';

import '../../data/model/truck_model.dart';
import '../repository/collection_repository.dart';

final class GetCollectionUseCase {
  const GetCollectionUseCase(this._repository);

  final CollectionRepository _repository;

  Future<Either<String, List<TruckModel>>> call(String languageCode) {
    return _repository.getCollectionData(languageCode);
  }
}
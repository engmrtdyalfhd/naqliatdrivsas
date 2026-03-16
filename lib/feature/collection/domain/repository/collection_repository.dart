import 'package:dartz/dartz.dart';

import '../../../auth/data/model/user_truck_model.dart';
import '../../data/model/truck_model.dart';

abstract class CollectionRepository {
  Future<Either<String, List<TruckModel>>> getCollectionData(
      String languageCode);

  Future<Either<String, void>> updateTruck({
    required String uid,
    required UserTruckModel truck,
  });
}
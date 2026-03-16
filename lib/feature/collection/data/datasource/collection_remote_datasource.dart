import '../model/collection_model.dart';
import '../../../auth/data/model/user_truck_model.dart';

abstract class CollectionRemoteDatasource {
  Future<CollectionModel> getCollectionData();

  Future<void> updateTruck({
    required String uid,
    required UserTruckModel truck,
  });
}

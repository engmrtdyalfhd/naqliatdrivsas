import 'package:naqliatdrivsas/feature/location/data/model/admodel.dart';
import 'location_repo.dart';
import '../model/city_model.dart';
import '../source/location_remote_source.dart';

class LocationRepoImpl implements LocationRepo {
  @override
  final LocationRemoteSource remoteSource;

  LocationRepoImpl(this.remoteSource);

  @override
  Future<List<CityModel>> getCities() async {
    return await remoteSource.getCities();
  }

  @override
  Future<List<AdModel>> getAdsByFromTo({
    required String originCity,
    required String destinationCity,
  }) async {
    return await remoteSource.getShipmentsByRoute(
      originCity: originCity,
      destinationCity: destinationCity,
    );
  }
}
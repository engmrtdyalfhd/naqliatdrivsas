import 'package:naqliatdrivsas/feature/location/data/model/admodel.dart';
import 'package:naqliatdrivsas/feature/location/data/model/city_model.dart';
import 'package:naqliatdrivsas/feature/location/data/source/location_remote_source.dart';

class LocationRepo {
  final LocationRemoteSource remoteSource;

  LocationRepo(this.remoteSource);

  Future<List<CityModel>> getCities() async {
    return await remoteSource.getCities();
  }

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
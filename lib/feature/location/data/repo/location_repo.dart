import 'package:naqliatsa/feature/location/data/model/admodel.dart';
import 'package:naqliatsa/feature/location/data/model/city_model.dart';
import 'package:naqliatsa/feature/location/data/source/location_remote_source.dart';

class LocationRepo {
  final LocationRemoteSource remoteSource;

  LocationRepo(this.remoteSource);

  Future<List<CityModel>> getCities() async {
    return await remoteSource.getCities();
  }

  Future<List<AdModel>> getAdsByFromTo({
    required String from,
    required String to,
  }) async {
    return await remoteSource.getAdsByFromTo(from: from, to: to);
  }
}

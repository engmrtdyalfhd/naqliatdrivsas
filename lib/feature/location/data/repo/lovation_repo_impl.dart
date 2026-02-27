import 'package:naqliatsa/feature/location/data/model/admodel.dart';

import 'location_repo.dart';
// import '../model/ad_model.dart';
import '../model/city_model.dart';
import '../source/location_remote_source.dart';

class LocationRepoImpl implements LocationRepo {
  final LocationRemoteSource remoteSource;

  LocationRepoImpl(this.remoteSource);

  @override
  Future<List<CityModel>> getCities() async {
    return await remoteSource.getCities();
  }

  @override
  Future<List<AdModel>> getAdsByFromTo({
    required String from,
    required String to,
  }) async {
    return await remoteSource.getAdsByFromTo(from: from, to: to);
  }
}

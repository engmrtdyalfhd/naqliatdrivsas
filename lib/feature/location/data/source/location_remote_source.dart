import 'package:naqliatsa/feature/location/data/model/admodel.dart';

// import '../model/ad_model.dart';
import '../model/city_model.dart';

abstract class LocationRemoteSource {
  Future<List<CityModel>> getCities();
  Future<List<AdModel>> getAdsByFromTo({
    required String from,
    required String to,
  });
}

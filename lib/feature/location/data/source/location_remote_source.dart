import 'package:naqliatdrivsas/feature/location/data/model/admodel.dart';
import '../model/city_model.dart';

abstract class LocationRemoteSource {
  Future<List<CityModel>> getCities();
  Future<List<AdModel>> getShipmentsByRoute({
    required String originCity,
    required String destinationCity,
  });
}
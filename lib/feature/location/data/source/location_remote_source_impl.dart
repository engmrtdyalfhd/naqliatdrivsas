import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naqliatdrivsas/feature/location/data/model/admodel.dart';
import 'package:naqliatdrivsas/feature/location/data/source/location_remote_source.dart';
import '../model/city_model.dart';

class LocationRemoteSourceImpl implements LocationRemoteSource {
  final FirebaseFirestore firestore;

  LocationRemoteSourceImpl(this.firestore);

  @override
  Future<List<CityModel>> getCities() async {
    final snapshot = await firestore.collection("shipments").get();

    // Extract all unique city names from originCity and destinationCity
    final Set<String> cityNames = {};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final origin = data['originCity'] as String?;
      final destination = data['destinationCity'] as String?;
      if (origin != null && origin.isNotEmpty) cityNames.add(origin);
      if (destination != null && destination.isNotEmpty) cityNames.add(destination);
    }

    return cityNames
        .map((name) => CityModel(id: name, name: name))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<List<AdModel>> getShipmentsByRoute({
    required String originCity,
    required String destinationCity,
  }) async {
    final snapshot = await firestore
        .collection("shipments")
        .where("originCity", isEqualTo: originCity)
        .where("destinationCity", isEqualTo: destinationCity)
        .get();

    return snapshot.docs.map((doc) {
      return AdModel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }
}
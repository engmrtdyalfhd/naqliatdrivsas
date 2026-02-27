import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naqliatsa/feature/location/data/model/admodel.dart';
import 'package:naqliatsa/feature/location/data/source/location_remote_source.dart';
// import '../model/ad_model.dart';
import '../model/city_model.dart';
// import 'location_remote_source.dart';

class LocationRemoteSourceImpl implements LocationRemoteSource {
  final FirebaseFirestore firestore;

  LocationRemoteSourceImpl(this.firestore);

  @override
  Future<List<CityModel>> getCities() async {
    final snapshot = await firestore.collection("cities").get();

    return snapshot.docs.map((doc) {
      return CityModel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  @override
  Future<List<AdModel>> getAdsByFromTo({
    required String from,
    required String to,
  }) async {
    final snapshot = await firestore
        .collection("ads")
        .where("from", isEqualTo: from)
        .where("to", isEqualTo: to)
        .get();

    return snapshot.docs.map((doc) {
      return AdModel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }
}

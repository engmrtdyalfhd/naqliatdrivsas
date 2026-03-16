import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/helper/constant.dart';
import '../model/collection_model.dart';
import '../../../auth/data/model/user_truck_model.dart';
import 'collection_remote_datasource.dart';

final class CollectionRemoteDatasourceImpl
    implements CollectionRemoteDatasource {
  CollectionRemoteDatasourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<CollectionModel> getCollectionData() async {
    final doc = await _firestore
        .collection(FirebaseStr.dashboardCollection)
        .doc(FirebaseStr.collectDataDoc)
        .get();

    return CollectionModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateTruck({
    required String uid,
    required UserTruckModel truck,
  }) async {
    await _firestore
        .collection(FirebaseStr.driversCollection)
        .doc(uid)
        .update({FirebaseStr.driverTruck: truck.toJson()});
  }
}
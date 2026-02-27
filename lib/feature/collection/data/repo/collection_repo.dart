import 'package:dartz/dartz.dart';
import '../model/collection_model.dart';
import '../../../../core/helper/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/common/error/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/data/user_truck_model.dart';

abstract class CollectionRepo {
  Future<Either<Failure, CollectionModel>> getCollectionData();
  Future<Either<Failure, void>> updateTruck(UserTruckModel truck);
}

final class CollectionRepoImpl implements CollectionRepo {
  @override
  Future<Either<Failure, CollectionModel>> getCollectionData() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot collection = await firestore
          .collection(FirebaseStr.dashboardCollection)
          .doc(FirebaseStr.collectDataDoc)
          .get();

      // ! parse data
      final CollectionModel data = CollectionModel.fromJson(
        collection.data() as Map<String, dynamic>,
      );

      return right(data);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTruck(UserTruckModel truck) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      await FirebaseFirestore.instance
          .collection(FirebaseStr.driversCollection)
          .doc(uid)
          .update({FirebaseStr.driverTruck: truck.toJson()});

      return right(null);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}

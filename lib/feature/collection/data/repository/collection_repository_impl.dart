import 'package:dartz/dartz.dart';
import 'package:naqliatdrivsas/feature/auth/data/model/user_truck_model.dart';
import 'package:naqliatdrivsas/feature/collection/data/datasource/collection_remote_datasource.dart';
import 'package:naqliatdrivsas/feature/collection/data/model/truck_model.dart';
import 'package:naqliatdrivsas/feature/collection/domain/repository/collection_repository.dart';

final class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionRemoteDatasource _datasource;

  CollectionRepositoryImpl(this._datasource);
  @override
  Future<Either<String, List<TruckModel>>> getCollectionData(String languageCode) async {
    try{
      final model = await _datasource.getCollectionData();
      final trucks = switch (languageCode) {
        'en' => model.en,
        'ar' => model.ar,
        'ur' => model.ur,
        _ => model.en,
      };
      return Right(trucks);
    } catch (e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateTruck({required String uid, required UserTruckModel truck}) async {
    try {
      await _datasource.updateTruck(uid: uid, truck: truck);
      return const Right(null);
    } catch (e){
      return Left('Failed to save your selection. Please try again.');
    }
  }
}
// lib/core/service/service_locator.dart
// Merged both functions into one so nothing is missed.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '../../feature/collection/data/repo/collection_repo.dart';
import '../../feature/location/data/repo/location_repo.dart';
import '../../feature/location/data/repo/lovation_repo_impl.dart';
import '../../feature/location/data/source/location_remote_source.dart';
import '../../feature/location/data/source/location_remote_source_impl.dart';
import '../../feature/search/data/repo/shipment_repository.dart';

final GetIt getIt = GetIt.instance;

void serviceLocator() {
  // Collection
  getIt.registerLazySingleton<CollectionRepoImpl>(CollectionRepoImpl.new);

  // Firebase
  getIt.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  // Location
  getIt.registerLazySingleton<LocationRemoteSource>(
        () => LocationRemoteSourceImpl(getIt.get<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<LocationRepo>(
        () => LocationRepoImpl(getIt.get<LocationRemoteSource>()),
  );

  // Search / Shipment
  getIt.registerLazySingleton<ShipmentRepositoryImpl>(
    ShipmentRepositoryImpl.new,
  );
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:naqliatsa/feature/location/data/repo/location_repo.dart';
import 'package:naqliatsa/feature/location/data/repo/lovation_repo_impl.dart';
import 'package:naqliatsa/feature/location/data/source/location_remote_source.dart';
import 'package:naqliatsa/feature/location/data/source/location_remote_source_impl.dart';

import '../../feature/collection/data/repo/collection_repo.dart';

final GetIt getIt = GetIt.instance;

void serviceLocator() {
  getIt.registerLazySingleton<CollectionRepoImpl>(CollectionRepoImpl.new);
}

void setupServiceLocator() {
  // Firebase
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Location Remote Source
  getIt.registerLazySingleton<LocationRemoteSource>(
    () => LocationRemoteSourceImpl(getIt.get<FirebaseFirestore>()),
  );

  // Location Repo
  getIt.registerLazySingleton<LocationRepo>(
    () => LocationRepoImpl(getIt.get<LocationRemoteSource>()),
  );
}

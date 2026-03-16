import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Auth
import '../../feature/auth/data/datasource/auth_remote_datasource.dart';
import '../../feature/auth/data/datasource/auth_remote_datasource_impl.dart';
import '../../feature/auth/data/repository/auth_repository_impl.dart';
import '../../feature/auth/domain/repository/auth_repository.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/check_collection_usecase.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/save_user_usecase.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/send_otp_usecase.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/sign_out_usecase.dart';
import 'package:naqliatdrivsas/feature/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:naqliatdrivsas/feature/auth/presentation/cubit/auth_cubit.dart';


// Collection
import '../../feature/collection/data/datasource/collection_remote_datasource.dart';
import '../../feature/collection/data/datasource/collection_remote_datasource_impl.dart';
import '../../feature/collection/data/repository/collection_repository_impl.dart';
import '../../feature/collection/domain/repository/collection_repository.dart';
import '../../feature/collection/domain/usecase/get_collection_usecase.dart';
import '../../feature/collection/domain/usecase/update_truck_usecase.dart';
import 'package:naqliatdrivsas/feature/collection/presentation/cubit/collection_cubit.dart';


// Location
import '../../feature/location/data/repo/location_repo.dart';
import '../../feature/location/data/repo/lovation_repo_impl.dart';
import '../../feature/location/data/source/location_remote_source.dart';
import '../../feature/location/data/source/location_remote_source_impl.dart';

// Search
import '../../feature/search/data/repo/shipment_repository.dart';

final GetIt getIt = GetIt.instance;

void serviceLocator() {
  // ─── Firebase ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  // ─── Auth ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthRemoteDatasource>()),
  );
  getIt.registerLazySingleton<SendOtpUseCase>(
        () => SendOtpUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<VerifyOtpUseCase>(
        () => VerifyOtpUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SaveUserUseCase>(
        () => SaveUserUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<CheckCollectionUseCase>(
        () => CheckCollectionUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignOutUseCase>(
        () => SignOutUseCase(getIt<AuthRepository>()),
  );
  // Factory: fresh AuthCubit per route.
  getIt.registerFactory<AuthCubit>(
        () => AuthCubit(
      sendOtp: getIt<SendOtpUseCase>(),
      verifyOtp: getIt<VerifyOtpUseCase>(),
      saveUser: getIt<SaveUserUseCase>(),
      checkCollection: getIt<CheckCollectionUseCase>(),
      signOut: getIt<SignOutUseCase>(),
    ),
  );

  // ─── Collection ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<CollectionRemoteDatasource>(
        () => CollectionRemoteDatasourceImpl(
        firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<CollectionRepository>(
        () => CollectionRepositoryImpl(getIt<CollectionRemoteDatasource>()),
  );
  getIt.registerLazySingleton<GetCollectionUseCase>(
        () => GetCollectionUseCase(getIt<CollectionRepository>()),
  );
  getIt.registerLazySingleton<UpdateTruckUseCase>(
        () => UpdateTruckUseCase(getIt<CollectionRepository>()),
  );
  // Factory: fresh CollectionCubit per route.
  getIt.registerFactory<CollectionCubit>(
        () => CollectionCubit(
      getCollection: getIt<GetCollectionUseCase>(),
      updateTruck: getIt<UpdateTruckUseCase>(),
    ),
  );

  // ─── Location ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<LocationRemoteSource>(
        () => LocationRemoteSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<LocationRepo>(
        () => LocationRepoImpl(getIt<LocationRemoteSource>()),
  );

  // ─── Search ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ShipmentRepositoryImpl>(
    ShipmentRepositoryImpl.new,
  );
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/carrier_feature_model.dart';
import '../../data/model/carrier_model.dart';
import '../../data/model/truck_model.dart';
import '../../../auth/data/model/user_truck_model.dart';
import '../../domain/usecase/get_collection_usecase.dart';
import '../../domain/usecase/update_truck_usecase.dart';

part 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  CollectionCubit({
    required GetCollectionUseCase getCollection,
    required UpdateTruckUseCase updateTruck,
  })  : _getCollection = getCollection,
        _updateTruck = updateTruck,
        super(CollectionInitial());

  final GetCollectionUseCase _getCollection;
  final UpdateTruckUseCase _updateTruck;

  // ─── In-memory session ───────────────────────────────────────────────────────

  UserTruckModel userSelection = UserTruckModel(
    truckId: -1,
    truckName: '',
    carrierId: -1,
    carrierType: '',
    featureId: null,
    featureName: null,
  );

  List<CarrierModel> carriers = [];
  List<CarrierFeatureModel> features = [];

  // ─── Load ────────────────────────────────────────────────────────────────────

  /// [languageCode] comes from easy_localization: context.locale.languageCode
  Future<void> loadTrucks(String languageCode) async {
    emit(const CollectionLoading());
    final result = await _getCollection(languageCode);
    result.fold(
          (error) => emit(CollectionFailure(error)),
          (trucks) => emit(CollectionLoaded(trucks)),
    );
  }

  // ─── Selection ───────────────────────────────────────────────────────────────

  void selectTruck(TruckModel truck) {
    carriers = truck.carriers;
    features = [];
    userSelection = UserTruckModel(
      truckId: truck.id,
      truckName: truck.truckName,
      carrierId: -1,
      carrierType: '',
      featureId: null,
      featureName: null,
    );
    emit(const TruckSelected());
  }

  void selectCarrier(CarrierModel carrier) {
    features = carrier.carrierFeatures;
    userSelection
      ..carrierId = carrier.id
      ..carrierType = carrier.carrierType
      ..featureId = null
      ..featureName = null;
    emit(const CarrierSelected());
  }

  void selectFeature(CarrierFeatureModel feature) {
    userSelection
      ..featureId = feature.id
      ..featureName = feature.name;
    emit(const FeatureSelected());
  }

  void resetStep(int stepIndex) {
    if (stepIndex == 1) {
      carriers = [];
      features = [];
      userSelection
        ..carrierId = -1
        ..carrierType = ''
        ..featureId = null
        ..featureName = null;
    } else if (stepIndex == 2) {
      features = [];
      userSelection
        ..featureId = null
        ..featureName = null;
    }
  }

  bool isStepValid(int stepIndex) => switch (stepIndex) {
    0 => userSelection.truckId >= 0,
    1 => userSelection.carrierId >= 0,
    2 => features.isEmpty || userSelection.featureId != null,
    _ => false,
  };

  // ─── Save ────────────────────────────────────────────────────────────────────

  Future<void> saveSelection() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(const CollectionFailure('User session expired. Please log in again.'));
      return;
    }

    emit(const CollectionLoading());
    final result = await _updateTruck(uid: uid, truck: userSelection);
    result.fold(
          (error) => emit(CollectionFailure(error)),
          (_) => emit(const CollectionUpdated()),
    );
  }
}
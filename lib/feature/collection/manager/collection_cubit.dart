import 'package:flutter/material.dart';
import '../data/model/carrier_model.dart';
import '../data/model/truck_model.dart';
import '../../auth/data/model/user_truck_model.dart';
import '../data/repo/collection_repo.dart';
import '../data/model/collection_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/carrier_feature_model.dart';
import 'package:easy_localization/easy_localization.dart';

part 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  final CollectionRepo _repo;
  UserTruckModel userSelection = UserTruckModel(
    truckId: -1,
    carrierId: -1,
    featureId: null,
    carrierType: '',
    featureName: null,
    truckName: '',
  );
  List<CarrierModel> carriers = [];
  List<CarrierFeatureModel> features = [];
  CollectionCubit(this._repo) : super(CollectionInitial());

  Future<void> getCollectionData(BuildContext context) async {
    final result = await _repo.getCollectionData();
    result.fold(
      (failure) => emit(CollectionFailure(failure.ex)),
      (data) => emit(CollectionFetched(_suitableLang(context, data))),
    );
  }

  List<TruckModel> _suitableLang(
    BuildContext context,
    CollectionModel collection,
  ) {
    switch (context.locale.languageCode) {
      case 'ar':
        return collection.ar;
      case 'ur':
        return collection.ur;
      case 'en':
      default:
        return collection.en;
    }
  }

  void selectTruck(TruckModel truck) {
    carriers = truck.carriers;
    userSelection = UserTruckModel(
      truckId: truck.id,
      truckName: truck.truckName,
      carrierId: -1,
      carrierType: '',
      featureId: null,
      featureName: null,
    );
    emit(TruckSelected());
  }

  void selectCarrier(CarrierModel carrier) {
    features = carrier.carrierFeatures;
    userSelection
      ..carrierId = carrier.id
      ..carrierType = carrier.carrierType
      ..featureId = null
      ..featureName = null;
    emit(CarrierSelected());
  }

  void selectFeature(CarrierFeatureModel feature) {
    userSelection
      ..featureId = feature.id
      ..featureName = feature.name;
    emit(FeatureSelected());
  }

  bool isStepValid(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return userSelection.truckId >= 0;
      case 1:
        return userSelection.carrierId >= 0;
      case 2:
        if (features.isEmpty) {
          return true;
        } else {
          return userSelection.featureId != null;
        }
      default:
        return false;
    }
  }

  void resetStep(int stepIndex) {
    if (stepIndex == 0) {
      userSelection = UserTruckModel(
        truckId: -1,
        truckName: '',
        carrierId: -1,
        carrierType: '',
        featureId: null,
        featureName: null,
      );
      carriers = [];
      features = [];
    } else if (stepIndex == 1) {
      userSelection
        ..carrierId = -1
        ..carrierType = ''
        ..featureId = null
        ..featureName = null;
      features = [];
    } else if (stepIndex == 2) {
      userSelection
        ..featureId = null
        ..featureName = null;
    }
  }

  Future<void> updateUserTruck() async {
    if (state is CollectionLoading) return;
    emit(CollectionLoading());
    final result = await _repo.updateTruck(userSelection);
    result.fold(
      (failure) => emit(CollectionFailure(failure.ex)),
      (data) => emit(CollectionUpdated()),
    );
  }
}

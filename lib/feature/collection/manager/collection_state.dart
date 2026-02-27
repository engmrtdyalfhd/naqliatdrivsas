part of 'collection_cubit.dart';

sealed class CollectionState {
  const CollectionState();
}

final class CollectionInitial extends CollectionState {}

final class CollectionLoading extends CollectionState {}

final class CollectionFetched extends CollectionState {
  final List<TruckModel> trucks;
  const CollectionFetched(this.trucks);
}

final class CollectionUpdated extends CollectionState {}

final class TruckSelected extends CollectionState {}

final class CarrierSelected extends CollectionState {}

final class FeatureSelected extends CollectionState {}

final class CollectionFailure extends CollectionState {
  final String error;
  const CollectionFailure(this.error);
}

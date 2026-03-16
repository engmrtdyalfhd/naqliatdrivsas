part of 'collection_cubit.dart';

sealed class CollectionState {
  const CollectionState();
}

final class CollectionInitial extends CollectionState {
  const CollectionInitial();
}

final class CollectionLoading extends CollectionState {
  const CollectionLoading();
}

/// Trucks loaded — ready to display the stepper.
final class CollectionLoaded extends CollectionState {
  const CollectionLoaded(this.trucks);
  final List<TruckModel> trucks;
}

/// A truck was selected → rebuild the carrier list.
final class TruckSelected extends CollectionState {
  const TruckSelected();
}

/// A carrier was selected → rebuild the feature list.
final class CarrierSelected extends CollectionState {
  const CarrierSelected();
}

/// A feature was selected → rebuild the feature tile.
final class FeatureSelected extends CollectionState {
  const FeatureSelected();
}

/// Firestore update succeeded → navigate to AuthGate.
final class CollectionUpdated extends CollectionState {
  const CollectionUpdated();
}

/// Any operation failed — [message] is safe to show in the UI.
final class CollectionFailure extends CollectionState {
  const CollectionFailure(this.message);
  final String message;
}
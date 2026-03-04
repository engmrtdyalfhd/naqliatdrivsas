
part of 'search_cubit.dart';

class SearchState extends Equatable {
  final bool isCitiesLoading;
  final bool isShipmentsLoading;
  final List<SaudiCity> cities;
  final List<Shipment> shipments;
  final String? fromCity;
  final String? toCity;
  final String? errorMsg;
  final bool hasSearched;

  const SearchState({
    this.isCitiesLoading = false,
    this.isShipmentsLoading = false,
    this.cities = const [],
    this.shipments = const [],
    this.fromCity,
    this.toCity,
    this.errorMsg,
    this.hasSearched = false,
  });

  SearchState copyWith({
    bool? isCitiesLoading,
    bool? isShipmentsLoading,
    List<SaudiCity>? cities,
    List<Shipment>? shipments,
    String? fromCity,
    String? toCity,
    String? errorMsg,
    bool? hasSearched,
  }) {
    return SearchState(
      isCitiesLoading: isCitiesLoading ?? this.isCitiesLoading,
      isShipmentsLoading: isShipmentsLoading ?? this.isShipmentsLoading,
      cities: cities ?? this.cities,
      shipments: shipments ?? this.shipments,
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      errorMsg: errorMsg,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }

  @override
  List<Object?> get props => [
    isCitiesLoading,
    isShipmentsLoading,
    cities,
    shipments,
    fromCity,
    toCity,
    errorMsg,
    hasSearched,
  ];
}
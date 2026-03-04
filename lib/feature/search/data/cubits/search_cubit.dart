// lib/feature/search/data/cubits/search_cubit.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/saudi_city.dart';
import '../model/shipment_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  // ── Load cities from static list ───────────────────────
  void loadCities() {
    emit(state.copyWith(isCitiesLoading: true));
    // Sorted alphabetically by region then city name
    final sorted = List<SaudiCity>.from(kSaudiCities)
      ..sort((a, b) {
        final r = a.region.compareTo(b.region);
        return r != 0 ? r : a.name.compareTo(b.name);
      });
    emit(state.copyWith(isCitiesLoading: false, cities: sorted));
  }

  void selectFromCity(String city) =>
      emit(state.copyWith(fromCity: city, errorMsg: null));

  void selectToCity(String city) =>
      emit(state.copyWith(toCity: city, errorMsg: null));

  void swapCities() {
    if (state.fromCity == null && state.toCity == null) return;
    emit(state.copyWith(
      fromCity: state.toCity,
      toCity: state.fromCity,
      errorMsg: null,
    ));
  }

  // ── Search Firestore ───────────────────────────────────
  Future<void> searchShipments() async {
    if (state.fromCity == null || state.fromCity!.isEmpty) {
      emit(state.copyWith(errorMsg: 'الرجاء اختيار المنشأ'));
      return;
    }
    if (state.toCity == null || state.toCity!.isEmpty) {
      emit(state.copyWith(errorMsg: 'الرجاء اختيار الوجهة'));
      return;
    }

    try {
      emit(state.copyWith(isShipmentsLoading: true, errorMsg: null));

      final snapshot = await FirebaseFirestore.instance
          .collection('shipments')
          .where('originCity', isEqualTo: state.fromCity)
          .where('destinationCity', isEqualTo: state.toCity)
          .orderBy('createdAt', descending: true)
          .get();

      final shipments =
      snapshot.docs.map((doc) => Shipment.fromFirestore(doc)).toList();

      emit(state.copyWith(
        isShipmentsLoading: false,
        shipments: shipments,
        hasSearched: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isShipmentsLoading: false,
        errorMsg: 'فشل تحميل الحمولات: $e',
        hasSearched: true,
      ));
    }
  }
}
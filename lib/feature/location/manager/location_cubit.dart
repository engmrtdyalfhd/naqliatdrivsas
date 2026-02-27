import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/location_repo.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepo repo;

  LocationCubit(this.repo) : super(const LocationState());

  Future<void> init() async {
    await getCities();
  }

  Future<void> getCities() async {
    try {
      emit(state.copyWith(isCitiesLoading: true, errorMsg: null));

      final cities = await repo.getCities();

      emit(state.copyWith(isCitiesLoading: false, cities: cities));
    } catch (e) {
      emit(
        state.copyWith(
          isCitiesLoading: false,
          errorMsg: "حدث خطأ أثناء تحميل المدن",
        ),
      );
    }
  }

  void selectFromCity(String city) {
    emit(state.copyWith(fromCity: city, errorMsg: null));
  }

  void selectToCity(String city) {
    emit(state.copyWith(toCity: city, errorMsg: null));
  }

  Future<void> searchAds() async {
    if (state.fromCity == null || state.fromCity!.isEmpty) {
      emit(state.copyWith(errorMsg: "الرجاء اختيار المنشأ"));
      return;
    }

    if (state.toCity == null || state.toCity!.isEmpty) {
      emit(state.copyWith(errorMsg: "الرجاء اختيار الوجهة"));
      return;
    }

    try {
      emit(state.copyWith(isAdsLoading: true, errorMsg: null));

      final ads = await repo.getAdsByFromTo(
        from: state.fromCity!,
        to: state.toCity!,
      );

      emit(state.copyWith(isAdsLoading: false, ads: ads));
    } catch (e) {
      emit(
        state.copyWith(isAdsLoading: false, errorMsg: "فشل تحميل الإعلانات"),
      );
    }
  }
}

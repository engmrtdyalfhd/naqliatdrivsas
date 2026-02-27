// cubit/search/search_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naqliatsa/feature/search/data/model/shipment_model.dart';
import 'package:naqliatsa/feature/search/data/repo/shipment_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ShipmentRepository repository;

  SearchCubit(this.repository) : super(SearchInitial());

  Future<void> loadShipments() async {
    emit(SearchLoading());
    try {
      final shipments = await repository.getShipments();
      emit(SearchLoaded(shipments));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> deleteShipment(String id) async {
    try {
      await repository.deleteShipment(id);
      // إعادة تحميل الحمولات
      await loadShipments();
    } catch (e) {
      emit(SearchError('فشل الحذف: $e'));
    }
  }
}

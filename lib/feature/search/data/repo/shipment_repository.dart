// data/repositories/shipment_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naqliatsa/feature/search/data/model/shipment_model.dart';
// import '../../models/shipment.dart';

abstract class ShipmentRepository {
  Future<List<Shipment>> getShipments();
  Future<void> addShipment(Shipment shipment);
  Future<void> deleteShipment(String id);
}

class ShipmentRepositoryImpl extends ShipmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Shipment>> getShipments() async {
    try {
      final querySnapshot = await _firestore
          .collection('shipments')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Shipment.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('فشل تحميل الحمولات: $e');
    }
  }

  @override
  Future<void> addShipment(Shipment shipment) async {
    try {
      await _firestore.collection('shipments').add(shipment.toMap());
    } catch (e) {
      throw Exception('فشل إضافة الحمولة: $e');
    }
  }

  @override
  Future<void> deleteShipment(String id) async {
    try {
      await _firestore.collection('shipments').doc(id).delete();
    } catch (e) {
      throw Exception('فشل حذف الحمولة: $e');
    }
  }
}

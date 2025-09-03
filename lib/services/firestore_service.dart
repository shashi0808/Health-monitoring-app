import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sensor_reading.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'sensor_readings';

  Future<void> saveReading(SensorReading reading) async {
    await _firestore.collection(_collection).add(reading.toMap());
  }

  Future<List<SensorReading>> getUserReadings(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => SensorReading.fromSnapshot(doc))
        .toList();
  }

  Stream<List<SensorReading>> getUserReadingsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SensorReading.fromSnapshot(doc))
            .toList());
  }

  Future<SensorReading?> getLatestReading(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return SensorReading.fromSnapshot(snapshot.docs.first);
    }
    return null;
  }

  Future<void> deleteReading(String readingId) async {
    await _firestore.collection(_collection).doc(readingId).delete();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorReading {
  final String id;
  final double temperature;
  final double moisture;
  final DateTime timestamp;
  final String userId;

  SensorReading({
    required this.id,
    required this.temperature,
    required this.moisture,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'moisture': moisture,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
    };
  }

  factory SensorReading.fromMap(Map<String, dynamic> map, String id) {
    return SensorReading(
      id: id,
      temperature: map['temperature']?.toDouble() ?? 0.0,
      moisture: map['moisture']?.toDouble() ?? 0.0,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      userId: map['userId'] ?? '',
    );
  }

  factory SensorReading.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SensorReading.fromMap(data, snapshot.id);
  }
}
import 'package:flutter/material.dart';
import '../models/sensor_reading.dart';
import '../services/bluetooth_service.dart';
import '../services/mock_auth_service.dart';

class SensorProvider extends ChangeNotifier {
  final BluetoothService _bluetoothService = BluetoothService();
  final MockAuthService _authService = MockAuthService();
  final List<SensorReading> _storedReadings = [];
  
  SensorReading? _latestReading;
  List<SensorReading> _readings = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isBluetoothConnected = false;

  SensorReading? get latestReading => _latestReading;
  List<SensorReading> get readings => _readings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isBluetoothConnected => _isBluetoothConnected;

  Future<void> fetchNewReading() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final reading = await _bluetoothService.getReading();
      final user = _authService.currentUser;
      
      if (user != null) {
        final sensorReading = SensorReading(
          id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
          temperature: reading['temperature'] ?? 0.0,
          moisture: reading['moisture'] ?? 0.0,
          timestamp: DateTime.now(),
          userId: user.uid,
        );

        _storedReadings.add(sensorReading);
        _latestReading = sensorReading;
        _readings = List.from(_storedReadings.where((r) => r.userId == user.uid).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp)));
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadReadings() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        _readings = _storedReadings.where((r) => r.userId == user.uid).toList();
        _readings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        if (_readings.isNotEmpty) {
          _latestReading = _readings.first;
        }
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> connectToBluetooth() async {
    try {
      _isLoading = true;
      notifyListeners();

      _isBluetoothConnected = await _bluetoothService.connect();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isBluetoothConnected = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
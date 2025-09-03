import 'dart:async';
import 'dart:math';

class BluetoothService {
  bool _isConnected = false;
  final Random _random = Random();

  Future<bool> connect() async {
    await Future.delayed(const Duration(seconds: 2));
    _isConnected = true;
    return _isConnected;
  }

  Future<void> disconnect() async {
    _isConnected = false;
  }

  Future<Map<String, double>> getReading() async {
    if (!_isConnected) {
      throw Exception('Not connected to Bluetooth device');
    }

    await Future.delayed(const Duration(seconds: 1));

    final temperature = 15.0 + _random.nextDouble() * 20.0;
    final moisture = 20.0 + _random.nextDouble() * 60.0;

    return {
      'temperature': double.parse(temperature.toStringAsFixed(1)),
      'moisture': double.parse(moisture.toStringAsFixed(1)),
    };
  }

  bool get isConnected => _isConnected;

  Future<List<String>> scanDevices() async {
    await Future.delayed(const Duration(seconds: 3));
    
    return [
      'Soil Monitor Device 1',
      'Soil Monitor Device 2',
      'Generic BLE Device',
    ];
  }
}
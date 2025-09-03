import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/sensor_provider.dart';
import '../models/sensor_reading.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _showTemperature = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SensorProvider>(context, listen: false).loadReadings();
    });
  }

  List<FlSpot> _getChartData(List<SensorReading> readings) {
    if (readings.isEmpty) return [];
    
    return readings.asMap().entries.map((entry) {
      final index = entry.key;
      final reading = entry.value;
      final value = _showTemperature ? reading.temperature : reading.moisture;
      return FlSpot(index.toDouble(), value);
    }).toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading History'),
        backgroundColor: Colors.green,
      ),
      body: Consumer<SensorProvider>(
        builder: (context, sensorProvider, child) {
          final readings = sensorProvider.readings;

          if (readings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No readings available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Take some tests to see your history',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chart View',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          ToggleButtons(
                            isSelected: [_showTemperature, !_showTemperature],
                            onPressed: (int index) {
                              setState(() {
                                _showTemperature = index == 0;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('Temperature'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('Moisture'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      _showTemperature 
                                        ? '${value.toStringAsFixed(1)}°C'
                                        : '${value.toStringAsFixed(1)}%',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= 0 && index < readings.length) {
                                      final reading = readings.reversed.toList()[index];
                                      return Text(
                                        DateFormat('MM/dd').format(reading.timestamp),
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _getChartData(readings),
                                isCurved: true,
                                color: _showTemperature ? Colors.orange : Colors.blue,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: (_showTemperature ? Colors.orange : Colors.blue)
                                      .withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Readings (${readings.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...readings.take(10).map((reading) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: const Icon(
                              Icons.eco,
                              color: Colors.green,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.thermostat, 
                                        size: 16, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Text('${reading.temperature}°C'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.water_drop, 
                                        size: 16, color: Colors.blue),
                                    const SizedBox(width: 4),
                                    Text('${reading.moisture}%'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy - HH:mm').format(reading.timestamp),
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, 
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getHealthColor(reading.temperature, reading.moisture),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getHealthStatus(reading.temperature, reading.moisture),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                      if (readings.length > 10) ...[
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Showing 10 of ${readings.length} readings',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getHealthColor(double temperature, double moisture) {
    if (temperature >= 20 && temperature <= 30 && moisture >= 40 && moisture <= 70) {
      return Colors.green;
    } else if (temperature >= 15 && temperature <= 35 && moisture >= 30 && moisture <= 80) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getHealthStatus(double temperature, double moisture) {
    if (temperature >= 20 && temperature <= 30 && moisture >= 40 && moisture <= 70) {
      return 'Good';
    } else if (temperature >= 15 && temperature <= 35 && moisture >= 30 && moisture <= 80) {
      return 'Fair';
    } else {
      return 'Poor';
    }
  }
}
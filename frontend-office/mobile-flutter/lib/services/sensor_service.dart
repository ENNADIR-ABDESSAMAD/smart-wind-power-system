import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_reading.dart';

class SensorService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<SensorReading> fetchLatest({String? deviceId}) async {
    final uri = deviceId != null
        ? Uri.parse('$baseUrl/sensors/latest?deviceId=$deviceId')
        : Uri.parse('$baseUrl/sensors/latest');

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load latest reading');
    }
    return SensorReading.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<SensorReading>> fetchHistory({int limit = 20}) async {
    final uri = Uri.parse('$baseUrl/sensors/history?limit=$limit');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load history');
    }
    final list = json.decode(response.body) as List<dynamic>;
    return list
        .map((e) => SensorReading.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

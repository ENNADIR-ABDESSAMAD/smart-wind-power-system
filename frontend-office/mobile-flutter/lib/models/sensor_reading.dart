class SensorReading {
  final int id;
  final String deviceId;
  final double voltage;
  final double? temperature;
  final double? humidity;
  final bool relayOn;
  final DateTime recordedAt;

  SensorReading({
    required this.id,
    required this.deviceId,
    required this.voltage,
    this.temperature,
    this.humidity,
    required this.relayOn,
    required this.recordedAt,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      id: json['id'] as int,
      deviceId: json['device_id'] as String,
      voltage: (json['voltage'] as num).toDouble(),
      temperature: json['temperature'] != null
          ? (json['temperature'] as num).toDouble()
          : null,
      humidity: json['humidity'] != null
          ? (json['humidity'] as num).toDouble()
          : null,
      relayOn: json['relay_on'] as bool? ?? false,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );
  }
}

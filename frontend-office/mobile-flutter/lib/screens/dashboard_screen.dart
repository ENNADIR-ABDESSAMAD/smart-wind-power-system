import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_reading.dart';
import '../services/sensor_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _service = SensorService();
  SensorReading? _latest;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final reading = await _service.fetchLatest();
      if (mounted) {
        setState(() {
          _latest = reading;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'API indisponible');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Wind Power')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _error != null
            ? Center(child: Text(_error!, style: const TextStyle(color: Colors.redAccent)))
            : _latest == null
                ? const Center(child: CircularProgressIndicator())
                : _buildDashboard(_latest!),
      ),
    );
  }

  Widget _buildDashboard(SensorReading r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _metricCard('Tension', '${r.voltage.toStringAsFixed(2)} V', Icons.bolt),
        const SizedBox(height: 12),
        _metricCard('Température', '${r.temperature?.toStringAsFixed(1) ?? '—'} °C', Icons.thermostat),
        const SizedBox(height: 12),
        _metricCard('Humidité', '${r.humidity?.toStringAsFixed(0) ?? '—'} %', Icons.water_drop),
        const SizedBox(height: 12),
        _metricCard('Charge LED', r.relayOn ? 'ON' : 'OFF', Icons.lightbulb),
      ],
    );
  }

  Widget _metricCard(String label, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class WeatherSnapshot {
  WeatherSnapshot({
    required this.temperatureC,
    required this.maxC,
    required this.minC,
    required this.conditionCode,
    required this.generatedAt,
  });

  final double temperatureC;
  final double maxC;
  final double minC;
  final String conditionCode;
  final DateTime generatedAt;

  Map<String, dynamic> toJson() => {
        'temperatureC': temperatureC,
        'maxC': maxC,
        'minC': minC,
        'conditionCode': conditionCode,
        'generatedAt': generatedAt.toIso8601String(),
      };

  factory WeatherSnapshot.fromJson(Map<String, dynamic> json) =>
      WeatherSnapshot(
        temperatureC: (json['temperatureC'] as num).toDouble(),
        maxC: (json['maxC'] as num).toDouble(),
        minC: (json['minC'] as num).toDouble(),
        conditionCode: json['conditionCode'] as String,
        generatedAt: DateTime.parse(json['generatedAt'] as String),
      );
}

/// Serviço simples que gera um clima aproximado e persiste última leitura.
class WeatherService {
  WeatherService._internal();

  static final WeatherService instance = WeatherService._internal();
  static const _cacheKey = 'weather_snapshot_cache';
  static const _cacheValidity = Duration(minutes: 45);

  Future<WeatherSnapshot> obterClimaAtual() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedRaw = prefs.getString(_cacheKey);

    if (cachedRaw != null) {
      try {
        final decoded = jsonDecode(cachedRaw) as Map<String, dynamic>;
        final snapshot = WeatherSnapshot.fromJson(decoded);
        final diff = DateTime.now().difference(snapshot.generatedAt);
        if (diff < _cacheValidity) {
          return snapshot;
        }
      } catch (_) {
        await prefs.remove(_cacheKey);
      }
    }

    final generated = _gerarSnapshotLocal();
    await prefs.setString(_cacheKey, jsonEncode(generated.toJson()));
    return generated;
  }

  WeatherSnapshot _gerarSnapshotLocal() {
    final now = DateTime.now();
    // Temperaturas médias Belém variam entre 24ºC e 33ºC.
    final dayProgress = (now.hour * 60 + now.minute) / (24 * 60);
    final base = 28 + sin(dayProgress * 2 * pi) * 3; // 25-31
    final max = base + 2 + Random(now.day + now.month).nextDouble();
    final min = base - 4 + Random(now.day).nextDouble() * 1.5;

    final condition = _definirCondicao(now);

    return WeatherSnapshot(
      temperatureC: double.parse(base.toStringAsFixed(1)),
      maxC: double.parse(max.toStringAsFixed(1)),
      minC: double.parse(min.toStringAsFixed(1)),
      conditionCode: condition,
      generatedAt: now,
    );
  }

  String _definirCondicao(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour >= 11 && hour <= 15) {
      return 'sunny';
    }
    if (hour >= 16 && hour <= 21) {
      return 'rain';
    }
    return 'cloudy';
  }
}

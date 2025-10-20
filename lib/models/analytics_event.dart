import 'package:uuid/uuid.dart';

/// Representa um evento de telemetria.
class AnalyticsEvent {
  AnalyticsEvent({
    String? id,
    required this.name,
    required this.timestamp,
    required this.properties,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> properties;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'timestamp': timestamp.toIso8601String(),
        'properties': properties,
      };

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) => AnalyticsEvent(
        id: json['id'] as String?,
        name: json['name'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        properties:
            Map<String, dynamic>.from(json['properties'] as Map<dynamic, dynamic>),
      );
}

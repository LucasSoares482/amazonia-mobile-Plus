import 'package:dio/dio.dart';
import '../core/http.dart';

class ApiClient {

  ApiClient({Dio? dio}) : _dio = dio ?? createDio();
  final Dio _dio;

  /// GET /api/health
  Future<Map<String, dynamic>> health() async {
    final res = await _dio.get('/api/health');
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// POST /api/auth/login
  /// body: { "email": "...", "password": "..." }
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );
    return LoginResponse.fromJson(res.data as Map<String, dynamic>);
  }

  /// POST /api/auth/register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? nationality,
  }) async {
    final res = await _dio.post(
      '/api/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (nationality != null) 'nationality': nationality,
      },
    );
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// GET /api/events/nearby?latitude=-1.45&longitude=-48.48&radius=5
  Future<List<EventItem>> eventsNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 5,
  }) async {
    final res = await _dio.get(
      '/api/events/nearby',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radiusKm,
      },
    );

    final data = res.data;
    if (data is List) {
      return data
          .map((e) => EventItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } else if (data is Map && data['data'] is List) {
      // caso a API retorne { data: [...] }
      return (data['data'] as List)
          .map((e) => EventItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }
}

class LoginResponse {

  LoginResponse({required this.token, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
      token: (json['token'] ?? json['access_token'] ?? '') as String,
      user:
          json['user'] is Map ? Map<String, dynamic>.from(json['user']) : null,
    );
  final String token;
  final Map<String, dynamic>? user;
}

class EventItem {

  EventItem({
    this.id,
    this.name,
    this.description,
    this.location,
    this.latitude,
    this.longitude,
    this.startTime,
    this.endTime,
    this.eventType,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    double? _d(v) {
      if (v == null) return null;
      return double.tryParse(v.toString());
    }

    return EventItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      location: json['location']?.toString(),
      latitude: _d(json['latitude']),
      longitude: _d(json['longitude']),
      startTime: _parseDate(json['start_time'] ?? json['startTime']),
      endTime: _parseDate(json['end_time'] ?? json['endTime']),
      eventType: json['event_type']?.toString(),
    );
  }
  final int? id;
  final String? name;
  final String? description;
  final String? location;
  final double? latitude;
  final double? longitude;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? eventType;
}

import 'package:dio/dio.dart';
import '../core/http.dart';

/// Um cliente para interagir com a API do AmaCoins.
class ApiClient {
  /// Cria uma nova instância do ApiClient.
  ApiClient({Dio? dio}) : _dio = dio ?? createDio();
  final Dio _dio;

  /// GET /api/health
  /// Verifica o estado da API.
  Future<Map<String, dynamic>> health() async {
    final res = await _dio.get('/api/health');
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// POST /api/auth/login
  /// Autentica um utilizador com email e senha.
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
  /// Regista um novo utilizador.
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
  /// Obtém eventos próximos a uma determinada localização.
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

/// A resposta da API de login.
class LoginResponse {
  /// Cria uma nova instância de LoginResponse.
  LoginResponse({required this.token, this.user});

  /// Cria uma instância de LoginResponse a partir de um JSON.
  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: (json['token'] ?? json['access_token'] ?? '') as String,
        user:
            json['user'] is Map ? Map<String, dynamic>.from(json['user']) : null,
      );

  /// O token de autenticação.
  final String token;
  /// Os dados do utilizador.
  final Map<String, dynamic>? user;
}

/// Representa um item de evento da API.
class EventItem {
  /// Cria uma nova instância de EventItem.
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

  /// Cria uma instância de EventItem a partir de um JSON.
  factory EventItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    double? d(v) {
      if (v == null) return null;
      return double.tryParse(v.toString());
    }

    return EventItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      location: json['location']?.toString(),
      latitude: d(json['latitude']),
      longitude: d(json['longitude']),
      startTime: parseDate(json['start_time'] ?? json['startTime']),
      endTime: parseDate(json['end_time'] ?? json['endTime']),
      eventType: json['event_type']?.toString(),
    );
  }

  /// O ID do evento.
  final int? id;
  /// O nome do evento.
  final String? name;
  /// A descrição do evento.
  final String? description;
  /// A localização do evento.
  final String? location;
  /// A latitude do evento.
  final double? latitude;
  /// A longitude do evento.
  final double? longitude;
  /// A data de início do evento.
  final DateTime? startTime;
  /// A data de fim do evento.
  final DateTime? endTime;
  /// O tipo do evento.
  final String? eventType;
}
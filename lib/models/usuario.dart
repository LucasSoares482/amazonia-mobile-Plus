import 'package:flutter/foundation.dart';

/// Representa o modelo de um utilizador na aplicação.
class Usuario {
  /// Cria um novo utilizador.
  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipo,
    this.amacoins = 0,
    this.fotoPerfil,
    this.bio,
    this.pais,
    this.idade,
  });

  /// Cria um utilizador a partir de um mapa de dados.
  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
        id: map['id']?.toString(),
        nome: map['nome'],
        email: map['email'],
        senha: map['senha'],
        tipo: map['tipo'] ?? 'visitador',
        amacoins: map['amacoins'] ?? 0,
        fotoPerfil: _sanitizeFoto(map['foto_perfil']),
        bio: map['bio'],
        pais: map['pais'],
        idade: map['idade'] is int
            ? map['idade'] as int
            : int.tryParse(map['idade']?.toString() ?? ''),
      );

  /// ID único do utilizador.
  String? id;
  /// Nome completo do utilizador.
  String nome;
  /// Email do utilizador.
  String email;
  /// Senha do utilizador (deve ser tratada com hash em produção).
  String senha;
  /// Tipo de utilizador: 'visitador' ou 'responsavel'.
  String tipo;
  /// Quantidade de AmaCoins do utilizador.
  int amacoins;
  /// Caminho para a foto de perfil do utilizador.
  String? fotoPerfil;
  /// Biografia breve do utilizador.
  String? bio;
  /// País de origem do utilizador.
  String? pais;
  /// Idade informada pelo utilizador.
  int? idade;

  /// Retorna `true` se o utilizador for um visitador.
  bool get isVisitador => tipo == 'visitador';
  /// Retorna `true` se o utilizador for um responsável.
  bool get isResponsavel => tipo == 'responsavel';
  /// Retorna `true` se o utilizador for administrador.
  bool get isAdministrador => tipo == 'administrador' || tipo == 'admin' || tipo == 'responsavel';
  /// Retorna `true` se o utilizador for o perfil comum.
  bool get isUsuarioComum => !isAdministrador;

  /// Converte o objeto Utilizador para um mapa de dados.
  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'email': email,
        'senha': senha,
        'tipo': tipo,
        'amacoins': amacoins,
        'foto_perfil': fotoPerfil,
        'bio': bio,
        'pais': pais,
        'idade': idade,
      };

  static String? _sanitizeFoto(dynamic value) {
    final path = value?.toString();
    if (path == null || path.isEmpty) return null;
    if (kIsWeb && path.startsWith('blob:')) return null;
    return path;
  }
}

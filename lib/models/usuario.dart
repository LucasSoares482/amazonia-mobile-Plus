// models/usuario.dart - Modelo de usuário atualizado
class Usuario {
  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipo, // 'visitador' ou 'responsavel'
    this.amacoins = 0,
    this.fotoPerfil,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      tipo: map['tipo'] ?? 'visitador',
      amacoins: map['amacoins'] ?? 0,
      fotoPerfil: map['foto_perfil'],
    );

  int? id;
  String nome;
  String email;
  String senha;
  String tipo; // 'visitador' ou 'responsavel'
  int amacoins;
  String? fotoPerfil;

  bool get isVisitador => tipo == 'visitador';
  bool get isResponsavel => tipo == 'responsavel';

  Map<String, dynamic> toMap() => {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipo': tipo,
      'amacoins': amacoins,
      'foto_perfil': fotoPerfil,
    };
}
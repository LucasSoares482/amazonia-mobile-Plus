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
  });

  /// Cria um utilizador a partir de um mapa de dados.
  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
        id: map['id']?.toString(),
        nome: map['nome'],
        email: map['email'],
        senha: map['senha'],
        tipo: map['tipo'] ?? 'visitador',
        amacoins: map['amacoins'] ?? 0,
        fotoPerfil: map['foto_perfil'],
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

  /// Retorna `true` se o utilizador for um visitador.
  bool get isVisitador => tipo == 'visitador';
  /// Retorna `true` se o utilizador for um responsável.
  bool get isResponsavel => tipo == 'responsavel';

  /// Converte o objeto Utilizador para um mapa de dados.
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

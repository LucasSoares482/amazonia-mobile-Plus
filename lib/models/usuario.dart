class Usuario {
  int? id;
  String nome;
  String email;
  String senha;
  int amacoins;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.amacoins = 100,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'amacoins': amacoins,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      amacoins: map['amacoins'],
    );
  }
}
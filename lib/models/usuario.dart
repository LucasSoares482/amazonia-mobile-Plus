class Usuario {

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.amacoins = 100,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      amacoins: map['amacoins'],
    );
  int? id;
  String nome;
  String email;
  String senha;
  int amacoins;

  Map<String, dynamic> toMap() => {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'amacoins': amacoins,
    };
}
/// Representa uma movimentação na carteira de AmaCoins.
class WalletTransaction {
  WalletTransaction({
    required this.id,
    required this.tipo,
    required this.descricao,
    required this.valor,
    required this.data,
    this.contexto,
  });

  /// Identificador único da transação.
  final String id;

  /// Tipo da transação: `credito` ou `debito`.
  final String tipo;

  /// Descrição amigável exibida ao utilizador.
  final String descricao;

  /// Quantidade de AmaCoins (positiva para crédito, negativa para débito).
  final int valor;

  /// Data/hora em que a transação ocorreu.
  final DateTime data;

  /// Metadados adicionais (ex.: evento, parceiro).
  final Map<String, dynamic>? contexto;

  bool get isCredito => valor >= 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo,
        'descricao': descricao,
        'valor': valor,
        'data': data.toIso8601String(),
        if (contexto != null) 'contexto': contexto,
      };

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      WalletTransaction(
        id: json['id'] as String,
        tipo: json['tipo'] as String,
        descricao: json['descricao'] as String,
        valor: json['valor'] as int,
        data: DateTime.parse(json['data'] as String),
        contexto: json['contexto'] == null
            ? null
            : Map<String, dynamic>.from(json['contexto'] as Map),
      );
}

/// Representa um item que pode ser resgatado com AmaCoins.
class RedeemItem {
  RedeemItem({
    required this.nome,
    required this.parceiro,
    required this.custo,
    required this.descricao,
    this.codigoParceiro,
  });

  final String nome;
  final String parceiro;
  final int custo;
  final String descricao;
  final String? codigoParceiro;
}

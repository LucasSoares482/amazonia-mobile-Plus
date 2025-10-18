/// Representa um ponto turístico destacado na Home.
class PontoTuristico {
  PontoTuristico({
    required this.nome,
    required this.descricao,
    required this.endereco,
    required this.latitude,
    required this.longitude,
    this.imagem,
  });

  final String nome;
  final String descricao;
  final String endereco;
  final double latitude;
  final double longitude;
  final String? imagem;

  Uri get linkUber => Uri.parse(
        'https://m.uber.com/ul/?action=setPickup'
        '&dropoff[latitude]=$latitude'
        '&dropoff[longitude]=$longitude'
        '&dropoff[nickname]=${Uri.encodeComponent(nome)}',
      );

  Uri get link99 => Uri.parse(
        'https://app.99app.com/ul/?action=setPickup'
        '&destination[latitude]=$latitude'
        '&destination[longitude]=$longitude'
        '&destination[nickname]=${Uri.encodeComponent(nome)}',
      );

  Uri get linkGoogle => Uri.parse(
        'https://www.google.com/search?q=${Uri.encodeComponent(nome)}',
      );
}

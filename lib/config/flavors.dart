import '../env/env.dart';

/// Enumeração para os diferentes ambientes da aplicação.
enum Flavor { 
  /// Ambiente de desenvolvimento.
  dev, 
  /// Ambiente de teste (staging).
  staging, 
  /// Ambiente de produção.
  prod 
}

/// Obtém o ambiente atual da aplicação com base na variável de ambiente.
Flavor get currentFlavor {
  switch (Env.flavor) {
    case 'prod':
      return Flavor.prod;
    case 'staging':
      return Flavor.staging;
    default:
      return Flavor.dev;
  }
}

/// Obtém o título da aplicação com base no ambiente atual.
String get appTitle {
  switch (currentFlavor) {
    case Flavor.dev:
      return 'AmaCoins (DEV)';
    case Flavor.staging:
      return 'AmaCoins (STAGING)';
    case Flavor.prod:
      return 'AmaCoins';
  }
}
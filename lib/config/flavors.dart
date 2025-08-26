import '../env/env.dart';

enum Flavor { dev, staging, prod }

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

String get appTitle {
  switch (currentFlavor) {
    case Flavor.dev:
      return 'Amazônia Experience (DEV)';
    case Flavor.staging:
      return 'Amazônia Experience (STAGING)';
    case Flavor.prod:
      return 'Amazônia Experience';
  }
}

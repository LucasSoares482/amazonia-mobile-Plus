# Amazônia Experience

Aplicativo mobile de turismo sustentável na Amazônia com sistema de gamificação.

## Sobre o Projeto

O Amazônia Experience incentiva o turismo responsável através de check-ins em locais turísticos, recompensando usuários com AmaCoins (moeda virtual) por visitarem pontos de interesse ecológico.

## Tecnologias

- **Flutter** 3.x
- **Dart** 
- **Material Design** 3
- **Banco de dados** em memória

## Funcionalidades

- Sistema de autenticação (login/cadastro)
- Check-in em locais turísticos
- Sistema de recompensas com AmaCoins
- Histórico de visitas
- Lista de eventos ecológicos
- Carteira digital
- Interface responsiva

## Pré-requisitos

- Flutter SDK 3.x ou superior
- Dart SDK
- Android SDK (para compilar APK)
- Git

## Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/amazonia-mobile-Plus.git
cd amazonia-mobile-Plus/mobile_amazonia/mobile_amazonia
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Verifique a instalação

```bash
flutter doctor
```

## Como Executar

### Executar no navegador

```bash
flutter run -d chrome
```

### Executar em dispositivo Android conectado

```bash
flutter run
```

### Executar em emulador

```bash
flutter emulators --launch <emulator_id>
flutter run
```

## Compilar o Projeto

### APK Debug (desenvolvimento)

```bash
flutter build apk --debug
```
Arquivo gerado em: `build/app/outputs/flutter-apk/app-debug.apk`

### APK Release (produção)

```bash
flutter build apk --release
```
Arquivo gerado em: `build/app/outputs/flutter-apk/app-release.apk`

### APK Split por arquitetura (recomendado)

```bash
flutter build apk --split-per-abi
```
Arquivos gerados:
- `app-armeabi-v7a-release.apk` (32-bit)
- `app-arm64-v8a-release.apk` (64-bit)
- `app-x86_64-release.apk` (emulador)

### Build para Web

```bash
flutter build web
```
Arquivos gerados em: `build/web/`

## Estrutura do Projeto

```
lib/
├── main.dart                 # Entrada da aplicação
├── rotas.dart               # Definição de rotas
├── database/
│   └── database_helper.dart # Gerenciamento de dados
├── models/
│   └── usuario.dart         # Modelo de usuário
├── utils/
│   ├── app_state.dart       # Estado global
│   └── responsive.dart     # Helpers responsivos
└── telas/
    ├── tela_abertura.dart   # Splash screen
    ├── tela_login.dart      # Login
    ├── tela_cadastro.dart   # Cadastro
    ├── tela_checkin.dart    # Check-in
    ├── tela_historico.dart  # Histórico
    └── telas_simples.dart   # Demais telas
```

## Credenciais de Teste

- **Email:** demo@email.com
- **Senha:** 1234

## Resolução de Problemas

### Erro: "No Android SDK found"

Instale o Android SDK:
```bash
# Linux/Mac
cd ~/
mkdir -p Android/Sdk
# Baixe e configure o Android Command Line Tools
```

### Erro: "Flutter command not found"

Adicione o Flutter ao PATH:
```bash
export PATH="$PATH:/caminho/para/flutter/bin"
```

### Build falha no Android

Verifique as versões no `android/app/build.gradle`:
```gradle
minSdk = 21
targetSdk = 34
```

## Testes

```bash
# Executar testes unitários
flutter test

# Executar testes com cobertura
flutter test --coverage
```

## Requisitos Mínimos

- **Android:** 5.0 (API 21)
- **Espaço:** 50MB
- **RAM:** 1GB

## Licença

MIT

## Autor

Lucas Soares dos Santos

## Contribuições

Projeto acadêmico - contribuições não são aceitas no momento.

## Versão

1.0.0

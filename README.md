# AmaCoins - App de Turismo Sustentável

Aplicativo mobile de turismo sustentável na Amazônia com sistema de gamificação para visitadores e responsáveis por eventos.

## ✨ Funcionalidades Principais

### 👥 Sistema de Usuários
- **Visitador**: Visita eventos e ganha AmaCoins
- **Responsável**: Cria e gerencia eventos para visitadores

### 🔐 Autenticação
- Login com usuários de teste pré-configurados
- Cadastro com seleção de tipo de usuário
- Persistência de sessão

### 📱 Navegação com Sidebar
- **Carteira**: Visualizar saldo e histórico de AmaCoins
- **Check-in**: Confirmar presença em eventos
- **Histórico**: Ver visitas realizadas com compartilhamento WhatsApp
- **Perfil**: Editar dados e foto com câmera
- **Mapa**: Visualizar localizações (Google Maps)
- **Emergência**: Contatos importantes

### 🎯 Para Visitadores
- Lista de eventos disponíveis
- Check-in automático com recompensa em AmaCoins
- Histórico de visitas com botão compartilhar WhatsApp
- Sistema de pontuação gamificado

### 🏢 Para Responsáveis
- Criar novos eventos com foto via câmera
- Gerenciar eventos criados
- Definir recompensas em AmaCoins
- Editar/excluir eventos

### 📸 Sistema de Câmera
- Foto de perfil personalizável
- Fotos para eventos (responsáveis)
- Integração com câmera e galeria

## 🚀 Como Executar

### 1. Pré-requisitos
```bash
flutter --version  # Flutter 3.8.1 ou superior
```

### 2. Instalar dependências
```bash
flutter pub get
```

### 3. Executar no navegador
```bash
flutter run -d chrome
```

### 4. Executar no Android
```bash
flutter run
```

## 👥 Usuários de Teste

### Visitador
- **Email**: visitador@test.com
- **Senha**: 1234
- **Funcionalidades**: Ver eventos, fazer check-in, ganhar AmaCoins

### Responsável
- **Email**: responsavel@test.com  
- **Senha**: 1234
- **Funcionalidades**: Criar eventos, gerenciar localizações

## 🏗️ Estrutura do Projeto

```
lib/
├── main.dart                    # Entrada principal
├── rotas.dart                   # Sistema de rotas
├── config/
│   └── flavors.dart            # Configurações de ambiente
├── core/
│   ├── crash_reporter.dart     # Relatório de erros
│   ├── http.dart               # Cliente HTTP
│   └── log.dart                # Sistema de logs
├── database/
│   └── database_helper.dart    # Banco em memória
├── env/
│   └── env.dart                # Variáveis de ambiente
├── models/
│   └── usuario.dart            # Modelo de usuário
├── telas/
│   ├── tela_abertura.dart      # Splash screen
│   ├── tela_login.dart         # Login
│   ├── tela_cadastro.dart      # Cadastro
│   ├── tela_home_principal.dart # Tela principal
│   ├── tela_carteira.dart      # Carteira
│   ├── tela_checkin.dart       # Check-in
│   ├── tela_historico.dart     # Histórico
│   ├── tela_perfil.dart        # Perfil
│   ├── tela_criar_evento.dart  # Criar eventos
│   ├── tela_mapa.dart          # Google Maps
│   └── tela_emergencia.dart    # Emergência
├── utils/
│   ├── app_state.dart          # Estado global
│   └── responsive.dart         # Utilitários responsivos
└── widgets/
    └── sidebar_drawer.dart     # Sidebar navegação
```

## 🎮 Como Usar

1. **Abrir app** → Tela splash → Login automático
2. **Login Visitador** → Ver eventos → Fazer check-in → Ganhar AmaCoins
3. **Login Responsável** → Criar eventos → Adicionar foto → Gerenciar
4. **Sidebar** → Acessar carteira, perfil, histórico, emergência
5. **Compartilhar** → Histórico → WhatsApp para amigos

## 📱 Funcionalidades Técnicas

- **Banco de dados**: Em memória (SharedPreferences para persistência)
- **Navegação**: Sistema de rotas com argumentos
- **Estado**: Singleton AppState para usuário logado
- **Câmera**: image_picker para fotos
- **Compartilhamento**: url_launcher para WhatsApp
- **Mapas**: Google Maps Flutter (configurar API key)
- **Responsivo**: Layout adaptativo para diferentes tamanhos

## 🔧 Configuração Adicional

### Google Maps (Opcional)
1. Criar API key no Google Cloud Console
2. Adicionar em `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_API_KEY_AQUI"/>
```

### Permissões Android
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

## 🐛 Problemas Resolvidos

✅ **Fluxo inicial correto**: Splash → Login → Home  
✅ **Usuários de teste funcionais**  
✅ **Sistema de tipos**: Visitador vs Responsável  
✅ **Navegação sidebar completa**  
✅ **Check-in com recompensas**  
✅ **Câmera para perfil e eventos**  
✅ **Compartilhamento WhatsApp**  
✅ **Persistência de dados**  

## 📋 TODO

- [ ] Integração com API real
- [ ] Push notifications
- [ ] Offline mode
- [ ] Testes automatizados
- [ ] CI/CD pipeline

## 📄 Licença

MIT License - Projeto acadêmico

## 👨‍💻 Autor

**Nome**: Desenvolvedor Flutter  
**Projeto**: Sistema de turismo gamificado para Amazônia
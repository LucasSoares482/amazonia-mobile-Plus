import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Simple localization helper using in-memory maps.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('zh', 'CN'),
    Locale('ru'),
  ];

  static final Map<String, String> _en = {
    'appTitle': 'Amazonia Experience',
    'onboardingSubtitle': 'Sustainability at your fingertips',
    'onboardingMessageLogged': 'Preparing your personalized journey...',
    'onboardingMessageGuest': 'Loading resources for your adventure...',
    'loginTitle': 'Sign in',
    'loginSubtitle':
        'Connect with a sustainable Belém and earn AmaCoins along the way.',
    'loginEmailLabel': 'E-mail',
    'loginEmailError': 'Please enter your e-mail',
    'loginPasswordLabel': 'Password',
    'loginPasswordError': 'Please enter your password',
    'loginPrimaryButton': 'Sign in',
    'loginForgotPassword': 'Forgot your password?',
    'loginSignupLink': 'Create account',
    'loginSuccess': 'Signed in successfully',
    'loginInvalidCredentials':
        'Email or password incorrect. You still have {count} attempts.',
    'loginRemainingAttempts':
        'Email or password incorrect. You still have {count} attempts.',
    'loginAttemptsExceeded':
        'Number of login attempts exceeded. Try again in 3 hours.',
    'loginQuickAccessTitle': 'Quick access (testing)',
    'loginQuickAccessVisitor': 'Sign in as visitor',
    'loginQuickAccessResponsible': 'Sign in as organizer',
    'signupTitle': 'Create your account',
    'signupSubtitle':
        'Join the Amazon experience with exclusive benefits and AmaCoins.',
    'signupNameLabel': 'Full name',
    'signupNameError': 'Please enter your full name',
    'signupEmailLabel': 'E-mail',
    'signupEmailError': 'Please enter a valid e-mail',
    'signupPasswordLabel': 'Password',
    'signupPasswordError': 'Password must have at least 6 characters',
    'signupSubmit': 'Create account',
    'signupSuccess': 'Account created successfully!',
    'signupEmailExists': 'E-mail already registered',
    'signupRoleTitle': 'Account type',
    'signupRoleVisitorTitle': 'Visitor',
    'signupRoleVisitorSubtitle': 'To explore events and earn AmaCoins',
    'signupRoleResponsibleTitle': 'Organizer',
    'signupRoleResponsibleSubtitle': 'To create and manage events',
    'drawerHome': 'Home',
    'drawerProfile': 'My profile',
    'drawerWallet': 'Wallet',
    'drawerCheckIn': 'Check-in',
    'drawerEmergency': 'Emergency',
    'drawerChat': 'Chat',
    'drawerManageUsers': 'Manage users',
    'drawerManagePoints': 'Manage attractions',
    'drawerStatistics': 'Statistics',
    'drawerDarkMode': 'Dark mode',
    'drawerLanguage': 'Language: {language}',
    'drawerLogout': 'Sign out',
    'drawerLogoutTitle': 'Sign out',
    'drawerLogoutMessage': 'Are you sure you want to leave the app?',
    'drawerCancel': 'Cancel',
    'drawerConfirm': 'Confirm',
    'dialogSelectLanguageTitle': 'Choose a language',
    'roleAdmin': 'Administrator',
    'roleUser': 'Regular user',
    'drawerSettingsHint':
        'Adjust language, theme and accessibility shortcuts in the settings (coming soon).',
    'drawerGreeting': 'Hello, {name}',
    'chatPlaceholder': 'Ask about Belém, COP30 or AmaCoins...',
    'chatSendError': 'We could not send your message. Please try again.',
    'chatStatusSending': 'Sending...',
    'chatStatusDelivered': 'Delivered',
    'chatStatusError': 'Not sent',
    'chatActionRetry': 'Try again',
    'homeRefreshTooltip': 'Refresh',
    'homeBalanceLabel': 'Available balance',
    'homeAmaCoinsLabel': 'AmaCoins',
    'homeAgendaOfflineFallback':
        'We are showing the latest agenda saved on your device (offline mode).',
    'homeAgendaLoadError':
        'We could not update the COP30 agenda right now. Please try again soon.',
    'homeAgendaRetryHint': 'Pull to refresh when you regain connection.',
    'homeAgendaOfficialCardTitle': 'Official COP 30 events',
    'homeAgendaOfficialCardSubtitle':
        'Track the core sessions, panels and forums of the conference.',
    'copDetailsTitle': 'COP 30 in the Amazon',
    'copDetailsSubtitle':
        'Belém hosts heads of state, scientists and civil society in a decisive climate agenda.',
    'copDetailsIntro':
        'The official programme gathers working groups, plenary sessions and cultural activities focused on climate justice.',
    'copDetailsSectionTitle': 'Official COP 30 events',
    'saboresTitle': 'Flavours of the Amazon',
    'saboresSubtitle':
        'Typical recipes with ingredients from the forest and the rivers of Pará.',
    'saboresIntro':
        'Each dish celebrates biodiversity, ancestral techniques and the creativity of the people of the Amazon.',
    'saboresSectionTitle': 'Dishes to discover',
    'saboresCardSubtitle': 'Authentic flavours from Pará cuisine.',
    'saboresViewGoogle': 'See on Google',
    'errorRedirectHint': 'You will be redirected shortly to the Home screen.',
    'errorGoHome': 'Go to Home now',
    'checkinAlreadyRegistered': 'This check-in was already registered.',
    'checkinQueuedMessage':
        'Check-in stored offline. We will sync it once you are connected again.',
    'checkinMapTitle': 'Official venues and partner spaces',
    'checkinMapSubtitle':
        'Explore the hubs on the map and validate your presence by scanning the official QR code.',
    'checkinCaptureButton': 'Scan QR Code',
    'checkinQrUnavailable':
        'QR scanning is unavailable on this device. Try with a compatible device.',
    'checkinQrSuccess': 'Check-in confirmed! +30 AmaCoins',
    'checkinQrInvalid': 'QR code not recognized. Try again.',
    'checkinOpenMaps': 'Open full map',
    'checkinOpenMapsError': 'We could not open the map right now.',
    'homeWeatherTitle': 'Belém now',
    'homeWeatherUpdated': 'Updated at {time}',
    'homeWeatherRange': 'High {max}° • Low {min}°',
    'homeWeatherFallback': 'Using locally generated forecast.',
    'homeWeatherLoading': 'Getting the latest weather for Belém...',
    'homeWeatherError': 'We could not update the weather.',
    'homeWeatherRetry': 'Try again',
    'homeWeatherConditionSunny': 'Sunny',
    'homeWeatherConditionCloudy': 'Cloudy',
    'homeWeatherConditionRain': 'Rain expected',
    'languageChangeError': 'Failed to change language. Please try again.',
    'sliderViewMore': 'Learn more',
    'emergencyCallError': 'We couldn\'t start the call.',
  };

  static final Map<String, String> _ptBr = {
    ..._en,
    'onboardingSubtitle': 'Sustentabilidade na palma da sua mão',
    'onboardingMessageLogged': 'Preparando sua experiência personalizada...',
    'onboardingMessageGuest': 'Carregando recursos para sua jornada...',
    'loginTitle': 'Entrar',
    'loginSubtitle':
        'Conecte-se à Belém sustentável e garanta seus AmaCoins.',
    'loginEmailError': 'Digite seu e-mail',
    'loginPasswordLabel': 'Senha',
    'loginPasswordError': 'Digite sua senha',
    'loginPrimaryButton': 'Entrar',
    'loginForgotPassword': 'Esqueci minha senha',
    'loginSignupLink': 'Cadastre-se',
    'loginSuccess': 'Login realizado com sucesso',
    'loginInvalidCredentials':
        'Email ou senha incorretos. Você ainda tem {count} tentativas.',
    'loginRemainingAttempts':
        'Email ou senha incorretos. Você ainda tem {count} tentativas.',
    'loginAttemptsExceeded':
        'Número de tentativas de login esgotadas. Tente novamente em 3 horas.',
    'loginQuickAccessTitle': 'Acesso rápido (ambiente de testes)',
    'loginQuickAccessVisitor': 'Entrar como Visitador',
    'loginQuickAccessResponsible': 'Entrar como Responsável',
    'signupTitle': 'Crie sua conta',
    'signupSubtitle':
        'Participe da experiência Amazônia com benefícios exclusivos.',
    'signupNameLabel': 'Nome completo',
    'signupNameError': 'Digite seu nome',
    'signupEmailError': 'Digite um e-mail válido',
    'signupPasswordLabel': 'Senha',
    'signupPasswordError': 'Use ao menos 6 caracteres',
    'signupSubmit': 'Criar conta',
    'signupSuccess': 'Conta criada com sucesso!',
    'signupEmailExists': 'E-mail já cadastrado',
    'signupRoleTitle': 'Tipo de conta',
    'signupRoleVisitorTitle': 'Visitador',
    'signupRoleVisitorSubtitle': 'Para visitar eventos e ganhar AmaCoins',
    'signupRoleResponsibleTitle': 'Responsável',
    'signupRoleResponsibleSubtitle': 'Para criar e gerenciar eventos',
    'drawerProfile': 'Meu Perfil',
    'drawerWallet': 'Carteira',
    'drawerEmergency': 'Emergência',
    'drawerManageUsers': 'Gerenciar Usuários',
    'drawerManagePoints': 'Gerenciar Pontos Turísticos',
    'drawerStatistics': 'Estatísticas',
    'drawerDarkMode': 'Modo escuro',
    'drawerLanguage': 'Idioma: {language}',
    'drawerLogout': 'Sair do aplicativo',
    'drawerLogoutTitle': 'Sair do aplicativo',
    'drawerLogoutMessage': 'Você tem certeza que quer sair do aplicativo?',
    'drawerCancel': 'Cancelar',
    'drawerConfirm': 'Confirmar',
    'dialogSelectLanguageTitle': 'Escolha o idioma',
    'roleAdmin': 'Administrador',
    'roleUser': 'Usuário comum',
    'drawerSettingsHint':
        'Ajuste idioma, modo claro/escuro e recursos de acessibilidade pelo menu de configurações (em breve).',
    'drawerGreeting': 'Olá, {name}',
    'chatPlaceholder': 'Pergunte sobre Belém, COP30 ou AmaCoins...',
    'chatSendError': 'Não foi possível enviar agora. Tente novamente.',
    'chatStatusSending': 'Enviando...',
    'chatStatusDelivered': 'Entregue',
    'chatStatusError': 'Não enviada',
    'chatActionRetry': 'Tentar novamente',
    'homeRefreshTooltip': 'Atualizar',
    'homeBalanceLabel': 'Saldo disponível',
    'homeAmaCoinsLabel': 'AmaCoins',
    'homeAgendaOfflineFallback':
        'Agenda carregada em modo offline. Mostrando última sincronização.',
    'homeAgendaLoadError':
        'Não foi possível atualizar a agenda da COP30 agora. Tente novamente em instantes.',
    'homeAgendaRetryHint': 'Puxe para atualizar assim que a conexão voltar.',
    'homeAgendaOfficialCardTitle': 'Eventos Oficiais da COP 30',
    'homeAgendaOfficialCardSubtitle':
        'Acompanhe as sessões centrais, painéis e fóruns oficiais da conferência.',
    'copDetailsTitle': 'COP 30 na Amazônia',
    'copDetailsSubtitle':
        'Belém recebe chefes de estado, cientistas e sociedade civil em uma agenda climática decisiva.',
    'copDetailsIntro':
        'A programação oficial reúne grupos de trabalho, plenárias e atividades culturais focadas em justiça climática.',
    'copDetailsSectionTitle': 'Eventos oficiais da COP 30',
    'saboresTitle': 'Sabores da Amazônia',
    'saboresSubtitle':
        'Receitas típicas com ingredientes da floresta e dos rios paraenses.',
    'saboresIntro':
        'Cada prato celebra a biodiversidade, as técnicas ancestrais e a criatividade do povo amazônida.',
    'saboresSectionTitle': 'Pratos para explorar',
    'saboresCardSubtitle': 'Sabores autênticos da culinária paraense.',
    'saboresViewGoogle': 'Ver no Google',
    'errorRedirectHint': 'Você será redirecionado para a Home em instantes.',
    'errorGoHome': 'Ir para a Home agora',
    'checkinAlreadyRegistered': 'Este check-in já foi registrado.',
    'checkinQueuedMessage':
        'Check-in registrado offline. Vamos sincronizar assim que houver conexão.',
    'checkinMapTitle': 'Pontos oficiais e espaços parceiros',
    'checkinMapSubtitle':
        'Explore os polos no mapa e valide sua presença escaneando o QR Code oficial.',
    'checkinCaptureButton': 'Capturar QR Code',
    'checkinQrUnavailable':
        'QR Code indisponível neste dispositivo. Utilize um aparelho compatível.',
    'checkinQrSuccess': 'Check-in validado! +30 AmaCoins',
    'checkinQrInvalid': 'QR Code inválido. Tente novamente.',
    'checkinOpenMaps': 'Ver no mapa completo',
    'checkinOpenMapsError': 'Não foi possível abrir o mapa agora.',
    'homeWeatherTitle': 'Belém agora',
    'homeWeatherUpdated': 'Atualizado às {time}',
    'homeWeatherRange': 'Máx {max}° • Mín {min}°',
    'homeWeatherFallback': 'Previsão gerada localmente no dispositivo.',
    'languageChangeError': 'Falha ao mudar idioma. Tente novamente.',
    'sliderViewMore': 'Ver mais',
    'homeWeatherLoading': 'Obtendo o clima de Belém...',
    'homeWeatherError': 'Não conseguimos atualizar o clima.',
    'homeWeatherRetry': 'Tentar novamente',
    'homeWeatherConditionSunny': 'Ensolarado',
    'homeWeatherConditionCloudy': 'Parcialmente nublado',
    'homeWeatherConditionRain': 'Chuva prevista',
    'languageChangeError': 'Falha ao mudar idioma. Tente novamente.',
    'emergencyCallError': 'Não foi possível iniciar a chamada.',
  };

  static final Map<String, String> _ptPt = {
    ..._ptBr,
    'onboardingMessageLogged':
        'A preparar a sua experiência personalizada...',
    'onboardingMessageGuest': 'A carregar recursos para a sua viagem...',
    'chatStatusError': 'Não enviada',
    'chatActionRetry': 'Tentar novamente',
    'homeWeatherTitle': 'Belém agora',
    'homeWeatherUpdated': 'Atualizado às {time}',
    'homeWeatherRange': 'Máx {max}° • Mín {min}°',
    'homeWeatherFallback': 'Previsão gerada localmente no dispositivo.',
  };

  static final Map<String, String> _es = {
    ..._en,
    'onboardingSubtitle': 'Sostenibilidad en la palma de tu mano',
    'onboardingMessageLogged':
        'Preparando tu experiencia personalizada...',
    'onboardingMessageGuest': 'Cargando recursos para tu aventura...',
    'loginTitle': 'Iniciar sesión',
    'loginSubtitle':
        'Conéctate con un Belém sostenible y acumula AmaCoins.',
    'loginEmailLabel': 'Correo electrónico',
    'loginEmailError': 'Ingresa tu correo electrónico',
    'loginPasswordLabel': 'Contraseña',
    'loginPasswordError': 'Ingresa tu contraseña',
    'loginPrimaryButton': 'Entrar',
    'loginForgotPassword': '¿Olvidaste la contraseña?',
    'loginSignupLink': 'Crear cuenta',
    'loginSuccess': 'Inicio de sesión correcto',
    'loginInvalidCredentials':
        'Correo o contraseña incorrectos. Te quedan {count} intentos.',
    'loginRemainingAttempts':
        'Correo o contraseña incorrectos. Te quedan {count} intentos.',
    'loginAttemptsExceeded':
        'Se agotaron los intentos. Intenta nuevamente en 3 horas.',
    'loginQuickAccessTitle': 'Acceso rápido (pruebas)',
    'loginQuickAccessVisitor': 'Entrar como visitante',
    'loginQuickAccessResponsible': 'Entrar como responsable',
    'signupTitle': 'Crea tu cuenta',
    'signupSubtitle':
        'Vive la experiencia amazónica con beneficios exclusivos.',
    'signupNameLabel': 'Nombre completo',
    'signupNameError': 'Ingresa tu nombre',
    'signupEmailError': 'Ingresa un correo válido',
    'signupPasswordLabel': 'Contraseña',
    'signupPasswordError': 'Usa al menos 6 caracteres',
    'signupSubmit': 'Crear cuenta',
    'signupSuccess': '¡Cuenta creada con éxito!',
    'signupEmailExists': 'Correo ya registrado',
    'signupRoleTitle': 'Tipo de cuenta',
    'signupRoleVisitorTitle': 'Visitante',
    'signupRoleVisitorSubtitle': 'Para visitar eventos y ganar AmaCoins',
    'signupRoleResponsibleTitle': 'Responsable',
    'signupRoleResponsibleSubtitle': 'Para crear y gestionar eventos',
    'drawerHome': 'Inicio',
    'drawerProfile': 'Mi perfil',
    'drawerWallet': 'Cartera',
    'drawerEmergency': 'Emergencia',
    'drawerManageUsers': 'Gestionar usuarios',
    'drawerManagePoints': 'Gestionar puntos turísticos',
    'drawerStatistics': 'Estadísticas',
    'drawerDarkMode': 'Modo oscuro',
    'drawerLanguage': 'Idioma: {language}',
    'drawerLogout': 'Cerrar sesión',
    'drawerLogoutTitle': 'Cerrar sesión',
    'drawerLogoutMessage': '¿Seguro que deseas salir de la aplicación?',
    'drawerCancel': 'Cancelar',
    'drawerConfirm': 'Confirmar',
    'dialogSelectLanguageTitle': 'Elige un idioma',
    'roleAdmin': 'Administrador',
    'roleUser': 'Usuario habitual',
    'drawerSettingsHint':
        'Ajusta idioma, tema y accesibilidad desde la configuración (próximamente).',
    'drawerGreeting': 'Hola, {name}',
    'chatPlaceholder': 'Pregunta sobre Belém, la COP30 o AmaCoins...',
    'chatSendError': 'No fue posible enviar ahora. Inténtalo nuevamente.',
    'homeAgendaOfflineFallback':
        'Mostrando la agenda guardada en el dispositivo (modo offline).',
    'homeAgendaLoadError':
        'No pudimos actualizar la agenda de la COP30 en este momento. Intenta más tarde.',
    'homeAgendaRetryHint': 'Desliza hacia abajo para actualizar cuando tengas conexión.',
    'homeAgendaOfficialCardTitle': 'Eventos oficiales de la COP 30',
    'homeAgendaOfficialCardSubtitle':
        'Sigue las sesiones centrales, paneles y foros principales de la conferencia.',
    'copDetailsTitle': 'COP 30 en la Amazonía',
    'copDetailsSubtitle':
        'Belém recibe a jefes de Estado, científicos y sociedad civil en una agenda climática decisiva.',
    'copDetailsIntro':
        'El programa oficial reúne grupos de trabajo, plenarias y actividades culturales enfocadas en la justicia climática.',
    'copDetailsSectionTitle': 'Eventos oficiales de la COP 30',
    'saboresTitle': 'Sabores de la Amazonía',
    'saboresSubtitle':
        'Recetas típicas con ingredientes de la selva y los ríos paraenses.',
    'saboresIntro':
        'Cada plato celebra la biodiversidad, las técnicas ancestrales y la creatividad del pueblo amazónico.',
    'saboresSectionTitle': 'Platos para explorar',
    'saboresCardSubtitle': 'Sabores auténticos de la cocina paraense.',
    'saboresViewGoogle': 'Ver en Google',
    'errorRedirectHint':
        'Serás redirigido a la pantalla principal en instantes.',
    'errorGoHome': 'Ir a la Home ahora',
    'checkinAlreadyRegistered': 'Este check-in ya fue registrado.',
    'checkinQueuedMessage':
        'Check-in guardado sin conexión. Lo sincronizaremos cuando vuelvas a estar conectado.',
    'checkinMapTitle': 'Puntos oficiales y espacios aliados',
    'checkinMapSubtitle':
        'Explora los polos en el mapa y valida tu presencia escaneando el código QR oficial.',
    'checkinCaptureButton': 'Capturar código QR',
    'checkinQrUnavailable':
        'El escaneo de códigos no está disponible en este dispositivo. Usa uno compatible.',
    'checkinQrSuccess': '¡Check-in validado! +30 AmaCoins',
    'checkinQrInvalid': 'Código QR inválido. Inténtalo nuevamente.',
    'checkinOpenMaps': 'Ver en el mapa completo',
    'checkinOpenMapsError': 'No pudimos abrir el mapa ahora.',
    'homeWeatherTitle': 'Belém ahora',
    'homeWeatherUpdated': 'Actualizado a las {time}',
    'homeWeatherRange': 'Máx {max}° • Mín {min}°',
    'homeWeatherFallback': 'Pronóstico generado localmente en el dispositivo.',
    'homeWeatherLoading': 'Obteniendo el clima de Belém...',
    'homeWeatherError': 'No pudimos actualizar el clima.',
    'homeWeatherRetry': 'Intentar de nuevo',
    'homeWeatherConditionSunny': 'Soleado',
    'homeWeatherConditionCloudy': 'Parcialmente nublado',
    'homeWeatherConditionRain': 'Lluvia esperada',
    'languageChangeError': 'No pudimos cambiar el idioma. Inténtalo nuevamente.',
    'sliderViewMore': 'Ver más',
    'chatStatusSending': 'Enviando...',
    'chatStatusDelivered': 'Entregado',
    'chatStatusError': 'No enviado',
    'chatActionRetry': 'Intentar de nuevo',
    'homeRefreshTooltip': 'Actualizar',
    'homeBalanceLabel': 'Saldo disponible',
    'homeAmaCoinsLabel': 'AmaCoins',
    'emergencyCallError': 'No fue posible iniciar la llamada.',
  };

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': _en,
    'pt': _ptBr,
    'pt-PT': _ptPt,
    'es': _es,
    'fr': _en,
    'de': _en,
    'zh-CN': _en,
    'ru': _en,
  };

  String get appTitle => _valueForKey('appTitle');
  String get onboardingSubtitle => _valueForKey('onboardingSubtitle');
  String get onboardingMessageLogged => _valueForKey('onboardingMessageLogged');
  String get onboardingMessageGuest => _valueForKey('onboardingMessageGuest');
  String get loginTitle => _valueForKey('loginTitle');
  String get loginSubtitle => _valueForKey('loginSubtitle');
  String get loginEmailLabel => _valueForKey('loginEmailLabel');
  String get loginEmailError => _valueForKey('loginEmailError');
  String get loginPasswordLabel => _valueForKey('loginPasswordLabel');
  String get loginPasswordError => _valueForKey('loginPasswordError');
  String get loginPrimaryButton => _valueForKey('loginPrimaryButton');
  String get loginForgotPassword => _valueForKey('loginForgotPassword');
  String get loginSignupLink => _valueForKey('loginSignupLink');
  String get loginSuccess => _valueForKey('loginSuccess');
  String loginInvalidCredentials(int remaining) =>
      _formatWithCount('loginInvalidCredentials', remaining);
  String loginRemainingAttempts(int remaining) =>
      _formatWithCount('loginRemainingAttempts', remaining);
  String get loginAttemptsExceeded => _valueForKey('loginAttemptsExceeded');
  String get loginQuickAccessTitle => _valueForKey('loginQuickAccessTitle');
  String get loginQuickAccessVisitor => _valueForKey('loginQuickAccessVisitor');
  String get loginQuickAccessResponsible =>
      _valueForKey('loginQuickAccessResponsible');
  String get signupTitle => _valueForKey('signupTitle');
  String get signupSubtitle => _valueForKey('signupSubtitle');
  String get signupNameLabel => _valueForKey('signupNameLabel');
  String get signupNameError => _valueForKey('signupNameError');
  String get signupEmailLabel => _valueForKey('signupEmailLabel');
  String get signupEmailError => _valueForKey('signupEmailError');
  String get signupPasswordLabel => _valueForKey('signupPasswordLabel');
  String get signupPasswordError => _valueForKey('signupPasswordError');
  String get signupSubmit => _valueForKey('signupSubmit');
  String get signupSuccess => _valueForKey('signupSuccess');
  String get signupEmailExists => _valueForKey('signupEmailExists');
  String get signupRoleTitle => _valueForKey('signupRoleTitle');
  String get signupRoleVisitorTitle => _valueForKey('signupRoleVisitorTitle');
  String get signupRoleVisitorSubtitle =>
      _valueForKey('signupRoleVisitorSubtitle');
  String get signupRoleResponsibleTitle =>
      _valueForKey('signupRoleResponsibleTitle');
  String get signupRoleResponsibleSubtitle =>
      _valueForKey('signupRoleResponsibleSubtitle');
  String get drawerHome => _valueForKey('drawerHome');
  String get drawerProfile => _valueForKey('drawerProfile');
  String get drawerWallet => _valueForKey('drawerWallet');
  String get drawerCheckIn => _valueForKey('drawerCheckIn');
  String get drawerEmergency => _valueForKey('drawerEmergency');
  String get drawerChat => _valueForKey('drawerChat');
  String get drawerManageUsers => _valueForKey('drawerManageUsers');
  String get drawerManagePoints => _valueForKey('drawerManagePoints');
  String get drawerStatistics => _valueForKey('drawerStatistics');
  String get drawerDarkMode => _valueForKey('drawerDarkMode');
  String drawerLanguage(String language) =>
      _valueForKey('drawerLanguage').replaceAll('{language}', language);
  String get drawerLogout => _valueForKey('drawerLogout');
  String get drawerLogoutTitle => _valueForKey('drawerLogoutTitle');
  String get drawerLogoutMessage => _valueForKey('drawerLogoutMessage');
  String get drawerCancel => _valueForKey('drawerCancel');
  String get drawerConfirm => _valueForKey('drawerConfirm');
  String get dialogSelectLanguageTitle =>
      _valueForKey('dialogSelectLanguageTitle');
  String get roleAdmin => _valueForKey('roleAdmin');
  String get roleUser => _valueForKey('roleUser');
  String get drawerSettingsHint => _valueForKey('drawerSettingsHint');
  String drawerGreeting(String name) =>
      _valueForKey('drawerGreeting').replaceAll('{name}', name);
  String get chatPlaceholder => _valueForKey('chatPlaceholder');
  String get chatSendError => _valueForKey('chatSendError');
  String get chatStatusSending => _valueForKey('chatStatusSending');
  String get chatStatusDelivered => _valueForKey('chatStatusDelivered');
  String get chatStatusError => _valueForKey('chatStatusError');
  String get chatActionRetry => _valueForKey('chatActionRetry');
  String get homeRefreshTooltip => _valueForKey('homeRefreshTooltip');
  String get homeBalanceLabel => _valueForKey('homeBalanceLabel');
  String get homeAmaCoinsLabel => _valueForKey('homeAmaCoinsLabel');
  String get homeAgendaOfflineFallback =>
      _valueForKey('homeAgendaOfflineFallback');
  String get homeAgendaLoadError => _valueForKey('homeAgendaLoadError');
  String get homeAgendaRetryHint => _valueForKey('homeAgendaRetryHint');
  String get homeAgendaOfficialCardTitle =>
      _valueForKey('homeAgendaOfficialCardTitle');
  String get homeAgendaOfficialCardSubtitle =>
      _valueForKey('homeAgendaOfficialCardSubtitle');
  String get copDetailsTitle => _valueForKey('copDetailsTitle');
  String get copDetailsSubtitle => _valueForKey('copDetailsSubtitle');
  String get copDetailsIntro => _valueForKey('copDetailsIntro');
  String get copDetailsSectionTitle =>
      _valueForKey('copDetailsSectionTitle');
  String get saboresTitle => _valueForKey('saboresTitle');
  String get saboresSubtitle => _valueForKey('saboresSubtitle');
  String get saboresIntro => _valueForKey('saboresIntro');
  String get saboresSectionTitle => _valueForKey('saboresSectionTitle');
  String get saboresCardSubtitle => _valueForKey('saboresCardSubtitle');
  String get saboresViewGoogle => _valueForKey('saboresViewGoogle');
  String get errorRedirectHint => _valueForKey('errorRedirectHint');
  String get errorGoHome => _valueForKey('errorGoHome');
  String get checkinAlreadyRegistered =>
      _valueForKey('checkinAlreadyRegistered');
  String get checkinQueuedMessage => _valueForKey('checkinQueuedMessage');
  String get checkinMapTitle => _valueForKey('checkinMapTitle');
  String get checkinMapSubtitle => _valueForKey('checkinMapSubtitle');
  String get checkinCaptureButton => _valueForKey('checkinCaptureButton');
  String get checkinQrUnavailable => _valueForKey('checkinQrUnavailable');
  String get checkinQrSuccess => _valueForKey('checkinQrSuccess');
  String get checkinQrInvalid => _valueForKey('checkinQrInvalid');
  String get checkinOpenMaps => _valueForKey('checkinOpenMaps');
  String get checkinOpenMapsError => _valueForKey('checkinOpenMapsError');
  String get homeWeatherTitle => _valueForKey('homeWeatherTitle');
  String homeWeatherUpdated(String time) =>
      _valueForKey('homeWeatherUpdated').replaceAll('{time}', time);
  String homeWeatherRange(String max, String min) =>
      _valueForKey('homeWeatherRange')
          .replaceAll('{max}', max)
          .replaceAll('{min}', min);
  String get homeWeatherFallback => _valueForKey('homeWeatherFallback');
  String get homeWeatherLoading => _valueForKey('homeWeatherLoading');
  String get homeWeatherError => _valueForKey('homeWeatherError');
  String get homeWeatherRetry => _valueForKey('homeWeatherRetry');
  String get homeWeatherConditionSunny =>
      _valueForKey('homeWeatherConditionSunny');
  String get homeWeatherConditionCloudy =>
      _valueForKey('homeWeatherConditionCloudy');
  String get homeWeatherConditionRain =>
      _valueForKey('homeWeatherConditionRain');
  String get languageChangeError => _valueForKey('languageChangeError');
  String get sliderViewMore => _valueForKey('sliderViewMore');
  String get emergencyCallError => _valueForKey('emergencyCallError');

  String _valueForKey(String key) {
    final tag = locale.toLanguageTag();
    final language = locale.languageCode;
    if (_localizedValues.containsKey(tag) &&
        _localizedValues[tag]!.containsKey(key)) {
      return _localizedValues[tag]![key]!;
    }
    if (_localizedValues.containsKey(language) &&
        _localizedValues[language]!.containsKey(key)) {
      return _localizedValues[language]![key]!;
    }
    return _en[key] ?? key;
  }

  String _formatWithCount(String key, int count) =>
      _valueForKey(key).replaceAll('{count}', count.toString());
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .map((l) => l.languageCode)
      .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    Intl.defaultLocale = locale.toString();
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

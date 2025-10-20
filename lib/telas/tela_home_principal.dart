import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../models/ponto_turistico.dart';
import '../services/analytics_service.dart';
import '../services/checkin_queue_service.dart';
import '../services/weather_service.dart';
import '../utils/app_state.dart';
import '../widgets/sidebar_drawer.dart';
import '../data/cop30_events.dart';

class TelaHomePrincipal extends StatefulWidget {
  const TelaHomePrincipal({super.key});

  @override
  State<TelaHomePrincipal> createState() => _TelaHomePrincipalState();
}

class _TelaHomePrincipalState extends State<TelaHomePrincipal> {
  final List<PontoTuristico> _pontosTuristicos = [
    PontoTuristico(
      nome: 'Mercado Ver-o-Peso',
      descricao: 'O mercado a céu aberto mais famoso da Amazônia, cheio de aromas e sabores locais.',
      endereco: 'Blvd. Castilhos França - Campina',
      latitude: -1.4558,
      longitude: -48.5044,
    ),
    PontoTuristico(
      nome: 'Mangal das Garças',
      descricao: 'Parque ecológico com mirantes, lagos e exuberante fauna amazônica.',
      endereco: 'R. Carneiro da Rocha - Cidade Velha',
      latitude: -1.4576,
      longitude: -48.5041,
    ),
    PontoTuristico(
      nome: 'Estação das Docas',
      descricao: 'Complexo turístico e gastronômico à beira do Guamá, ideal para o pôr do sol.',
      endereco: 'Av. Mal. Hermes - Campina',
      latitude: -1.4513,
      longitude: -48.5035,
    ),
    PontoTuristico(
      nome: 'Forte do Presépio',
      descricao: 'Berço histórico de Belém, com vista para o rio e museu sobre a colonização.',
      endereco: 'Praça Dom Frei Caetano Brandão - Cidade Velha',
      latitude: -1.4524,
      longitude: -48.5032,
    ),
    PontoTuristico(
      nome: 'Basílica de Nazaré',
      descricao: 'Santuário do Círio de Nazaré, com arquitetura marcante e muita fé.',
      endereco: 'Praça Justo Chermont - Nazaré',
      latitude: -1.4525,
      longitude: -48.4902,
    ),
    PontoTuristico(
      nome: 'Parque da Residência',
      descricao: 'Espaço urbano com jardins, feiras e cultura em pleno centro.',
      endereco: 'Av. Magalhães Barata - Nazaré',
      latitude: -1.4492,
      longitude: -48.4825,
    ),
    PontoTuristico(
      nome: 'Museu Paraense Emílio Goeldi',
      descricao: 'Instituição centenária com coleções botânicas, zoológicas e antropológicas.',
      endereco: 'Av. Magalhães Barata, 376 - São Brás',
      latitude: -1.4561,
      longitude: -48.4906,
    ),
    PontoTuristico(
      nome: 'Complexo Feliz Lusitânia',
      descricao: 'Conjunto histórico com museus, praças e vista privilegiada do rio.',
      endereco: 'Praça Frei Caetano Brandão - Cidade Velha',
      latitude: -1.4523,
      longitude: -48.5037,
    ),
    PontoTuristico(
      nome: 'Ilha do Combu',
      descricao: 'Experiência ribeirinha a poucos minutos de Belém, com chocolates e trilhas.',
      endereco: 'Rio Guamá - acesso por barco',
      latitude: -1.4925,
      longitude: -48.4762,
    ),
    PontoTuristico(
      nome: 'Orla de Icoaraci',
      descricao: 'Passeio à beira-rio, artesanato em cerâmica marajoara e gastronomia típica.',
      endereco: 'Orla da Av. Lopo de Castro - Icoaraci',
      latitude: -1.3104,
      longitude: -48.4832,
    ),
  ];

  final List<_HistoriaSlider> _sliderNarrativas = [
    _HistoriaSlider(
      titulo: 'Belém: Porta da Amazônia',
      descricao: 'Fundada em 1616, Belém conecta culturas indígenas, ribeirinhas e coloniais.',
      action: SliderAction.historiaBelem,
    ),
    _HistoriaSlider(
      titulo: 'Sabores e Aromas',
      descricao: 'Do tacacá ao açaí, a culinária paraense celebra ingredientes amazônicos.',
      action: SliderAction.sabores,
    ),
    _HistoriaSlider(
      titulo: 'COP30 na Amazônia',
      descricao: 'A cidade receberá lideranças globais para pactos climáticos históricos.',
      action: SliderAction.cop30,
    ),
  ];

  final List<_AdminAction> _acoesAdmin = [
    _AdminAction(
      titulo: 'Gerenciar Usuários',
      descricao: 'Controle convites, papéis e acesso dos participantes.',
      icon: Icons.group,
      rota: '/admin/usuarios',
    ),
    _AdminAction(
      titulo: 'Gerenciar Pontos Turísticos',
      descricao: 'Atualize cards, rotas e experiências sustentáveis.',
      icon: Icons.place_outlined,
      rota: '/admin/pontos',
    ),
    _AdminAction(
      titulo: 'Estatísticas',
      descricao: 'Acompanhe engajamento, check-ins e Amacoins em tempo real.',
      icon: Icons.pie_chart_outline_rounded,
      rota: '/admin/estatisticas',
    ),
  ];

  WeatherSnapshot? _climaAtual;
  bool _carregandoClima = true;
  bool _erroClima = false;

  late final PageController _sliderController;
  Timer? _sliderTimer;
  int _slideIndex = 0;

  @override
  void initState() {
    super.initState();
    _sliderController = PageController(viewportFraction: 0.9);
    _startAutoSlide();
    _carregarClima();
    unawaited(CheckinQueueService.instance.sincronizarPendentes());
    AnalyticsService.instance.logScreenView('home');
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _sliderController.dispose();
    super.dispose();
  }

  Future<void> _carregarClima() async {
    setState(() {
      _carregandoClima = true;
      _erroClima = false;
    });
    try {
      final snapshot = await WeatherService.instance.obterClimaAtual();
      if (!mounted) return;
      setState(() => _climaAtual = snapshot);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erroClima = true);
    } finally {
      if (mounted) setState(() => _carregandoClima = false);
    }
  }

  Future<void> _atualizarHome() async {
    await Future.wait([
      _carregarClima(),
    ]);
  }

  void _startAutoSlide() {
    _sliderTimer?.cancel();
    _sliderTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!_sliderController.hasClients || _sliderNarrativas.isEmpty) return;
      final nextPage = (_slideIndex + 1) % _sliderNarrativas.length;
      _sliderController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _abrirCheckin(Map<String, dynamic> evento) {
    Navigator.pushNamed(context, '/checkin', arguments: evento);
  }

  Future<void> _abrirLink(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AppState.usuarioLogado;
    if (usuario == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          AppLocalizations.of(context).appTitle,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).homeRefreshTooltip,
            onPressed: _carregandoClima ? null : _atualizarHome,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: const SidebarDrawer(),
      body: RefreshIndicator(
        color: Colors.green.shade700,
        onRefresh: _atualizarHome,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _buildWeatherCard(context),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildHeroSection(usuario.nome, usuario.amacoins),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              sliver: SliverToBoxAdapter(
                child: _buildSectionHeader(
                  titulo: 'Descubra Belém',
                  subtitulo: 'Roteiros sustentáveis e experiências únicas',
                  icon: Icons.explore,
                ),
              ),
            ),
            _buildZonaPontosTuristicos(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              sliver: SliverToBoxAdapter(
                child: _buildSectionHeader(
                  titulo: 'Histórias da Cidade',
                  subtitulo: 'Conecte-se com a cultura paraense',
                  icon: Icons.auto_stories_outlined,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSliderHistorias(),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              sliver: SliverToBoxAdapter(
                child: _buildSectionHeader(
                  titulo: 'Agenda COP30',
                  subtitulo: 'Programe seus check-ins oficiais',
                  icon: Icons.event,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildAgendaCOP(),
              ),
            ),
            if (usuario.isAdministrador)
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                sliver: SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    titulo: 'Painel Administrativo',
                    subtitulo: 'Ferramentas rápidas para a COP30',
                    icon: Icons.admin_panel_settings_outlined,
                  ),
                ),
              ),
            if (usuario.isAdministrador)
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                sliver: SliverToBoxAdapter(child: _buildAdminActions()),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(String nome, int amacoins) {
    final primeiroNome = nome.split(' ').first;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF005B2F), const Color(0xFF004626)]
              : [Colors.green.shade700, Colors.green.shade500],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(
              Icons.eco_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo, $primeiroNome',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore a Amazônia, participe da COP30 e ganhe recompensas sustentáveis.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.25)
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.monetization_on,
                    color: isDark ? Colors.white : Colors.white),
                Text(
                  '$amacoins',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'AmaCoins',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String titulo,
    required String subtitulo,
    required IconData icon,
  }) =>
      Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.green.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitulo,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildZonaPontosTuristicos() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final ponto = _pontosTuristicos[index];
            return _buildPontoCard(ponto);
          },
          childCount: _pontosTuristicos.length,
        ),
      ),
    );
  }

  Widget _buildPontoCard(PontoTuristico ponto) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          boxShadow: Theme.of(context).brightness == Brightness.dark
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.landscape,
                      color: Color(0xFF0B7A4B),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ponto.nome,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ponto.endereco,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? 0.8
                                            : 0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                ponto.descricao,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildAcaoChip(
                    label: 'Uber',
                    icon: Icons.directions_car_filled,
                    color: Colors.black87,
                    onTap: () {
                      AnalyticsService.instance.logEvent(
                        'tour_card_click',
                        properties: {
                          'acao': 'uber',
                          'local': ponto.nome,
                        },
                      );
                      _abrirLink(ponto.linkUber);
                    },
                  ),
                  _buildAcaoChip(
                    label: '99 Pop',
                    icon: Icons.local_taxi,
                    color: Colors.amber.shade800,
                    onTap: () {
                      AnalyticsService.instance.logEvent(
                        'tour_card_click',
                        properties: {
                          'acao': '99',
                          'local': ponto.nome,
                        },
                      );
                      _abrirLink(ponto.link99);
                    },
                  ),
                  _buildAcaoChip(
                    label: 'Google',
                    icon: Icons.search,
                    color: Colors.blue.shade600,
                    onTap: () {
                      AnalyticsService.instance.logEvent(
                        'tour_card_click',
                        properties: {
                          'acao': 'google',
                          'local': ponto.nome,
                        },
                      );
                      _abrirLink(ponto.linkGoogle);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildAcaoChip({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) =>
      InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Theme.of(context).brightness == Brightness.dark
                ? color.withOpacity(0.15)
                : color.withOpacity(0.08),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? color.withOpacity(0.25)
                  : color.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildWeatherCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    if (_carregandoClima) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: _weatherDecoration(theme),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                l10n.homeWeatherLoading,
                style: TextStyle(
                  color: isDark
                      ? theme.colorScheme.onSurface.withOpacity(0.9)
                      : Colors.green.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_erroClima && _climaAtual == null) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: _weatherDecoration(theme, error: true),
        child: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.red.shade400),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.homeWeatherError,
                style: TextStyle(
                  color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: _carregarClima,
              child: Text(l10n.homeWeatherRetry),
            ),
          ],
        ),
      );
    }

    final snapshot = _climaAtual;
    if (snapshot == null) {
      return const SizedBox.shrink();
    }

    final locale = Localizations.localeOf(context);
    final horaAtual =
        DateFormat.Hm(locale.toLanguageTag()).format(snapshot.generatedAt);
    final atualizado = l10n.homeWeatherUpdated(horaAtual);
    final condicao = _weatherConditionLabel(l10n, snapshot.conditionCode);
    final icone = _weatherConditionIcon(snapshot.conditionCode);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _weatherDecoration(theme, error: _erroClima),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icone,
              color: primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeWeatherTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? Colors.white
                        : Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${snapshot.temperatureC.toStringAsFixed(1)}°C • $condicao',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : Colors.green.shade800,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.homeWeatherRange(
                    snapshot.maxC.toStringAsFixed(0),
                    snapshot.minC.toStringAsFixed(0),
                  ),
                  style: TextStyle(
                    color: isDark
                        ? Colors.white60
                        : Colors.green.shade700,
                    fontSize: 12,
                  ),
                ),
                if (_erroClima)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      l10n.homeWeatherFallback,
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            atualizado,
            style: TextStyle(
              color: isDark
                  ? Colors.white60
                  : Colors.green.shade700,
              fontSize: 11,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  BoxDecoration _weatherDecoration(ThemeData theme, {bool error = false}) {
    final isDark = theme.brightness == Brightness.dark;
    final colors = error
        ? [const Color(0x55FF6F61), theme.cardColor]
        : isDark
            ? [const Color(0xFF1C1F1D), theme.cardColor]
            : [Colors.green.shade50, Colors.white];

    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.45)
              : Colors.black.withOpacity(0.05),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  String _weatherConditionLabel(AppLocalizations l10n, String code) {
    switch (code) {
      case 'sunny':
        return l10n.homeWeatherConditionSunny;
      case 'rain':
        return l10n.homeWeatherConditionRain;
      default:
        return l10n.homeWeatherConditionCloudy;
    }
  }

  IconData _weatherConditionIcon(String code) {
    switch (code) {
      case 'sunny':
        return Icons.wb_sunny_rounded;
      case 'rain':
        return Icons.umbrella;
      default:
        return Icons.cloud_queue;
    }
  }

  Future<void> _handleSliderAction(SliderAction action) async {
    switch (action) {
      case SliderAction.historiaBelem:
        final uri = Uri.parse(
            'https://www.google.com/search?q=${Uri.encodeComponent('história da cidade de Belém do Pará')}');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        break;
      case SliderAction.sabores:
        if (!mounted) return;
        Navigator.pushNamed(context, '/sabores');
        break;
      case SliderAction.cop30:
        if (!mounted) return;
        Navigator.pushNamed(context, '/cop30');
        break;
    }
  }

  Widget _buildSliderHistorias() => SizedBox(
        height: 220,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _sliderController,
                onPageChanged: (index) {
                  setState(() => _slideIndex = index);
                },
                itemCount: _sliderNarrativas.length,
                itemBuilder: (context, index) {
                  final item = _sliderNarrativas[index];
                  return AnimatedBuilder(
                    animation: _sliderController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_sliderController.position.haveDimensions) {
                        value = (_sliderController.page ?? index).toDouble();
                        value = (1 - (value - index).abs()).clamp(0.85, 1.0);
                      }
                      return Center(
                        child: SizedBox(
                          height: Curves.easeOut.transform(value) * 200,
                          child: child,
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? [
                                      const Color(0xFF0F4330),
                                      const Color(0xFF083123),
                                    ]
                                  : [
                                      Colors.green.shade600,
                                      Colors.green.shade400,
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade200.withOpacity(0.45),
                                blurRadius: 20,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.titulo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.descricao,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 24,
                          child: FilledButton.tonalIcon(
                            onPressed: () => _handleSliderAction(item.action),
                            icon: const Icon(Icons.arrow_forward),
                            label: Text(AppLocalizations.of(context).sliderViewMore),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _sliderNarrativas.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _slideIndex == index ? 28 : 12,
                  decoration: BoxDecoration(
                    color: _slideIndex == index
                        ? Colors.green.shade700
                        : Colors.green.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildAgendaCOP() {
    final l10n = AppLocalizations.of(context);
    final events = cop30OficialEvents;
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.event_available,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.homeAgendaOfficialCardTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.homeAgendaOfficialCardSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color
                      ?.withOpacity(isDark ? 0.75 : 0.7),
                ),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.schedule,
                            color: theme.colorScheme.primary),
                      ),
                      title: Text(
                        event.nome,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            event.horario,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(isDark ? 0.9 : 0.75),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            event.local,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(isDark ? 0.8 : 0.65),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => Divider(
                    height: 16,
                    color: theme.dividerColor.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminActions() => Column(
        children: _acoesAdmin
            .map(
              (acao) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(acao.icon, color: Colors.green.shade700),
                  ),
                  title: Text(
                    acao.titulo,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    acao.descricao,
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, acao.rota),
                ),
              ),
            )
            .toList(),
      );
}

enum SliderAction { historiaBelem, sabores, cop30 }

class _HistoriaSlider {
  const _HistoriaSlider({
    required this.titulo,
    required this.descricao,
    required this.action,
  });

  final String titulo;
  final String descricao;
  final SliderAction action;
}

class _AdminAction {
  const _AdminAction({
    required this.titulo,
    required this.descricao,
    required this.icon,
    required this.rota,
  });

  final String titulo;
  final String descricao;
  final IconData icon;
  final String rota;
}

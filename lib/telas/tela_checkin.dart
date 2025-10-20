// telas/tela_checkin.dart - Tela de check-in
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/l10n.dart';
import '../services/wallet_service.dart';
import '../utils/app_state.dart';
import '../services/analytics_service.dart';
import '../services/checkin_queue_service.dart';

class TelaCheckin extends StatefulWidget {
  const TelaCheckin({super.key});

  @override
  State<TelaCheckin> createState() => _TelaCheckinState();
}

class _CheckinLocation {
  const _CheckinLocation({
    required this.nome,
    required this.descricao,
    required this.coordenadas,
    required this.icon,
    required this.mapsQuery,
  });

  final String nome;
  final String descricao;
  final LatLng coordenadas;
  final IconData icon;
  final String mapsQuery;
}

class _TelaCheckinState extends State<TelaCheckin> {
  Map<String, dynamic>? _eventoSelecionado;
  bool _carregando = false;
  bool _checkinRealizado = false;
  bool _screenLogged = false;
  final MapController _mapController = MapController();
  final List<_CheckinLocation> _locais = const [
    _CheckinLocation(
      nome: 'Hangar Centro de Convenções',
      descricao: 'Ponto principal dos painéis oficiais da COP 30.',
      coordenadas: LatLng(-1.3884, -48.4689),
      icon: Icons.business_center,
      mapsQuery: 'Hangar Centro de Convenções da Amazônia',
    ),
    _CheckinLocation(
      nome: 'Estação das Docas',
      descricao: 'Área cultural com shows e experiências gastronômicas.',
      coordenadas: LatLng(-1.4513, -48.5035),
      icon: Icons.festival,
      mapsQuery: 'Estação das Docas Belém',
    ),
    _CheckinLocation(
      nome: 'Praça da República',
      descricao: 'Espaço aberto para encontro de delegações e manifestações culturais.',
      coordenadas: LatLng(-1.4554, -48.5032),
      icon: Icons.park,
      mapsQuery: 'Praça da República Belém',
    ),
    _CheckinLocation(
      nome: 'Mangal das Garças',
      descricao: 'Área verde com programação de sustentabilidade e oficinas.',
      coordenadas: LatLng(-1.4576, -48.5041),
      icon: Icons.nature_people,
      mapsQuery: 'Mangal das Garças Belém',
    ),
    _CheckinLocation(
      nome: 'Ver-o-Peso',
      descricao: 'Mercado e polo gastronômico da experiência amazônica.',
      coordenadas: LatLng(-1.4517, -48.5045),
      icon: Icons.storefront,
      mapsQuery: 'Ver-o-Peso',
    ),
    _CheckinLocation(
      nome: 'Casa das Onze Janelas',
      descricao: 'Painéis culturais e exposições de arte amazônica.',
      coordenadas: LatLng(-1.4548, -48.5046),
      icon: Icons.museum,
      mapsQuery: 'Casa das Onze Janelas',
    ),
    _CheckinLocation(
      nome: 'Universidade Federal do Pará',
      descricao: 'Campus com hackathons climáticos e fóruns acadêmicos.',
      coordenadas: LatLng(-1.4751, -48.4528),
      icon: Icons.school,
      mapsQuery: 'Universidade Federal do Pará campus Belém',
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receber evento passado como argumento
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _eventoSelecionado = args;
    }
    if (!_screenLogged) {
      AnalyticsService.instance.logScreenView('checkin');
      _screenLogged = true;
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  bool get _eventoEstaAtivo {
    if (_eventoSelecionado == null) return false;
    
    final dataInicio = DateTime.parse(_eventoSelecionado!['data_inicio']);
    final dataFim = DateTime.parse(_eventoSelecionado!['data_fim']);
    final agora = DateTime.now();
    
    return agora.isAfter(dataInicio) && agora.isBefore(dataFim);
  }

  Future<void> _realizarCheckin() async {
    final usuarioId = AppState.usuarioLogado?.id;
    if (_eventoSelecionado == null || usuarioId == null) return;

    final l10n = AppLocalizations.of(context);
    setState(() => _carregando = true);

    try {
      AnalyticsService.instance.logEvent(
        'checkin_scan_start',
        properties: {
          'local_id': _eventoSelecionado!['id'],
        },
      );
      final valorAmacoins =
          (_eventoSelecionado!['amacoins'] as num?)?.toInt() ?? 0;

      final rawId = _eventoSelecionado!['id'];
      var eventoId = rawId == null ? '' : rawId.toString();
      if (eventoId.isEmpty) {
        final titulo = (_eventoSelecionado!['titulo'] ?? '').toString();
        if (titulo.isNotEmpty) {
          eventoId = titulo.toLowerCase().replaceAll(' ', '_');
        } else {
          eventoId =
              'evento_${DateTime.now().millisecondsSinceEpoch.toString()}';
        }
      }

      final status = await CheckinQueueService.instance.registrarCheckin(
        usuarioId: usuarioId,
        eventoId: eventoId,
        eventoTitulo: (_eventoSelecionado!['titulo'] ?? '').toString(),
        local: (_eventoSelecionado!['endereco'] ?? '').toString(),
        amacoins: valorAmacoins,
      );

      if (status == CheckinStatus.duplicate) {
        AnalyticsService.instance.logEvent(
          'checkin_scan_error',
          properties: {
            'motivo': 'duplicado',
            'local_id': eventoId,
          },
        );
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.checkinAlreadyRegistered),
              ),
            );
        }
        setState(() => _carregando = false);
        return;
      }

      if (status == CheckinStatus.failure) {
        throw Exception('Falha ao registrar check-in');
      }

      // Atualizar usuário local e carteira (modo offline-first).
      AppState.usuarioLogado!.amacoins += valorAmacoins;
      await AppState.atualizarUsuario(AppState.usuarioLogado!);

      if (valorAmacoins > 0) {
        await WalletService.instance.registrarCredito(
          userId: usuarioId,
          descricao: 'Check-in em ${_eventoSelecionado!['titulo']}',
          valor: valorAmacoins,
          contexto: {
            'local': _eventoSelecionado!['endereco'],
            'eventoId': eventoId,
            'sincronizado': status == CheckinStatus.synced,
          },
        );
      }

      AnalyticsService.instance.logEvent(
        'checkin_scan_success',
        properties: {
          'amacoins_creditados': valorAmacoins,
          'local_id': eventoId,
          'modo_offline': status == CheckinStatus.queued,
        },
      );

      setState(() {
        _carregando = false;
        _checkinRealizado = true;
      });

      if (mounted && status == CheckinStatus.queued) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                l10n.checkinQueuedMessage,
              ),
            ),
          );
      }

    } catch (e) {
      setState(() => _carregando = false);
      AnalyticsService.instance.logEvent(
        'checkin_scan_error',
        properties: {
          'local_id': _eventoSelecionado?['id'],
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao realizar check-in'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _capturarQrCode() async {
    final l10n = AppLocalizations.of(context);
    if (kIsWeb) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.checkinQrUnavailable)),
        );
      return;
    }

    final codigo = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Stack(
            children: [
              MobileScanner(
                onDetect: (capture) {
                  final value = capture.barcodes.first.rawValue;
                  if (value != null && value.isNotEmpty) {
                    Navigator.of(context).pop(value);
                  }
                },
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || codigo == null) return;
    await _processarQrCode(codigo);
  }

  Future<void> _processarQrCode(String codigo) async {
    final usuarioId = AppState.usuarioLogado?.id;
    if (usuarioId == null) return;

    if (codigo.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).checkinQrInvalid),
            backgroundColor: Colors.red.shade600,
          ),
        );
      return;
    }

    const valorAmacoins = 30;
    final status = await CheckinQueueService.instance.registrarCheckin(
      usuarioId: usuarioId,
      eventoId: codigo,
      eventoTitulo: 'Check-in QR',
      local: 'Mapa interativo',
      amacoins: valorAmacoins,
    );

    if (status == CheckinStatus.duplicate) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).checkinAlreadyRegistered)),
        );
      return;
    }

    AppState.usuarioLogado!.amacoins += valorAmacoins;
    await AppState.atualizarUsuario(AppState.usuarioLogado!);

    await WalletService.instance.registrarCredito(
      userId: usuarioId,
      descricao: 'Check-in QR Interativo',
      valor: valorAmacoins,
      contexto: {
        'local': 'mapa_interativo',
        'qr': codigo,
        'sincronizado': status == CheckinStatus.synced,
      },
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).checkinQrSuccess,
          ),
          backgroundColor: Colors.green.shade600,
        ),
      );
  }

  void _mostrarLocalDetalhes(_CheckinLocation local) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              local.nome,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              local.descricao,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _abrirNoMaps(local.mapsQuery),
                icon: const Icon(Icons.map_outlined),
                label: Text(AppLocalizations.of(context).checkinOpenMaps),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _abrirNoMaps(String query) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).checkinOpenMapsError)),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          title: const Text('Check-in'),
          elevation: 0,
        ),
        body: _eventoSelecionado == null
            ? _buildSemEventoSelecionado()
            : Stack(
                children: [
                  _checkinRealizado
                      ? _buildCheckinSucesso()
                      : _buildTelaCheckin(),
                  if (_carregando) _buildLoaderOverlay(),
                ],
              ),
      );

  Widget _buildSemEventoSelecionado() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 320,
              child: FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(-1.4558, -48.5039),
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.amazoniasustentavel.app',
                  ),
                  MarkerLayer(
                    markers: _locais
                        .map(
                          (local) => Marker(
                            point: local.coordenadas,
                            width: 48,
                            height: 48,
                            child: GestureDetector(
                              onTap: () => _mostrarLocalDetalhes(local),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  local.icon,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.checkinMapTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.checkinMapSubtitle,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _capturarQrCode,
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(l10n.checkinCaptureButton),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelaCheckin() => Column(
      children: [
        // Header do evento
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade600, Colors.green.shade800],
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.location_on,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                _eventoSelecionado!['titulo'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _eventoSelecionado!['endereco'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Recompensa disponível:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 32,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_eventoSelecionado!['amacoins']}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AmaCoins',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _eventoSelecionado!['descricao'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _eventoEstaAtivo && !_carregando 
                        ? _realizarCheckin 
                        : null,
                    icon: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle, size: 24),
                    label: Text(
                      _carregando 
                          ? 'Processando...' 
                          : _eventoEstaAtivo 
                              ? 'Fazer Check-in'
                              : 'Evento não disponível',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _eventoEstaAtivo 
                          ? Colors.green.shade600 
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                if (!_eventoEstaAtivo)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Este evento ainda não começou ou já terminou',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );

  Widget _buildCheckinSucesso() => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Check-in realizado!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Você ganhou ${_eventoSelecionado!['amacoins']} AmaCoins!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Obrigado por visitar "${_eventoSelecionado!['titulo']}"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _buildLoaderOverlay() => Positioned.fill(
        child: ColoredBox(
          color: Colors.black.withOpacity(0.25),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}

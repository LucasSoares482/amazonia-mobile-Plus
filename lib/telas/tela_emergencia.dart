import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../services/analytics_service.dart';
import '../utils/responsive.dart';

class TelaEmergencia extends StatefulWidget {
  const TelaEmergencia({super.key});

  @override
  State<TelaEmergencia> createState() => _TelaEmergenciaState();
}

class _TelaEmergenciaState extends State<TelaEmergencia> {
  final Map<String, List<_EmergencyContact>> _contactsByCategory = {
    'Socorro': [
      _EmergencyContact(
        nome: 'Polícia Militar',
        telefone: '190',
        descricao: 'Ações emergenciais e patrulhamento urbano.',
      ),
      _EmergencyContact(
        nome: 'Bombeiros',
        telefone: '193',
        descricao: 'Incêndios, resgates e salvamentos aquáticos.',
      ),
      _EmergencyContact(
        nome: 'SAMU',
        telefone: '192',
        descricao: 'Atendimento pré-hospitalar móvel 24h.',
      ),
      _EmergencyContact(
        nome: 'Defesa Civil Belém',
        telefone: '199',
        descricao: 'Centrais de proteção e resposta a desastres.',
      ),
      _EmergencyContact(
        nome: 'Polícia Turística',
        telefone: '+55 91 3222-5000',
        descricao: 'Suporte especial ao visitante e delegações.',
      ),
    ],
    'Saúde': [
      _EmergencyContact(
        nome: 'Hospital Metropolitano de Belém',
        telefone: '+55 91 3344-2000',
        descricao: 'Centro de trauma e referência em urgências.',
      ),
      _EmergencyContact(
        nome: 'UPA Cidade Nova',
        telefone: '+55 91 3412-7700',
        descricao: 'Unidade de pronto atendimento 24h.',
      ),
      _EmergencyContact(
        nome: 'Hospital Porto Dias',
        telefone: '+55 91 3084-3000',
        descricao: 'Referência cardiológica e cirúrgica.',
      ),
      _EmergencyContact(
        nome: 'Hospital Universitário Bettina',
        telefone: '+55 91 3201-7700',
        descricao: 'Atendimento materno-infantil e ambulatórios.',
      ),
    ],
    'Embaixadas': [
      _EmergencyContact(
        nome: 'Embaixada do Brasil (Plantão)',
        telefone: '+55 61 2030-8800',
        descricao: 'Contatos oficiais para documentação.',
      ),
      _EmergencyContact(
        nome: 'Embaixada dos EUA',
        telefone: '+55 61 3312-7000',
        descricao: 'Assistência a cidadãos estadunidenses.',
      ),
      _EmergencyContact(
        nome: 'Embaixada de Portugal',
        telefone: '+55 61 3032-9600',
        descricao: 'Apoio consular para portugueses e CPLP.',
      ),
      _EmergencyContact(
        nome: 'Embaixada do Reino Unido',
        telefone: '+55 61 3226-3111',
        descricao: 'Emergências e suporte a delegações britânicas.',
      ),
      _EmergencyContact(
        nome: 'Embaixada da França',
        telefone: '+55 61 3224-3100',
        descricao: 'Rede consular francesa no Brasil.',
      ),
    ],
    'Delegacias Especializadas': [
      _EmergencyContact(
        nome: 'Delegacia da Mulher',
        telefone: '180',
        descricao: 'Canal nacional de enfrentamento à violência.',
      ),
      _EmergencyContact(
        nome: 'Delegacia do Turista (Belém)',
        telefone: '+55 91 3242-2319',
        descricao: 'Registro de ocorrências envolvendo turistas.',
      ),
      _EmergencyContact(
        nome: 'Delegacia de Crimes Cibernéticos',
        telefone: '+55 91 3214-7800',
        descricao: 'Incidentes digitais, golpes e fraudes.',
      ),
    ],
  };

  late final List<String> _categorias;
  String _categoriaSelecionada = 'Todos';

  @override
  void initState() {
    super.initState();
    _categorias = ['Todos', ..._contactsByCategory.keys];
    AnalyticsService.instance.logScreenView('emergency');
  }

  List<_EmergencyContact> get _contatosFiltrados {
    if (_categoriaSelecionada == 'Todos') {
      return _contactsByCategory.values.expand((c) => c).toList();
    }
    return _contactsByCategory[_categoriaSelecionada] ?? [];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          title: Text(AppLocalizations.of(context).drawerEmergency),
        ),
        body: Padding(
          padding: Responsive.padding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Contatos essenciais em Belém do Pará',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Use os atalhos abaixo para ligar imediatamente. O app mantém a lista offline para situações sem rede.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
              const SizedBox(height: 16),
              _buildCategoriaSelector(),
              const SizedBox(height: 16),
              Expanded(
                child: _contatosFiltrados.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        itemCount: _contatosFiltrados.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final contato = _contatosFiltrados[index];
                          return _buildContactCard(contato);
                        },
                      ),
              ),
            ],
          ),
        ),
      );

  Widget _buildCategoriaSelector() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categorias.map((categoria) {
            final selecionada = categoria == _categoriaSelecionada;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(categoria),
                selected: selecionada,
                onSelected: (value) {
                  if (!value) return;
                  setState(() {
                    _categoriaSelecionada = categoria;
                  });
                },
                selectedColor: Colors.green.shade600,
                labelStyle: TextStyle(
                  color: selecionada ? Colors.white : Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Colors.green.shade50,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          }).toList(),
        ),
      );

  Widget _buildContactCard(_EmergencyContact contato) {
    final cor = _corPorCategoria(_categoriaDoContato(contato));
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      shadowColor: cor.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _ligar(contato),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _iconePorCategoria(_categoriaDoContato(contato)),
                  color: cor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contato.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contato.descricao,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      contato.telefone,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.call, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied,
                size: 54, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Nenhum contato encontrado para esta categoria.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );

  Future<void> _ligar(_EmergencyContact contato) async {
    final l10n = AppLocalizations.of(context);
    AnalyticsService.instance.logEvent(
      'emergency_contact_click',
      properties: {
        'tipo': _categoriaDoContato(contato),
        'contato': contato.nome,
      },
    );
    final uri = Uri(scheme: 'tel', path: contato.telefone.replaceAll(' ', ''));
    try {
      final canCall = await canLaunchUrl(uri);
      if (!canCall) {
        _showErrorSnack(l10n.emergencyCallError);
        return;
      }
      await launchUrl(uri);
    } catch (_) {
      _showErrorSnack(l10n.emergencyCallError);
    }
  }

  void _showErrorSnack(String mensagem) {
    AnalyticsService.instance.logErrorShown('emergency', 'call_failed');
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.red.shade600,
        ),
      );
  }

  String _categoriaDoContato(_EmergencyContact contato) {
    return _contactsByCategory.entries.firstWhere(
      (entry) => entry.value.contains(contato),
      orElse: () => MapEntry('Outros', []),
    ).key;
  }

  IconData _iconePorCategoria(String categoria) {
    switch (categoria) {
      case 'Socorro':
        return Icons.local_police;
      case 'Saúde':
        return Icons.local_hospital;
      case 'Embaixadas':
        return Icons.public;
      case 'Delegacias Especializadas':
        return Icons.shield_outlined;
      default:
        return Icons.support_agent;
    }
  }

  Color _corPorCategoria(String categoria) {
    switch (categoria) {
      case 'Socorro':
        return Colors.red.shade600;
      case 'Saúde':
        return Colors.teal.shade600;
      case 'Embaixadas':
        return Colors.indigo.shade600;
      case 'Delegacias Especializadas':
        return Colors.orange.shade600;
      default:
        return Colors.green.shade600;
    }
  }
}

class _EmergencyContact {
  const _EmergencyContact({
    required this.nome,
    required this.telefone,
    required this.descricao,
  });

  final String nome;
  final String telefone;
  final String descricao;
}

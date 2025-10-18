import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../services/analytics_service.dart';
import '../../services/error_service.dart';

/// Stub inicial do dashboard de estatísticas administrativas.
class TelaAdminEstatisticas extends StatefulWidget {
  const TelaAdminEstatisticas({super.key});

  @override
  State<TelaAdminEstatisticas> createState() => _TelaAdminEstatisticasState();
}

class _TelaAdminEstatisticasState extends State<TelaAdminEstatisticas> {
  List<ErrorLogEntry> _logs = [];
  bool _carregandoLogs = true;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreenView('admin_stats');
    _carregarLogs();
  }

  Future<void> _carregarLogs() async {
    final logs = await ErrorService.instance.obterLogs();
    if (!mounted) return;
    setState(() {
      _logs = logs;
      _carregandoLogs = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).drawerStatistics),
        ),
        body: RefreshIndicator(
          onRefresh: _carregarLogs,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Indicadores principais (em breve)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Estamos consolidando o dashboard completo com engajamento, check-ins e conversões. '
                'Enquanto isso, acompanhe abaixo a caixa de mensagens do sistema com falhas recentes.',
              ),
              const SizedBox(height: 24),
              Text(
                'Mensagens do sistema',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (_carregandoLogs)
                const Center(child: CircularProgressIndicator())
              else if (_logs.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Sem registros de instabilidade nas últimas sessões. Tudo funcionando normalmente!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                ..._logs.map(_buildLogCard),
            ],
          ),
        ),
      );

  Widget _buildLogCard(ErrorLogEntry entry) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.report_problem, color: Colors.red.shade400),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.origem,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    _formatarData(entry.ocorreuEm),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(entry.mensagem),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.green.shade700, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.sugestao,
                        style: TextStyle(color: Colors.green.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  String _formatarData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')} '
      '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
}

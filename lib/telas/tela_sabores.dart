import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';

class TelaSabores extends StatelessWidget {
  const TelaSabores({super.key});

  static const _pratos = [
    'Maniçoba',
    'Pato no Tucupi',
    'Tacacá',
    'Vatapá',
    'Arroz Paraense',
    'Caruru',
    'Farinha d’água',
    'Camarão no Tucupi',
    'Açaí branco',
    'Suco de Cupuaçu',
    'Suco de Taperebá',
    'Seijoada',
    'Peixe no Moquém',
    'Pirarucu de Casaca',
    'Arroz de Jambu',
    'Filhote Assado',
    'Casquinha de Caranguejo',
    'Bolo de Macaxeira',
    'Bolo de Cupuaçu',
    'Sorvete de Taperebá',
    'Sorvete de Bacuri',
    'Coxinha de Jambu',
    'Quiche de Jambu',
    'Moqueca Paraense',
    'Ensopado de Tambaqui',
    'Pirarucu Fresco',
    'Caldeirada Amazônica',
    'Chibé Amazônico',
    'Tapioca de Castanha',
    'Pudim de Açaí',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.saboresTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8BC34A), Color(0xFF558B2F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: 0.25,
                      child: Image.asset(
                        'assets/images/belem_background.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text(
                        l10n.saboresTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        l10n.saboresSubtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.saboresSectionTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.saboresIntro,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ..._pratos.map(
            (prato) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.dining),
                title: Text(prato),
                subtitle: Text(l10n.saboresCardSubtitle),
                trailing: TextButton(
                  onPressed: () => _abrirPesquisa(prato),
                  child: Text(l10n.saboresViewGoogle),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  static Future<void> _abrirPesquisa(String prato) async {
    final uri = Uri.parse(
        'https://www.google.com/search?q=${Uri.encodeComponent('$prato paraense história')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

import 'package:flutter/material.dart';

class HistoricoCard extends StatelessWidget {
  final Map<String, dynamic> checkin;
  final VoidCallback onShare;

  const HistoricoCard({
    super.key,
    required this.checkin,
    required this.onShare,
  });

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final data = DateTime.parse(checkin['data']);
    final nomeEvento = checkin['evento'] ?? checkin['local'] ?? 'Evento';
    final endereco = checkin['local'] ?? '';

    return Card(
      // Usando o CardTheme que definimos no main.dart
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, nomeEvento, endereco),
            const SizedBox(height: 12),
            _buildFooter(context, data),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.share, size: 18),
                label: const Text(
                  'Compartilhar no WhatsApp',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                // O estilo já vem do ElevatedButtonTheme
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String nomeEvento, String endereco) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade600],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nomeEvento, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (endereco.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        endereco,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, DateTime data) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          'Visitado em ${_formatarData(data)}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
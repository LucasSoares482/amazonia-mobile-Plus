import 'package:flutter/material.dart';

class EventoCard extends StatelessWidget {
  final Map<String, dynamic> evento;
  final VoidCallback onTap;

  const EventoCard({super.key, required this.evento, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dataInicio = DateTime.parse(evento['data_inicio']);
    final dataFim = DateTime.parse(evento['data_fim']);
    final agora = DateTime.now();
    final isAtivo = agora.isAfter(dataInicio) && agora.isBefore(dataFim);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(),
            _buildCardContent(isAtivo, dataInicio, dataFim),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: Colors.grey.shade200,
      ),
      child: evento['foto_path'] != null
          ? ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                evento['foto_path'],
                fit: BoxFit.cover,
              ),
            )
          : const Icon(Icons.event, size: 60, color: Colors.grey),
    );
  }

  Widget _buildCardContent(bool isAtivo, DateTime dataInicio, DateTime dataFim) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(isAtivo),
          const SizedBox(height: 8),
          Text(
            evento['descricao'],
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on, evento['endereco']),
          const SizedBox(height: 8),
          _buildDateRow(dataInicio, dataFim, isAtivo),
        ],
      ),
    );
  }

  Widget _buildCardTitle(bool isAtivo) {
    return Row(
      children: [
        Expanded(
          child: Text(
            evento['titulo'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isAtivo ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.monetization_on, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                '${evento['amacoins']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(DateTime dataInicio, DateTime dataFim, bool isAtivo) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          '${dataInicio.day}/${dataInicio.month} - ${dataFim.day}/${dataFim.month}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isAtivo ? Colors.green.shade100 : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isAtivo ? 'Ativo' : 'Em breve',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isAtivo ? Colors.green.shade800 : Colors.orange.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
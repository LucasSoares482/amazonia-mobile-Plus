// telas/tela_mapa.dart - Tela do mapa simplificada sem Google Maps
import 'package:flutter/material.dart';

/// Tela do mapa simplificado (sem dependência do Google Maps)
class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  final List<Map<String, dynamic>> _locais = [
    {
      'nome': 'Ver-o-Peso',
      'descricao': 'Mercado histórico e ponto turístico icônico',
      'endereco': 'Av. Boulevard Castilhos França - Campina, Belém',
      'icon': Icons.store,
      'cor': Colors.orange,
    },
    {
      'nome': 'Mangal das Garças',
      'descricao': 'Parque ecológico com fauna e flora amazônica',
      'endereco': 'R. Carneiro da Rocha - Cidade Velha, Belém',
      'icon': Icons.park,
      'cor': Colors.green,
    },
    {
      'nome': 'Estação das Docas',
      'descricao': 'Complexo turístico e gastronômico',
      'endereco': 'Av. Mal. Hermes - Campina, Belém',
      'icon': Icons.restaurant,
      'cor': Colors.blue,
    },
    {
      'nome': 'Teatro da Paz',
      'descricao': 'Teatro histórico do século XIX',
      'endereco': 'Praça da República - Campina, Belém',
      'icon': Icons.theater_comedy,
      'cor': Colors.purple,
    },
    {
      'nome': 'Basílica de Nazaré',
      'descricao': 'Santuário religioso do Círio de Nazaré',
      'endereco': 'Praça Santuário - Nazaré, Belém',
      'icon': Icons.church,
      'cor': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: const Text('Locais de Belém'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header informativo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade500],
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.map, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text(
                  'Explore Belém do Pará',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Descubra pontos turísticos e eventos',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Lista de locais
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _locais.length,
              itemBuilder: (context, index) {
                final local = _locais[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: local['cor'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        local['icon'],
                        size: 28,
                        color: local['cor'],
                      ),
                    ),
                    title: Text(
                      local['nome'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          local['descricao'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                local['endereco'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions,
                          size: 20,
                          color: Colors.green.shade600,
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Direções para ${local['nome']}'),
                            backgroundColor: Colors.green.shade600,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
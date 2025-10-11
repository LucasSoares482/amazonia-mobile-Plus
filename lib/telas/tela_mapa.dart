// telas/tela_mapa.dart - Mapa com flutter_map e marcação personalizada
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  late final MapController _mapController;

  final LatLng _centroInicial = const LatLng(-1.4558, -48.5044);

  final List<Map<String, dynamic>> _locais = [
    {
      'nome': 'Ver-o-Peso',
      'descricao': 'Mercado histórico e ponto turístico icônico.',
      'endereco': 'Av. Boulevard Castilhos França - Campina, Belém',
      'icon': Icons.storefront,
      'cor': Colors.orange,
      'coordenadas': const LatLng(-1.4558, -48.5044),
    },
    {
      'nome': 'Mangal das Garças',
      'descricao': 'Parque ecológico com fauna e flora amazônica.',
      'endereco': 'R. Carneiro da Rocha - Cidade Velha, Belém',
      'icon': Icons.park,
      'cor': Colors.green,
      'coordenadas': const LatLng(-1.4576, -48.5041),
    },
    {
      'nome': 'Estação das Docas',
      'descricao': 'Complexo turístico e gastronômico à beira rio.',
      'endereco': 'Av. Mal. Hermes - Campina, Belém',
      'icon': Icons.restaurant,
      'cor': Colors.blue,
      'coordenadas': const LatLng(-1.4513, -48.5035),
    },
    {
      'nome': 'Teatro da Paz',
      'descricao': 'Teatro histórico do século XIX.',
      'endereco': 'Praça da República - Campina, Belém',
      'icon': Icons.theater_comedy,
      'cor': Colors.purple,
      'coordenadas': const LatLng(-1.4552, -48.4907),
    },
    {
      'nome': 'Basílica de Nazaré',
      'descricao': 'Santuário religioso do Círio de Nazaré.',
      'endereco': 'Praça Santuário - Nazaré, Belém',
      'icon': Icons.church,
      'cor': Colors.red,
      'coordenadas': const LatLng(-1.4525, -48.4902),
    },
  ];

  final List<LatLng> _marcadoresPersonalizados = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _adicionarMarcadorPersonalizado(LatLng coordenadas) {
    setState(() => _marcadoresPersonalizados.add(coordenadas));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Marcador adicionado em '
          '${coordenadas.latitude.toStringAsFixed(4)}, '
          '${coordenadas.longitude.toStringAsFixed(4)}',
        ),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  void _mostrarDetalhesLocal(Map<String, dynamic> local) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(local['icon'], color: local['cor'], size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    local['nome'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              local['descricao'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    local['endereco'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _mapController.move(local['coordenadas'], 15);
              },
              icon: const Icon(Icons.zoom_in_map),
              label: const Text('Centralizar no mapa'),
            ),
          ],
        ),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    final marcadoresLocais = _locais.map((local) {
      final LatLng coordenadas = local['coordenadas'];
      return Marker(
        point: coordenadas,
        width: 44,
        height: 44,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => _mostrarDetalhesLocal(local),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(local['icon'], color: local['cor'], size: 20),
              ),
              Icon(Icons.arrow_drop_down, color: local['cor']),
            ],
          ),
        ),
      );
    });

    final marcadoresCustomizados = _marcadoresPersonalizados.map(
      (coordenadas) => Marker(
        point: coordenadas,
        width: 36,
        height: 36,
        alignment: Alignment.bottomCenter,
        child: const Icon(
          Icons.location_on,
          color: Colors.blueAccent,
          size: 32,
        ),
      ),
    );

    return [...marcadoresLocais, ...marcadoresCustomizados];
  }

  Widget _buildListaLocais() => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _locais.length,
        itemBuilder: (context, index) {
          final local = _locais[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: local['cor'].withOpacity(0.15),
                child: Icon(local['icon'], color: local['cor']),
              ),
              title: Text(
                local['nome'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                local['descricao'],
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.map),
                onPressed: () => _mostrarDetalhesLocal(local),
              ),
              onTap: () => _mostrarDetalhesLocal(local),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          title: const Text('Mapa de Experiências'),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade500],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.map, color: Colors.white, size: 26),
                      SizedBox(width: 8),
                      Text(
                        'Explore Belém do Pará',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Toque nos marcadores para ver detalhes e pressione e segure no mapa para criar os seus próprios pontos.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _centroInicial,
                  initialZoom: 13,
                  onLongPress: (_, coordenadas) =>
                      _adicionarMarcadorPersonalizado(coordenadas),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'mobile_amazonia',
                  ),
                  MarkerLayer(markers: _buildMarkers()),
                  const RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        '© OpenStreetMap contributors',
                        prependCopyright: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildListaLocais(),
            ),
          ],
        ),
      );
}

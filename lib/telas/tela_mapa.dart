// telas/tela_mapa.dart - Tela do mapa com Google Maps corrigida
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Tela do mapa interativo de Belém do Pará
class TelaMapa extends StatefulWidget {
  /// Construtor da tela do mapa
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  late GoogleMapController _mapController;
  
  // Coordenadas de Belém do Pará
  static const LatLng _belemCenter = LatLng(-1.4558, -48.4902);
  
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('ver-o-peso'),
      position: const LatLng(-1.4528, -48.5044),
      infoWindow: const InfoWindow(
        title: 'Ver-o-Peso',
        snippet: 'Mercado histórico e ponto turístico icônico',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: const MarkerId('mangal-das-garcas'),
      position: const LatLng(-1.4592, -48.4896),
      infoWindow: const InfoWindow(
        title: 'Mangal das Garças',
        snippet: 'Parque ecológico com fauna e flora amazônica',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: const MarkerId('estacao-das-docas'),
      position: const LatLng(-1.4521, -48.5033),
      infoWindow: const InfoWindow(
        title: 'Estação das Docas',
        snippet: 'Complexo turístico e gastronômico',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: const MarkerId('teatro-da-paz'),
      position: const LatLng(-1.4558, -48.5044),
      infoWindow: const InfoWindow(
        title: 'Teatro da Paz',
        snippet: 'Teatro histórico do século XIX',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
    Marker(
      markerId: const MarkerId('basilica-nazare'),
      position: const LatLng(-1.4505, -48.4890),
      infoWindow: const InfoWindow(
        title: 'Basílica de Nazaré',
        snippet: 'Santuário religioso do Círio de Nazaré',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _goToLocation(LatLng location) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: const Text('Mapa de Belém'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => _goToLocation(_belemCenter),
            tooltip: 'Centralizar mapa',
          ),
        ],
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
                Text(
                  '🌍 Explore Belém do Pará',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Descubra pontos turísticos e eventos próximos a você',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Mapa
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: _belemCenter,
                    zoom: 13,
                  ),
                  markers: _markers,
                  compassEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: false,
                ),
                
                // Botões de ação flutuantes
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "zoom_out",
                        mini: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green.shade600,
                        onPressed: () {
                          _mapController.animateCamera(CameraUpdate.zoomOut());
                        },
                        child: const Icon(Icons.zoom_out),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: "zoom_in",
                        mini: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green.shade600,
                        onPressed: () {
                          _mapController.animateCamera(CameraUpdate.zoomIn());
                        },
                        child: const Icon(Icons.zoom_in),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de locais em cards horizontais
          Container(
            height: 140,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildLocalCard(
                  'Ver-o-Peso',
                  'Mercado histórico',
                  Icons.store,
                  const LatLng(-1.4528, -48.5044),
                ),
                _buildLocalCard(
                  'Mangal das Garças',
                  'Parque ecológico',
                  Icons.park,
                  const LatLng(-1.4592, -48.4896),
                ),
                _buildLocalCard(
                  'Estação das Docas',
                  'Complexo turístico',
                  Icons.restaurant,
                  const LatLng(-1.4521, -48.5033),
                ),
                _buildLocalCard(
                  'Teatro da Paz',
                  'Teatro histórico',
                  Icons.theater_comedy,
                  const LatLng(-1.4558, -48.5044),
                ),
                _buildLocalCard(
                  'Basílica de Nazaré',
                  'Santuário religioso',
                  Icons.church,
                  const LatLng(-1.4505, -48.4890),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalCard(
    String nome,
    String descricao,
    IconData icon,
    LatLng location,
  ) => Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _goToLocation(location),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: Colors.green.shade600,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.navigation,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  descricao,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
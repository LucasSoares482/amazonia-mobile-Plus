import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({Key? key}) : super(key: key);

  @override
  _TelaMapaState createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  late GoogleMapController _mapController;

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('ver-o-peso'),
      position: LatLng(-1.4528, -48.5044),
      infoWindow: InfoWindow(
        title: 'Ver-o-Peso',
        snippet: 'Mercado icônico de Belém',
      ),
    ),
    const Marker(
      markerId: MarkerId('mangal-das-garcas'),
      position: LatLng(-1.4592, -48.4896),
      infoWindow: InfoWindow(
        title: 'Mangal das Garças',
        snippet: 'Parque ecológico com aves e natureza',
      ),
    ),
    const Marker(
      markerId: MarkerId('estacao-das-docas'),
      position: LatLng(-1.4521, -48.5033),
      infoWindow: InfoWindow(
        title: 'Estação das Docas',
        snippet: 'Complexo turístico e gastronômico',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Mapa de Belém do Pará')),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(-1.4558, -48.4902),
          zoom: 14,
        ),
        markers: _markers,
      ),
    );
}

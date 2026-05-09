import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/place_model.dart';
import 'place_detail_screen.dart';

class MapScreen extends StatelessWidget {
  final List<Place> places;
  const MapScreen({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade700,
          title: const Text("Map View", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: Text("No places to show.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Map View",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(places.first.latitude, places.first.longitude),
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: places.map((place) {
              return Marker(
                point: LatLng(place.latitude, place.longitude),
                width: 44,
                height: 44,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailScreen(place: place),
                    ),
                  ),
                  child: Tooltip(
                    message: "${place.name}\n${place.address}",
                    child: Icon(
                      place.type == "cafe"
                          ? Icons.local_cafe
                          : Icons.restaurant,
                      color: Colors.orange.shade700,
                      size: 40,
                      shadows: const [
                        Shadow(color: Colors.black26, blurRadius: 6)
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
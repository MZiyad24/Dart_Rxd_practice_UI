import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/place_model.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  Position? _currentPosition;
  double? _distanceKm;
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Location services disabled");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission permanently denied");
      }

      final position = await Geolocator.getCurrentPosition();
      final distanceMeters = Geolocator.distanceBetween(
        position.latitude, position.longitude,
        widget.place.latitude, widget.place.longitude,
      );

      setState(() {
        _currentPosition = position;
        _distanceKm = distanceMeters / 1000;
        _loadingLocation = false;
      });
    } catch (e) {
      setState(() => _loadingLocation = false);
      debugPrint("Location error: $e");
    }
  }

  void _openDirections() async {
    if (_currentPosition == null) return;
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}"
      "&destination=${widget.place.latitude},${widget.place.longitude}"
      "&travelmode=driving",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Color getTypeColor(String type) =>
      type == "cafe" ? Colors.brown : Colors.deepOrange;

  IconData getTypeIcon(String type) =>
      type == "cafe" ? Icons.local_cafe : Icons.restaurant;

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    final markers = [
      Marker(
        point: LatLng(place.latitude, place.longitude),
        width: 44, height: 44,
        child: Tooltip(
          message: place.name,
          child: Icon(Icons.location_pin,
              color: Colors.orange.shade700, size: 44,
              shadows: const [Shadow(color: Colors.black26, blurRadius: 6)]),
        ),
      ),
      if (_currentPosition != null)
        Marker(
          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          width: 44, height: 44,
          child: const Tooltip(
            message: "Your Location",
            child: Icon(Icons.my_location, color: Colors.blue, size: 40),
          ),
        ),
    ];

    // straight line between user and place
    final polylines = _currentPosition == null
        ? <Polyline>[]
        : [
            Polyline(
              points: [
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                LatLng(place.latitude, place.longitude),
              ],
              color: Colors.orange.shade700,
              strokeWidth: 3,
              pattern: StrokePattern.dashed(segments: [12, 6]),
            ),
          ];

    // map center: midpoint between user and place if we have location
    final mapCenter = _currentPosition == null
        ? LatLng(place.latitude, place.longitude)
        : LatLng(
            (_currentPosition!.latitude + place.latitude) / 2,
            (_currentPosition!.longitude + place.longitude) / 2,
          );

    final mapZoom = _currentPosition == null ? 14.0 : 11.0;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          place.name,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              place.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getTypeColor(place.type).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(getTypeIcon(place.type),
                                size: 16, color: getTypeColor(place.type)),
                            const SizedBox(width: 4),
                            Text(
                              place.type.toUpperCase(),
                              style: TextStyle(
                                  color: getTypeColor(place.type),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(place.address,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey.shade700)),
                      ),
                    ],
                  ),

                  const Divider(height: 24),

                  const Text(
                    "Menu items",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: place.products.map((p) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Text(
                          p.toString(),
                          style: TextStyle(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: _loadingLocation
                  ? const Row(
                      children: [
                        SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.orange),
                        ),
                        SizedBox(width: 12),
                        Text("Getting your location…"),
                      ],
                    )
                  : _distanceKm == null
                      ? Row(
                          children: [
                            const Icon(Icons.location_off, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text("Could not get your location.",
                                style:
                                    TextStyle(color: Colors.grey.shade600)),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.directions_car,
                                  color: Colors.orange.shade700, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${_distanceKm!.toStringAsFixed(2)} km away",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("from your current location",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500)),
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: _openDirections,
                              icon: const Icon(Icons.navigation,
                                  color: Colors.white, size: 18),
                              label: const Text("Directions",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade700,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: SizedBox(
                  height: 280,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: mapCenter,
                      initialZoom: mapZoom,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      if (polylines.isNotEmpty)
                        PolylineLayer(polylines: polylines),
                      MarkerLayer(markers: markers),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
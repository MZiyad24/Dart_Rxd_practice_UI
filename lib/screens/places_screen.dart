import 'package:flutter/material.dart';
import '../blocs/place_bloc.dart';
import '../models/place_model.dart';
import 'products_screen.dart';
import '../services/storage_service.dart';
import 'auth/login_screen.dart';
import 'search_screen.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() =>
      _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final bloc = PlaceBloc();
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    bloc.fetchPlaces();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    await _storage.deleteToken();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Color getTypeColor(String type) {
    if (type == "cafe") {
      return Colors.brown;
    }
    return Colors.deepOrange;
  }

  IconData getTypeIcon(String type) {
    if (type == "cafe") {
      return Icons.local_cafe;
    }
    return Icons.restaurant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade700,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.location_city, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            const Text(
              "Places",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen()),
              ),
              icon: const Icon(Icons.search, color: Colors.white, size: 20),
              label: const Text(
                "Search by product",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(width: 8),
            InkWell(
              onTap: logout,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: const [],
      ),
      body: StreamBuilder<List<Place>>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading data"),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final places = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: places.length,
            itemBuilder: (context, index) {
              final p = places[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      child: Image.network(
                        p.image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: getTypeColor(p.type)
                                      .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      getTypeIcon(p.type),
                                      size: 18,
                                      color: getTypeColor(p.type),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      p.type.toUpperCase(),
                                      style: TextStyle(
                                        color: getTypeColor(p.type),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.red, size: 20),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  p.address,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductsScreen(place: p),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.orange.shade700,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                "View Products",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../services/place_service.dart';
import '../models/place_model.dart';
import 'map_screen.dart';
import 'place_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PlaceService _service = PlaceService();

  bool isLoading = true;
  List<Place> places = [];
  List<Place> filteredPlaces = [];
  String? selectedProduct;

  @override
  void initState() {
    super.initState();
    loadPlaces();
  }

  void loadPlaces() async {
    try {
      final data = await _service.getPlaces();
      setState(() {
        places = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error: $e");
    }
  }

  void filterByProduct(String product) {
    if (selectedProduct == product) {
      setState(() {
        selectedProduct = null;
        filteredPlaces = [];
      });
      return;
    }

    final results = places.where((place) {
      return place.products
          .map((e) => e.toString().toLowerCase())
          .contains(product.toLowerCase());
    }).toList();

    setState(() {
      selectedProduct = product;
      filteredPlaces = results;
    });
  }

  List<String> getAllProducts() {
    final Set<String> products = {};
    for (var place in places) {
      for (var p in place.products) {
        products.add(p.toString());
      }
    }
    return products.toList();
  }

  Color getTypeColor(String type) =>
      type == "cafe" ? Colors.brown : Colors.deepOrange;

  IconData getTypeIcon(String type) =>
      type == "cafe" ? Icons.local_cafe : Icons.restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade700,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text(
              "Search",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          if (selectedProduct != null && filteredPlaces.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MapScreen(places: filteredPlaces)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.map, color: Colors.white),
                    SizedBox(width: 5),
                    Text("Map",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          "Select a product",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: getAllProducts().map((product) {
                            final isSelected = selectedProduct == product;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => filterByProduct(product),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.orange.shade700
                                        : Colors.orange.shade50,
                                    borderRadius:
                                        BorderRadius.circular(30),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.orange.shade700
                                          : Colors.orange.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    product,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.orange.shade800,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectedProduct != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                    child: Text(
                      filteredPlaces.isEmpty
                          ? 'No results for "$selectedProduct"'
                          : '${filteredPlaces.length} place${filteredPlaces.length > 1 ? 's' : ''} serve "$selectedProduct"',
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  ),
                Expanded(
                  child: selectedProduct == null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.touch_app,
                                  size: 64, color: Colors.orange.shade200),
                              const SizedBox(height: 16),
                              Text(
                                "Tap a product above\nto find places that serve it",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : filteredPlaces.isEmpty
                          ? Center(
                              child: Text("No restaurants found.",
                                  style: TextStyle(
                                      color: Colors.grey.shade500)),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredPlaces.length,
                              itemBuilder: (context, index) {
                                final place = filteredPlaces[index];

                                return Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.07),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Icon avatar
                                        Container(
                                          width: 54,
                                          height: 54,
                                          decoration: BoxDecoration(
                                            color: getTypeColor(place.type)
                                                .withOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Icon(
                                            getTypeIcon(place.type),
                                            color: getTypeColor(place.type),
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 14),

                                        // Name + address
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                place.name,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons.location_on,
                                                      color: Colors.red,
                                                      size: 14),
                                                  const SizedBox(width: 3),
                                                  Expanded(
                                                    child: Text(
                                                      place.address,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .grey.shade600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PlaceDetailScreen(
                                                      place: place),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.orange.shade700,
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.navigation,
                                                  color: Colors.white,
                                                  size: 20),
                                              SizedBox(height: 2),
                                              Text("Go",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ],
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
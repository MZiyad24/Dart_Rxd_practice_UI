import 'package:flutter/material.dart';
import '../blocs/search_bloc.dart';
import 'map_screen.dart';
import 'place_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {
  final SearchBloc bloc = SearchBloc();

  @override
  void initState() {
    super.initState();
    bloc.loadPlaces();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Color getTypeColor(String type) =>
      type == "cafe"
          ? Colors.brown
          : Colors.deepOrange;

  IconData getTypeIcon(String type) =>
      type == "cafe"
          ? Icons.local_cafe
          : Icons.restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF5F5F5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            Colors.orange.shade700,
        centerTitle: true,
        title: const Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(Icons.search,
                color: Colors.white,
                size: 28),
            SizedBox(width: 10),
            Text(
              "Search",
              style: TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          StreamBuilder<String?>(
            stream:
                bloc.selectedProduct,
            builder:
                (context, selectedSnap) {
              return StreamBuilder(
                stream:
                    bloc.filteredPlaces,
                builder:
                    (context, filteredSnap) {
                  final selected =
                      selectedSnap.data;

                  final filtered =
                      filteredSnap.data ??
                          [];

                  if (selected ==
                          null ||
                      filtered.isEmpty) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                            right: 10),
                    child: InkWell(
                      onTap: () =>
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MapScreen(
                            places:
                                filtered,
                          ),
                        ),
                      ),
                      child:
                          const Row(
                        children: [
                          Icon(Icons.map,
                              color: Colors
                                  .white),
                          SizedBox(
                              width: 5),
                          Text(
                            "Map",
                            style:
                                TextStyle(
                              color: Colors
                                  .white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),

      body: StreamBuilder<bool>(
        stream: bloc.isLoading,
        builder:
            (context, loadingSnap) {
          final isLoading =
              loadingSnap.data ??
                  true;

          if (isLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Colors.orange,
              ),
            );
          }

          return Column(
            children: [
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets
                        .symmetric(
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.only(
                        left: 16,
                        bottom: 8,
                      ),
                      child: Text(
                          "Select a product"),
                    ),

                    SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal,
                      child: Row(
                        children: bloc
                            .getAllProducts()
                            .map(
                              (product) {
                            return StreamBuilder<
                                String?>(
                              stream: bloc
                                  .selectedProduct,
                              builder:
                                  (context,
                                      snap) {
                                final isSelected =
                                    snap.data ==
                                        product;

                                return GestureDetector(
                                  onTap: () => bloc
                                      .filterByProduct(
                                          product),
                                  child:
                                      Container(
                                    margin:
                                        const EdgeInsets
                                            .only(
                                            right:
                                                8),
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal:
                                          16,
                                      vertical:
                                          8,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: isSelected
                                          ? Colors.orange
                                              .shade700
                                          : Colors.orange
                                              .shade50,
                                      borderRadius:
                                          BorderRadius.circular(
                                              30),
                                    ),
                                    child:
                                        Text(
                                      product,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: StreamBuilder<
                    List>(
                  stream: bloc
                      .filteredPlaces,
                  builder:
                      (context, snap) {
                    final places =
                        snap.data ?? [];

                    final selected =
                        bloc
                            .currentSelectedProduct;

                    if (selected ==
                        null) {
                      return const Center(
                        child: Text(
                          "Tap a product above",
                        ),
                      );
                    }

                    if (places
                        .isEmpty) {
                      return const Center(
                        child: Text(
                          "No restaurants found.",
                        ),
                      );
                    }

                    return ListView.builder(
                      padding:
                          const EdgeInsets
                              .all(16),
                      itemCount:
                          places.length,
                      itemBuilder:
                          (context,
                              index) {
                        final place =
                            places[
                                index];

                        return Card(
                          child:
                              ListTile(
                            title: Text(
                                place.name),
                            subtitle:
                                Text(place
                                    .address),
                            trailing:
                                ElevatedButton(
                              onPressed:
                                  () {
                                Navigator
                                    .push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            PlaceDetailScreen(
                                      place:
                                          place,
                                    ),
                                  ),
                                );
                              },
                              child:
                                  const Text(
                                      "Go"),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
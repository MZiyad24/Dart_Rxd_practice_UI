import 'package:flutter/material.dart';

import '../models/place_model.dart';

class ProductsScreen extends StatelessWidget {
  final Place place;

  const ProductsScreen({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        centerTitle: true,

        title: Text(
          place.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// IMAGE
            Image.network(
              place.image,

              height: 250,
              width: double.infinity,

              fit: BoxFit.cover,

              errorBuilder:
                  (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey.shade300,

                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 60,
                    ),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  /// NAME
                  Text(
                    place.name,

                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ADDRESS
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: Text(
                          place.address,

                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// PRODUCTS TITLE
                  const Text(
                    "Products",

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// PRODUCTS LIST
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount:
                        place.products.length,

                    itemBuilder: (context, index) {
                      final product =
                          place.products[index];

                      return Container(
                        margin:
                            const EdgeInsets.only(
                          bottom: 14,
                        ),

                        padding:
                            const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.05),

                              blurRadius: 8,

                              offset:
                                  const Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [

                            /// ICON
                            Container(
                              padding:
                                  const EdgeInsets.all(
                                12,
                              ),

                              decoration: BoxDecoration(
                                color:
                                    Colors.orange.shade100,

                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),

                              child: Icon(
                                Icons.fastfood,
                                color:
                                    Colors.orange.shade800,
                              ),
                            ),

                            const SizedBox(width: 16),

                            /// PRODUCT NAME
                            Expanded(
                              child: Text(
                                product.toString(),

                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
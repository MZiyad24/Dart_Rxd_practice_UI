import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/place_model.dart';

class PlaceService {
  final String baseUrl = "http://localhost:3000";

  Future<List<Place>> getPlaces() async {
    final response = await http.get(
      Uri.parse('$baseUrl/places'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => Place.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load places");
    }
  }
}
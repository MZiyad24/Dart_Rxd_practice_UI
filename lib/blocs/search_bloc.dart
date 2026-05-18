import 'package:rxdart/rxdart.dart';
import '../models/place_model.dart';
import '../services/place_service.dart';

class SearchBloc {
  final PlaceService _service = PlaceService();

  // Subjects
  final _loadingController =
      BehaviorSubject<bool>.seeded(true);

  final _placesController =
      BehaviorSubject<List<Place>>.seeded([]);

  final _filteredPlacesController =
      BehaviorSubject<List<Place>>.seeded([]);

  final _selectedProductController =
      BehaviorSubject<String?>.seeded(null);

  // Streams
  Stream<bool> get isLoading =>
      _loadingController.stream;

  Stream<List<Place>> get places =>
      _placesController.stream;

  Stream<List<Place>> get filteredPlaces =>
      _filteredPlacesController.stream;

  Stream<String?> get selectedProduct =>
      _selectedProductController.stream;

  // Current values
  List<Place> get currentPlaces =>
      _placesController.value;

  List<Place> get currentFilteredPlaces =>
      _filteredPlacesController.value;

  String? get currentSelectedProduct =>
      _selectedProductController.value;

  Future<void> loadPlaces() async {
    try {
      _loadingController.add(true);

      final data = await _service.getPlaces();

      _placesController.add(data);
    } catch (e) {
      print("Error: $e");
    } finally {
      _loadingController.add(false);
    }
  }

  void filterByProduct(String product) {
    final selected = currentSelectedProduct;

    // toggle behavior
    if (selected == product) {
      _selectedProductController.add(null);
      _filteredPlacesController.add([]);
      return;
    }

    final results = currentPlaces.where((place) {
      return place.products
          .map((e) => e.toString().toLowerCase())
          .contains(product.toLowerCase());
    }).toList();

    _selectedProductController.add(product);
    _filteredPlacesController.add(results);
  }

  List<String> getAllProducts() {
    final Set<String> products = {};

    for (var place in currentPlaces) {
      for (var p in place.products) {
        products.add(p.toString());
      }
    }

    return products.toList();
  }

  void dispose() {
    _loadingController.close();
    _placesController.close();
    _filteredPlacesController.close();
    _selectedProductController.close();
  }
}
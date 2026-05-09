import 'package:rxdart/rxdart.dart';

import '../models/place_model.dart';
import '../services/place_service.dart';

class PlaceBloc {
  final PlaceService _service = PlaceService();

  final BehaviorSubject<List<Place>> _subject =
      BehaviorSubject<List<Place>>();

  Stream<List<Place>> get stream =>
      _subject.stream;

  void fetchPlaces() async {
    try {
      final data = await _service.getPlaces();

      _subject.sink.add(data);
    } catch (e) {
      _subject.sink.addError(
        "Error loading places",
      );
    }
  }

  void dispose() {
    _subject.close();
  }
}
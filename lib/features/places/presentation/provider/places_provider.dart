import 'package:flutter/material.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/usecases/get_places_usecase.dart';
import '../../domain/usecases/seed_places_usecase.dart';
import '../../domain/usecases/get_random_places_usecase.dart';
import '../../domain/usecases/toggle_bookmark_usecase.dart';
import '../../domain/usecases/get_bookmarked_place_ids_usecase.dart';

class PlacesProvider extends ChangeNotifier {
  final GetPlacesUseCase getPlacesUseCase;
  final SeedPlacesUseCase seedPlacesUseCase;
  final GetRandomPlacesUseCase getRandomPlacesUseCase;
  final ToggleBookmarkUseCase toggleBookmarkUseCase;
  final GetBookmarkedPlaceIdsUseCase getBookmarkedPlaceIdsUseCase;

  List<PlaceEntity> _allPlaces = [];
  List<PlaceEntity> _filteredPlaces = [];
  List<PlaceEntity> _randomPlaces = [];
  Set<String> _bookmarkedIds = {};
  bool _isLoading = false;
  String? _error;

  List<PlaceEntity> get places => _filteredPlaces;
  List<PlaceEntity> get randomPlaces => _randomPlaces;

  List<PlaceEntity> get bookmarkedPlaces {
    return _allPlaces
        .where((place) => _bookmarkedIds.contains(place.id))
        .toList();
  }

  bool isBookmarked(String placeId) => _bookmarkedIds.contains(placeId);

  bool get isLoading => _isLoading;
  String? get error => _error;

  PlacesProvider({
    required this.getPlacesUseCase,
    required this.seedPlacesUseCase,
    required this.getRandomPlacesUseCase,
    required this.toggleBookmarkUseCase,
    required this.getBookmarkedPlaceIdsUseCase,
  });

  Future<void> fetchPlaces() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First ensure data exists
      await seedPlacesUseCase();

      // Then fetch
      _allPlaces = await getPlacesUseCase();
      _filteredPlaces = List.from(_allPlaces);

      // Also fetch bookmarks
      await fetchBookmarkedIds();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookmarkedIds() async {
    try {
      final ids = await getBookmarkedPlaceIdsUseCase();
      _bookmarkedIds = ids.toSet();
      notifyListeners();
    } catch (e) {
      // Error fetching bookmarks
    }
  }

  Future<void> toggleBookmark(String placeId) async {
    // Optimistic update
    final isCurrentlyBookmarked = _bookmarkedIds.contains(placeId);
    if (isCurrentlyBookmarked) {
      _bookmarkedIds.remove(placeId);
    } else {
      _bookmarkedIds.add(placeId);
    }
    notifyListeners();

    try {
      await toggleBookmarkUseCase(placeId);
    } catch (e) {
      // Revert if error
      if (isCurrentlyBookmarked) {
        _bookmarkedIds.add(placeId);
      } else {
        _bookmarkedIds.remove(placeId);
      }
      notifyListeners();
      _error = e.toString(); // Optionally show error
    }
  }

  Future<void> fetchRandomPlaces() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _randomPlaces = await getRandomPlacesUseCase(6);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredPlaces = List.from(_allPlaces);
    } else {
      _filteredPlaces = _allPlaces
          .where(
            (place) =>
                place.name.toLowerCase().contains(query.toLowerCase()) ||
                place.location.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}

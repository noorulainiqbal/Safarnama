import '../entities/place_entity.dart';

abstract class PlacesRepository {
  Future<List<PlaceEntity>> getPlaces();
  Future<void> seedPlaces();
  Future<List<PlaceEntity>> getRandomPlaces(int count);
  Future<void> toggleBookmark(String placeId);
  Future<List<String>> getBookmarkedPlaceIds();
}

import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/places_repository.dart';
import '../datasources/places_remote_data_source.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDataSource remoteDataSource;

  PlacesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PlaceEntity>> getPlaces() async {
    return await remoteDataSource.getPlaces();
  }

  @override
  Future<void> seedPlaces() async {
    return await remoteDataSource.seedPlaces();
  }

  @override
  Future<List<PlaceEntity>> getRandomPlaces(int count) async {
    final allPlaces = await remoteDataSource.getPlaces();
    // Create a mutable copy to shuffle
    final shuffled = List<PlaceEntity>.from(allPlaces)..shuffle();
    // Return up to 'count' items
    return shuffled.take(count).toList();
  }

  @override
  Future<void> toggleBookmark(String placeId) async {
    return await remoteDataSource.toggleBookmark(placeId);
  }

  @override
  Future<List<String>> getBookmarkedPlaceIds() async {
    return await remoteDataSource.getBookmarkedPlaceIds();
  }
}

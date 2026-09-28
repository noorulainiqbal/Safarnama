import '../repositories/places_repository.dart';

class GetBookmarkedPlaceIdsUseCase {
  final PlacesRepository repository;

  GetBookmarkedPlaceIdsUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getBookmarkedPlaceIds();
  }
}

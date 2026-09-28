import '../repositories/places_repository.dart';

class ToggleBookmarkUseCase {
  final PlacesRepository repository;

  ToggleBookmarkUseCase(this.repository);

  Future<void> call(String placeId) {
    return repository.toggleBookmark(placeId);
  }
}
